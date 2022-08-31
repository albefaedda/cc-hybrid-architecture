/* Create Streams and tables for groceries_shop the topics. 
You don't need to define any columns in the CREATE statement. 
ksqlDB infers this information automatically from the latest 
registered schema for the topic. 
ksqlDB uses the most recent schema at the time the statement is first executed.
*/


/* Sellers table */

CREATE STREAM sellers
    WITH (KAFKA_TOPIC='postgres.grocery_shop.sellers',
        VALUE_FORMAT='AVRO'
);

/* Customers table */

CREATE STREAM customers 
    WITH (KAFKA_TOPIC='postgres.grocery_shop.customers',
        VALUE_FORMAT='AVRO'
);

/* Products table */

CREATE STREAM products 
    WITH (KAFKA_TOPIC='postgres.grocery_shop.products',
        VALUE_FORMAT='AVRO'
);

/* Orders stream */

CREATE STREAM orders 
    WITH (KAFKA_TOPIC='postgres.grocery_shop.orders',
        VALUE_FORMAT='AVRO'
);


/* Explode Order Items*/

create stream single_product_orders as 
select 
order_id, customer_id, 
CAST(TRIM(EXPLODE(SPLIT(SUBSTRING(ITEMS_ORDERED, 2,  LEN(ITEMS_ORDERED) -2), ','))) as INT) as item_ordered, 
ORDER_STATUS as order_status, 
TRACKING_NUMBER as tracking_number, 
CREATE_TIME as create_time, 
LAST_UPDATE_TIME as last_update_time
from ORDERS PARTITION by ORDER_ID 
EMIT CHANGES;


/* Calculating the cost of an order and creating a customer reporting view of the most up to date status of each order */

select o.order_id, c.customer_name, sum(p.product_cost) as order_price, o.order_status, o.create_time
from single_product_orders o join products p
WITHIN 10 MINUTES on o.item_ordered = p.product_id
join customers c 
WITHIN 10 MINUTES on o.customer_id = c.customer_id
GROUP by o.order_id, c.customer_name, o.order_status, o.create_time
EMIT CHANGES;

/* Tracking each customer's total spend */

select c.customer_name, sum(p.product_cost) as customer_total_spend
from single_product_orders o join products p
WITHIN 1 MINUTE on o.item_ordered = p.product_id
join  customers c 
WITHIN 1 MINUTE on o.customer_id = c.customer_id
GROUP by c.customer_name
EMIT CHANGES;

/* Tracking each seller's total revenue */

select s.seller_name, sum(p.product_cost) as seller_total_revenue
from single_product_orders o join products p
WITHIN 10 MINUTES on o.item_ordered = p.product_id
join  sellers s
WITHIN 10 MINUTES on p.seller_id = s.seller_id
GROUP by s.seller_name
EMIT CHANGES;

/* Hourly snapshots of order status */



/* Current inventory of marketplace items */

select * 
from products 
where product_quantity > 0;

/* Average monthly spend across the marketplace (per customer and total) */