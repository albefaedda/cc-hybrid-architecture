# Create Postgresql deployment for GKE/Kubernetes

Connect to the Kubernetes cluster. 

```sh
gcloud container clusters get-credentials afaedda-gke --region <your-gcloud-region> --project solutionsarchitect-01
```

Make sure you can see the Kubernetes cluster namespaces:

```sh
kubectl get ns
```

Apply Postgres ConfigMap with db-name, user and password

```sh
kubectl apply -f postgres-configmap.yaml
```

Create a Persistent Volume to store Postgres Data

```sh
kubectl apply -f postgres-volume.yaml
```

Create a Persistent Volume Claim for your Postgres deployment

```sh
kubectl apply -f postgres-pvc.yaml
```

Create a Kubernetes deployment

```sh
kubectl apply -f postgres-deployment.yaml
```

Connect to the postgres database

```sh
kubectl exec -it <pod-name> -- psql -h <host-name> -U appuser --password -p 5432 groceries-mp-db
```