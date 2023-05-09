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
cd confluent-for-k8s/helm

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

yq '.spec.dependencies.schemaRegistry.url = "https://psrc-kk5gg.europe-west3.gcp.confluent.cloud" | .spec.dependencies.kafka.bootstrapEndpoint = "pkc-l6wr6.europe-west2.gcp.confluent.cloud:9092"' kafka-connect.yaml | kubectl apply -f -

Start JDBC Source Connector for Postgres (with CRD):
```sh

kubectl apply -f jdbc-connector.yaml

```


Start JDBC Source Connector for Postgres : 

```sh
kubectl apply -f jdbc-connector.yaml
```