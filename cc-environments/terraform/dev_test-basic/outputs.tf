output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.dev-test.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.basic.id}

  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):
  ${confluent_service_account.app-manager.display_name}:                     ${confluent_service_account.app-manager.id}
  ${confluent_service_account.app-manager.display_name}'s Kafka API Key:     "${confluent_api_key.app-manager-kafka-api-key.id}"
  ${confluent_service_account.app-manager.display_name}'s Kafka API Secret:  "${confluent_api_key.app-manager-kafka-api-key.secret}"
  
  ${confluent_service_account.ksql-sa.display_name}:                    ${confluent_service_account.ksql-sa.id}
  ${confluent_service_account.ksql-sa.display_name}'s Kafka API Key:    "${confluent_api_key.ksql-sa-kafka-api-key.id}"
  ${confluent_service_account.ksql-sa.display_name}'s Kafka API Secret: "${confluent_api_key.ksql-sa-kafka-api-key.secret}"
  
  ${confluent_service_account.kstreams-sa.display_name}:                    ${confluent_service_account.kstreams-sa.id}
  ${confluent_service_account.kstreams-sa.display_name}'s Kafka API Key:    "${confluent_api_key.kstreams-kafka-api-key.id}"
  ${confluent_service_account.kstreams-sa.display_name}'s Kafka API Secret: "${confluent_api_key.kstreams-kafka-api-key.secret}"

  ${confluent_service_account.connect-sa.display_name}:                    ${confluent_service_account.connect-sa.id}
  ${confluent_service_account.connect-sa.display_name}'s Kafka API Key:    "${confluent_api_key.connect-kafka-api-key.id}"
  ${confluent_service_account.connect-sa.display_name}'s Kafka API Secret: "${confluent_api_key.connect-kafka-api-key.secret}"

  EOT

  sensitive = true
}