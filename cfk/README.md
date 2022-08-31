# Deploy Connect cluster to GKE

Create confluent namespace and switch context to it

```sh
kubectl create namespace confluent

kubectl config set-context --current --namespace confluent
```


Pull the helm charts for CFK Operator 
```sh
curl -O https://confluent-for-kubernetes.s3-us-west-1.amazonaws.com/confluent-for-kubernetes-2.4.1.tar.gz
```

Move to the helm dir inside the unarchived package and install the chart

```sh
cd confluent-for-kubernetes/helm

helm upgrade --install confluent-operator \
  ./confluent-for-kubernetes \
  --namespace confluent
```

Install Confluent CRDs (if not installed automatically)

```sh
kubectl apply -f crds
```

Create K8s secrets for kafka connect to use cc and schema-registry

```sh 
both these files have this structure: 

username=<api-key>
password=<secret-key>


kubectl create secret generic ccloud-credentials --from-file=plain.txt=ccloud-connect-credentials.txt
kubectl create secret generic ccloud-sr-credentials --from-file=basic.txt=ccloud-sr-credentials.txt
```

Create K8s secrets and jdbc connection for postgres
```sh
This file has structure: 

connectinon=jdbc:<db-container-name>:<container-port>/<db-name>?schema=<schema-name>&user=<username>&password=<password>

kubectl create secret generic postgres-credentials --from-file=plain.txt=postgres-creds.txt
```

Deploy Connect Server providing kafka bootstrap-server and schema registry url including context for distinction of env cluster (e.g. dev/test)
```sh 
yq '.spec.dependencies.schemaRegistry.url = "<schema-registry-url>/contexts/[.dev|.test|prd]" | .spec.dependencies.kafka.bootstrapEndpoint = "<kafka-bootstrap-server>"' kafka-connect.yaml | kubectl apply -f -
```

yq '.spec.dependencies.schemaRegistry.url = "https://psrc-2312y.europe-west3.gcp.confluent.cloud" | .spec.dependencies.kafka.bootstrapEndpoint = "pkc-l6wr6.europe-west2.gcp.confluent.cloud:9092"' kafka-connect.yaml | kubectl apply -f -



Start JDBC Source Connector for Postgres: 

```sh
Exec into bash of the connect-server pod 

kubectl exec connect-0 -it -n confluent -- bash

Delete connector, if needed: 

curl -X DELETE http://localhost:8083/connectors/debezium-postgres-source

/* ALL */

curl -X POST -H "Content-Type: application/json"  --data '{ "name": "jdbc-grocery-shop", "config": { "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector", 
 "connection.url": "jdbc:postgresql://postgres.default:5432/groceries-mp-db?schema=grocery_shop&user=appuser&password=$7r0ngp4$$word4pp", "schema.pattern": "grocery_shop", "catalog.pattern": "grocery_shop", "table.whitelist": "sellers,customers,products,orders", "tables": "sellers,customers,products,orders", "mode": "timestamp", "timestamp.column.name":"last_update_time", "topic.prefix": "postgres.grocery_shop.", "task.max": "1" } }'  http://localhost:8083/connectors/

/* SELLERS */

curl -X POST -H "Content-Type: application/json"  --data '{ "name": "grocery-shop-sellers", "config": { "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector", 
 "connection.url": "jdbc:postgresql://postgres.default:5432/groceries-mp-db?schema=grocery_shop&user=appuser&password=$7r0ngp4$$word4pp", "schema.pattern": "grocery_shop", "catalog.pattern": "grocery_shop", "table.whitelist": "sellers", "tables": "sellers", "mode": "timestamp", "timestamp.column.name":"last_update_time", "topic.prefix": "postgres.grocery_shop.", "task.max": "1" } }'  http://localhost:8083/connectors/

/* CUSTOMERS */

curl -X POST -H "Content-Type: application/json"  --data '{ "name": "grocery-shop-customers", "config": { "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector", 
 "connection.url": "jdbc:postgresql://postgres.default:5432/groceries-mp-db?schema=grocery_shop&user=appuser&password=$7r0ngp4$$word4pp", "schema.pattern": "grocery_shop", "catalog.pattern": "grocery_shop", "table.whitelist": "customers", "tables": "customers", "mode": "timestamp", "timestamp.column.name":"last_update_time", "topic.prefix": "postgres.grocery_shop.", "task.max": "1" } }'  http://localhost:8083/connectors/

/* PRODUCTS */

curl -X POST -H "Content-Type: application/json"  --data '{ "name": "grocery-shop-products", "config": { "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector", 
 "connection.url": "jdbc:postgresql://postgres.default:5432/groceries-mp-db?schema=grocery_shop&user=appuser&password=$7r0ngp4$$word4pp", "schema.pattern": "grocery_shop", "catalog.pattern": "grocery_shop", "table.whitelist": "products", "tables": "products", "mode": "timestamp", "timestamp.column.name":"last_update_time", "topic.prefix": "postgres.grocery_shop.", "task.max": "1" } }'  http://localhost:8083/connectors/

/* ORDERS */

 curl -X POST -H "Content-Type: application/json"  --data '{ "name": "grocery-shop-orders", "config": { "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector", 
 "connection.url": "jdbc:postgresql://postgres.default:5432/groceries-mp-db?schema=grocery_shop&user=appuser&password=$7r0ngp4$$word4pp", "schema.pattern": "grocery_shop", "catalog.pattern": "grocery_shop", "table.whitelist": "orders", "tables": "orders", "mode": "timestamp", "timestamp.column.name":"last_update_time","topic.prefix": "postgres.grocery_shop.", "task.max": "1" } }'  http://localhost:8083/connectors/

```


In Confluuent Cloud, KSQLDB doesn't automatically infer the schema and fields of the messages in the topics when using schema-registry contexts

