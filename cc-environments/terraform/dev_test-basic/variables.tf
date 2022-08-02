variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  type = string
  description = "The name of the cluster"
}

variable "provder" {
  type = string
  description = "The cloud provider where to create the cluster"
}

variable "region" {
  type = string
  description = "The cloudregion where to create the cluster"
}

variable "topics" {
  description = "A list of topics to be created"
  type = set(string)
}

variable "kstreams_app_id_prefix" {
    type = string
    description = "The kstreams app.id prefix used to write to Kafka Topics"  
}

variable "jdbc_connect_group_id" {
    type = string
    description = "The name or group.id the JDBC Source Connector uses to write to Kafka Topics"  
}