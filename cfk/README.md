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
  --namespace <namespace>
```

Install Confluent CRDs (if not installed automatically)

```sh
kubectl apply -f crds
```

Create K8s secrets for ccloud cluster and schema-registry

```sh 
both these files have this structure: 

username=<api-key>
password=<secret-key>


kubectl create secret generic ccloud-credentials --from-file=plain.txt=ccloud-credentials.txt  
kubectl create secret generic ccloud-sr-credentials --from-file=basic.txt=ccloud-sr-credentials.txt
```

Create K8s secrets and jdbc connection for postgres
```sh
This file has structure: 

connectinon=jdbc:<db-container-name>:<container-port>/<db-name>?user=<username>&password=<password>

kubectl create secret generic postgres-credentials --from-file=plain.txt=postgres-creds.txt  
```

Deploy Connect Server
```sh 
kubectl apply -f kafka-connect.yaml
```

