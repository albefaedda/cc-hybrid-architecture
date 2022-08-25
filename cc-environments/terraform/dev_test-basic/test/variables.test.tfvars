cluster_name = "test"
provder = "GCP"
region = "europe-west2"
topics = [ "postgres.grocery_shop.customers", "postgres.grocery_shop.sellers", "postgres.grocery_shop.products", "postgres.grocery_shop.orders" ]
kstreams_app_id_prefix = "streams_"
jdbc_connect_group_id = "groceries_mp_jdbc_source_connector"