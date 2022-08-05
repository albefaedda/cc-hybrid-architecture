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

Connect to the postgres database, connect to db using psql command and run sql statements to create tables and insert data

```sh

kubectl exec -it <postgres-pod> -- /bin/bash

psql -U appuser -p 5432 -d groceries-mp-db

manage the database 
\c groceries-mp-db

create enum and describe with: 
select enum_range(null::status)

create tables and describe with: 
\d customers;
\d orders;
\d products;
\d sellers;

insert data into tables and query them to make sure inserts succeeded

```

