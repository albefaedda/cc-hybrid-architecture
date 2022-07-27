terraform {
  backend "gcs" {
    bucket      = "afaedda-tf-state"
    prefix      = "terraform/state"
    credentials = "./tf-gke-keyfile.json"
  }
}

