terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.0.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "dev-test" {
  display_name = "Dev-Test"
}

resource "confluent_kafka_cluster" "basic" {
  display_name = "groceries-mp-${var.cluster_name}"
  availability = "SINGLE_ZONE"
  cloud        = var.provder
  region       = var.region
  basic {}
  environment {
    id = confluent_environment.dev-test.id
  }
}

// 'app-manager' service account is required in this configuration to create topics and assign roles
// to the different service accounts.
resource "confluent_service_account" "app-manager" {
  display_name = "app-manager-${var.cluster_name}"
  description  = "Service account to manage the Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.basic.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key-${var.cluster_name}"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = confluent_environment.dev-test.id
    }
  }

  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

resource "confluent_kafka_topic" "topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  for_each = var.topics

  topic_name    = each.key
  partitions_count = 3
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  config = {
    "retention.ms" = "31556926000"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_service_account" "kstreams-sa" {
  display_name = "kstreams-sa-${var.cluster_name}"
  description  = "Service account for KStreams"
}

resource "confluent_api_key" "kstreams-kafka-api-key" {
  display_name = "kstreams-sa-kafka-api-key-${var.cluster_name}"
  description  = "Kafka API Key that is owned by 'kstreams-sa' service account"
  owner {
    id          = confluent_service_account.kstreams-sa.id
    api_version = confluent_service_account.kstreams-sa.api_version
    kind        = confluent_service_account.kstreams-sa.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = confluent_environment.dev-test.id
    }
  }
}

resource "confluent_service_account" "connect-sa" {
  display_name = "connect-sa-${var.cluster_name}"
  description  = "Service account for Connect"
}

resource "confluent_api_key" "connect-kafka-api-key" {
  display_name = "connect-sa-kafka-api-key-${var.cluster_name}"
  description  = "Kafka API Key that is owned by 'connect-sa' service account"
  owner {
    id          = confluent_service_account.connect-sa.id
    api_version = confluent_service_account.connect-sa.api_version
    kind        = confluent_service_account.connect-sa.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

    environment {
      id = confluent_environment.dev-test.id
    }
  }
}

resource "confluent_kafka_acl" "kstreams-sa-write-on-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  for_each = var.topics

  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topics[each.value].topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.kstreams-sa.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "kstreams-sa-read-on-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  
  resource_type = "GROUP"
  // The existing values of resource_name, pattern_type attributes are set up to match Confluent CLI's default consumer group ID ("confluent_cli_consumer_<uuid>").
  // https://docs.confluent.io/confluent-cli/current/command-reference/kafka/topic/confluent_kafka_topic_consume.html
  // Update the values of resource_name, pattern_type attributes to match your target consumer group ID.
  // https://docs.confluent.io/platform/current/kafka/authorization.html#prefixed-acls
  resource_name = var.kstreams_app_id_prefix
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.kstreams-sa.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-sa-describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}


resource "confluent_kafka_acl" "connect-sa-write-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  for_each = var.topics

  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topics[each.value].topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-sa-create-on-connect-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "confluent.connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-sa-write-on-connect-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "confluent.connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-sa-read-on-connect-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "GROUP"
  resource_name = "confluent.connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "connect-sa-read-on-connect-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  resource_type = "TOPIC"
  resource_name = "confluent.connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connect-sa.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
