# Create CC clusters with terraform

To be able to create Confluent Cloud clusters with Terraform, make sure to have a CC account and a cloud Api Key and Secret Key for you to be able to run the configurations. 

Once you have created these, you need to export them in your terminal:

```sh
export TF_VAR_confluent_cloud_api_key=<your-api-key>

export TF_VAR_confluent_cloud_api_secret=<your-api-secret>
```

To be able to run the Terraform configs you then need to set the variables.
You can set these in a tfvars file (recommended) or provide them when running plan/apply 
```sh 
cluster_name = <your-cluster-name>
provder = <AWS|GCP|AZURE>
region = <cloud-region>
topics = [ "postgres.grocery_shop.customers", "postgres.grocery_shop.sellers", "postgres.grocery_shop.products", "postgres.grocery_shop.orders" ]
kstreams_app_id_prefix = <this is used to authorize streams apps>
jdbc_connect_group_id = <this is used to authorize source connector>
```

Init, Plan, Apply your Terraform Configuration to create CC environment and cluster

```sh
terraform init
terraform plan -var-file=<your-tfvars-file>
terraform apply -var-file=<your-tfvars-file>
```