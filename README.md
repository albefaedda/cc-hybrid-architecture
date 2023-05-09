# cc-hybrid-architecture
Explore Confluent Ecosystem and different deployment and application design type

Create Confluent Cloud cluster by following [these](cc-environments/terraform/README.md) instructions
We now need to enable schema registry in the environment before we start ingesting data; follow [these](cc-environments/cli/README_SR.md) instructions. 

Create a Kubernetes cluster in GCP with terraform by following these [instructions](gke-clsuter-terraform/README.md) and deploy Postgresql database following the instructions [here](postgres/README.md)

Once the CC cluster is running, we need to collect cluster information and deploy CFK and the self-managed JDBC connector by following the instructions [here](cfk/README.md)

At this point we should be able to make some transformations with the ingested data from the JDBC connector. Follow [these](cc-environments/cli/README_KSQL.md) instructions to create a ksqldb cluster and get started. 