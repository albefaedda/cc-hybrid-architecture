# Create GKE Cluster with Terraform

## Install Terraform 

```sh
$ brew install terraform
```

## Install Google Cloud CLI

https://cloud.google.com/sdk/docs/install-sdk

```sh
$ gcloud init
```

Project id: solutionsarchitect-01 

Region: < your-gcloud-region >

Enable Compute and Kubernetes APIs

```sh
$ gcloud services enable compute.googleapis.com
$ gcloud services enable container.googleapis.com
```

Create service-account for terraform

```sh
$ cloud iam service-accounts create <your-service-account-name>
``` 

The service-account needs the following project roles to be able to execute the terraform configuration and create the eke cluster: 

roles/compute.viewer
roles/compute.securityAdmin (required if add_cluster_firewall_rules is set to true)
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin (required if - service_account is set to create)

These roles can be assigned to the service account with the following comands:

```sh
$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/compute.admin   
                        
$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/iam.serviceAccountUser                             

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin                             

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/container.clusterAdmin

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/compute.viewer

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/compute.securityAdmin

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/container.developer

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin

$ gcloud projects add-iam-policy-binding solutionsarchitect-01 --member serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
```

Create JSON key file for the service-account that Terraform will use to authenticate with Google Cloud to create the infrastructure. 

```sh
$ gcloud iam service-accounts keys create tf-gke-keyfile.json -—iam-account <your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com
```

Create a GCS bucket where to store the terraform state

```sh
$ gsutil mb -p solutionsarchitect-01 -c regional -l europe-west2 gs://<your-gcs-bucket-name>/
```

Enable versioning in case of accidental deletion or errors:

```sh
$ gsutil versioning set on gs://<your-gcs-bucket-name>/
```

Enable read/write permissions on this bucket for our service account:

```sh
$ gsutil iam ch serviceAccount:<your-service-account-name>@solutionsarchitect-01.iam.gserviceaccount.com:legacyBucketWriter gs://afaedda-tf-state/
```

## Init, Plan and Apply Terraform configuration:

```sh 
$ terraform init
$ terraform plan
$ terraform apply
```