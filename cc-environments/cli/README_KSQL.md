# We need to use the Confluent CLI to enable Schema Registry and KSQLDB cluster for our clusters as these are not yet supported on Confluent Terraform Provider

Login to Confluent Cloud (it'll ask for your email and password)

```sh
confluent login
```

List your environments: 

```sh
confluent env list
```

Select the environment for which you want to enable schema registry and ksqldb:

```sh
confluent env use <env-id>
```

List the clusters running in the selected environment"
```sh
confluent kafka cluster list
```

Select the cluster you want to use
```sh
confluent kafka cluster use <cluster-id>
```

To create KSQLDB cluster you need to create an Api-Key first:

```sh
confluent api-key create --resource "<your-cluster-id>"
```

Set the Api Key as the active one to create the ksqldb cluster:

```sh
confluent api-key use --resource <cluster-id> <your-api-key>
```

To create a ksqldb application from the CLI, run the following command:

```sh
confluent ksql cluster create <cluster-name> --api-key <api-key> --api-secret <secret>
```
