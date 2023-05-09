/* Create Streams and tables for groceries_shop the topics. 
You don't need to define any columns in the CREATE statement. 
ksqlDB infers this information automatically from the latest 
registered schema for the topic. 
ksqlDB uses the most recent schema at the time the statement is first executed.
*/


/* Sellers table */

CREATE TABLE sellers (
	id VARCHAR PRIMARY KEY,
  	seller_name VARCHAR,
  	seller_company VARCHAR,
  	seller_email VARCHAR,
  	seller_address VARCHAR,
  	last_update_time BIGINT
	)
    WITH (KAFKA_TOPIC='postgres.grocery_shop.sellers',
        KEY_FORMAT='AVRO',
        VALUE_FORMAT='AVRO', 
        TIMESTAMP='last_update_time'
);

/* Customers table */

CREATE TABLE customers (
	id VARCHAR PRIMARY KEY, 
	customer_name VARCHAR,
	customer_email VARCHAR,
	customer_address VARCHAR, 
	last_update_time BIGINT
	)
    WITH (KAFKA_TOPIC='postgres.grocery_shop.customers',
        KEY_FORMAT='AVRO',
        VALUE_FORMAT='AVRO', 
        TIMESTAMP='last_update_time'
);

/* Products table */

create table products(
  id INTEGER PRIMARY KEY,
  product_name VARCHAR,
  product_cost double,
  product_quantity integer,
  seller_id VARCHAR,
  last_update_time BIGINT
) WITH (KAFKA_TOPIC='postgres.grocery_shop.products',
        KEY_FORMAT='AVRO',
        VALUE_FORMAT='AVRO', 
        TIMESTAMP='last_update_time'
);

/* Orders stream */

CREATE STREAM orders (
        id INTEGER KEY,
        customer_id VARCHAR,
        items_ordered VARCHAR,
        order_status VARCHAR, 
        tracking_number VARCHAR,
        create_time bigint,
        last_update_time bigint
    )
    WITH (KAFKA_TOPIC='postgres.grocery_shop.orders',
        KEY_FORMAT='AVRO',
        VALUE_FORMAT='AVRO', 
        TIMESTAMP='create_time'
);


/* Explode Order Items*/

create stream single_product_orders as 
select id, customer_id, 
CAST(TRIM(EXPLODE(SPLIT(SUBSTRING(ITEMS_ORDERED, 2,  LEN(ITEMS_ORDERED) -2), ','))) as INT) as item_ordered, 
order_status, 
tracking_number, 
create_time, 
last_update_time
from ORDERS PARTITION by id 
EMIT CHANGES;


/* Calculating the cost of an order and creating a customer reporting view of the most up to date status of each order */

create table order_cost_status as 
select spo.id, c.customer_name, sum(p.product_cost) as order_price, spo.order_status, spo.create_time
from single_product_orders spo join products p
on spo.item_ordered = p.id
join customers c 
on spo.customer_id = c.id
GROUP by spo.id, c.customer_name, spo.order_status, spo.create_time
EMIT CHANGES;

/* Tracking each customer's total spend */

select c.customer_name, sum(p.product_cost) as customer_total_spend
from single_product_orders o join products p
on o.item_ordered = p.id
join  customers c 
on o.customer_id = c.id
GROUP by c.customer_name
EMIT CHANGES;

/* Tracking each seller's total revenue */

select s.seller_name, sum(p.product_cost) as seller_total_revenue
from single_product_orders o join products p
on o.item_ordered = p.id
join  sellers s
on p.seller_id = s.id
GROUP by s.seller_name
EMIT CHANGES;

/* Hourly snapshots of order status */



/* Current inventory of marketplace items */

select * 
from products 
where product_quantity > 0;

/* Average monthly spend across the marketplace (per customer and total) */