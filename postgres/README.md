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

Create postgres service

```sh
kubectl apply -f postgres-service.yaml
```

Connect to the postgres database, connect to db using psql command and run sql statements to create tables and insert data

```sh

kubectl exec -it <postgres-pod> -- /bin/bash

psql -U appuser -p 5432 -d groceries-mp-db

drop schema inventory cascade;

manage the database 
\c groceries-mp-db

Use data.sql to create the database schema and tables and insert data. 

describes with with: 
\d customers;
\d orders;
\d products;
\d sellers;

insert data into tables and query them to make sure inserts succeeded

```

