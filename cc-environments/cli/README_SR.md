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

To enable Schema Registry for the environment, use the following command: 

```sh
confluent schema-registry cluster enable --cloud gcp --geo eu
```

Create an Api-Key for your newly created schema-registry 

```sh
confluent api-key create --resource <schema-registry-id>
```

Put this Api-key on the ccloud-sr-credentials.txt file for cfk to be able to communicate with Schema Registry