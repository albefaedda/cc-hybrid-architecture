# Monitoring with Datadog

First, you need to setup a CC Service Account to use for the integration. 
Datadog will use the API Keys to crawl the Metrics API and obtain metrics. 

```sh

# Log into your Confluent Clount account
confluent login
# Create the service account
confluent iam service-account create DatadogMetricsImporter --description "A service account to import Confluent Cloud metrics into Datadog"

```

Adde the MetrixViewer role to the service account so that it can access Metrics API: 

```sh
confluent iam rbac role-binding create --role MetricsViewer --principal User:<resource-id from previous step>
```

Create API Key for the service account:

```sh 
confluent api-key create --resource cloud --service-account <resource-id>
```

In DataDog, head to the Confluent Cloud Integration tile and add the API Key and Secret Key to the Configuration.
From here, specify the resource-id of the CC resouces you want to monitor.
Within a few minutes you should see the metrics in the dashboard. 