/* Create Database */

CREATE schema grocery_shop;

create type grocery_shop.status as enum('SUBMITTED', 'PROCESSED', 'IN-TRANSIT', 'SHIPPED');

/* Create Tables */
create table if not exists grocery_shop.customers (
    customer_id varchar(15) primary key,
    customer_name varchar(40), 
    customer_email varchar(40),
    customer_address varchar(60)
);

create table if not exists grocery_shop.sellers (
    seller_id varchar(15) primary key,
    seller_name varchar(40),
    seller_company varchar(40), 
    seller_email varchar(40),
    seller_address varchar(60)
);

create table if not exists grocery_shop.products (
    product_id integer primary key,
    product_name varchar(40), 
    product_cost money,
    product_quantity int, 
    seller_id varchar(15),
    product_last_update_time timestamp
);

create table if not exists grocery_shop.orders (
    order_id integer primary key,
    customer_id varchar(15),
    items_ordered varchar(40),
    order_status grocery_shop.status,
    tracking_number varchar(20),
    create_time timestamp,
    last_update_time timestamp
);

/* Insert Customers */
insert into grocery_shop.customers (customer_id, customer_name, customer_email, customer_address) values('53-570-6948', 'Linet Pedroni', 'lpedroni0@whitehouse.gov', '56 Di Loreto Terrace');
insert into grocery_shop.customers (customer_id, customer_name, customer_email, customer_address) values('23-606-4767', 'Peria Olivey', 'polivey1@google.com.br', '593 Thompson Drive');
insert into grocery_shop.customers (customer_id, customer_name, customer_email, customer_address) values('14-786-6861', 'Greg Vane', 'gvane2@skyrock.com', '1 Gale Court');
insert into grocery_shop.customers (customer_id, customer_name, customer_email, customer_address) values('58-308-6113', 'Jeremy Jiri', 'jjiri3@discovery.com', '2 Declaration Pass');
insert into grocery_shop.customers (customer_id, customer_name, customer_email, customer_address) values('19-791-0773', 'Julee Bradnum', 'jbradnum4@so-net.ne.jp', '32 Bluestem Avenue');

/* Insert Sellers */
insert into grocery_shop.sellers (seller_id, seller_name, seller_company, seller_email, seller_address) values('87-017-4611', 'Rad Rainbird', 'Nlounge', 'rrainbird0@blogtalkradio.com', '13 Sundown Way');
insert into grocery_shop.sellers (seller_id, seller_name, seller_company, seller_email, seller_address) values('51-894-3698', 'Clarence Hulstrom', 'Mybuzz', 'chulstrom1@comsenz.com', '26 Iowa Lane');
insert into grocery_shop.sellers (seller_id, seller_name, seller_company, seller_email, seller_address) values('79-156-2194', 'Neddie Labell', 'Wordware', 'nlabell2@shop-pro.jp', '82 Mifflin Alley');
insert into grocery_shop.sellers (seller_id, seller_name, seller_company, seller_email, seller_address) values('50-617-6068', 'Tess Loiterton', 'Skivee', 'tloiterton3@ted.com', '71 Washington Hill');
insert into grocery_shop.sellers (seller_id, seller_name, seller_company, seller_email, seller_address) values('35-950-3000', 'Randie Gresser', 'Skipstorm', 'rgresser4@globo.com', '1 Montana Court');


/* Insert Products */
insert into grocery_shop.products (product_id, product_name, product_cost, product_quantity, seller_id, product_last_update_time) values(1, 'Pork - Caul Fat', '$5.63', 19, '87-017-4611', '2022-07-11 18:58:42'::timestamp);
insert into grocery_shop.products (product_id, product_name, product_cost, product_quantity, seller_id, product_last_update_time) values(2, 'Tarragon - Primerba, Paste', '$27.94', 27, '51-894-3698', '2022-07-09 20:05:52'::timestamp);
insert into grocery_shop.products (product_id, product_name, product_cost, product_quantity, seller_id, product_last_update_time) values(3, 'Bagel - Ched Chs Presliced', '$18.01', 23, '79-156-2194', '2022-07-10 04:32:17'::timestamp);
insert into grocery_shop.products (product_id, product_name, product_cost, product_quantity, seller_id, product_last_update_time) values(4, 'V8 Splash Strawberry Kiwi', '$33.85', 46, '50-617-6068', '2022-07-08 12:52:26'::timestamp);
insert into grocery_shop.products (product_id, product_name, product_cost, product_quantity, seller_id, product_last_update_time) values(5, 'Potatoes - Yukon Gold, 80 Ct', '$33.92', 32, '35-950-3000', '2022-07-11 07:09:15'::timestamp);

/* Insert Orders */ 
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6706, '53-570-6948','[1, 3, 5, 5]', 'SUBMITTED', 'N/A', '2022-07-13 11:54:00'::timestamp,'2022-07-13 11:54:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6707, '23-606-4767',  '[1, 1, 3]', 'SUBMITTED', 'N/A', '2022-07-11 10:25:00'::timestamp, '2022-07-13 11:55:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6708, '14-786-6861', '[2, 4]', 'SUBMITTED', 'N/A', '2022-07-12 18:56:00'::timestamp, '2022-07-13 11:56:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6709, '58-308-6113',  '[1]', 'SUBMITTED', 'N/A', '2022-07-08 15:37:00'::timestamp, '2022-07-13 11:27:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6710, '19-791-0773',  '[2, 2, 2]', 'SUBMITTED','N/A', '2022-07-14 09:58:00'::timestamp, '2022-07-15 11:28:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6711, '53-570-6948',  '[1, 2, 4, 5]', 'PROCESSED', 'N/A', '2022-07-11 01:54:00'::timestamp, '2022-07-13 12:44:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6712, '23-606-4767',  '[1, 5, 3]', 'PROCESSED', 'N/A', '2022-07-12 11:50:00'::timestamp, '2022-07-13 02:45:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6713, '14-786-6861',  '[2, 4, 5]', 'PROCESSED', 'N/A', '2022-07-13 00:46:00'::timestamp, '2022-07-13 02:56:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6714, '19-791-0773',  '[2, 2, 3, 5]', 'PROCESSED', 'N/A', '2022-07-12 11:58:00'::timestamp, '2022-07-13 01:58:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6715, '14-786-6861',  '[2, 4, 5]', 'IN-TRANSIT','1349826936', '2022-07-12 11:56:00'::timestamp, '2022-07-14 19:56:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6716, '58-308-6113',  '[1, 2, 3]', 'IN-TRANSIT', '7616308716', '2022-07-11 11:57:00'::timestamp, '2022-07-19 17:57:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6717, '19-791-0773',  '[2, 2, 2, 2, 2, 3]', 'IN-TRANSIT', '4276596882', '2022-07-12 10:25:00'::timestamp, '2022-07-17 19:58:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6718, '58-308-6113',  '[1, 3, 4, 5]', 'SHIPPED', '7616308716', '2022-07-13 11:57:00'::timestamp, '2022-07-19 17:57:00'::timestamp);
insert into grocery_shop.orders (order_id, customer_id, items_ordered, order_status, tracking_number, create_time, last_update_time) values(6719, '19-791-0773',  '[2, 2, 2, 3, 4, 4, 4, 5]', 'SHIPPED', '4276596882', '2022-07-13 11:58:00'::timestamp, '2022-07-21 01:58:00'::timestamp);

/*
orderId,customerName,itemsOrdered,orderStatus,trackingNumber,createTime,lastUpdateTime
6706,Alan Turing,'{1, 3, 5, 5}',SUBMITTED,N/A,2022-07-13 11:54:00,2022-07-13 11:54:00
6707,Bob Barker,'{1, 1, 3}',SUBMITTED,N/A,2022-07-13 11:55:00,2022-07-13 11:55:00
6708,Chris Farley,'{2, 4}',SUBMITTED,N/A,2022-07-13 11:56:00,2022-07-13 11:56:00
6709,Luke Skywalker,{1},SUBMITTED,N/A,2022-07-13 11:57:00,2022-07-13 11:57:00
6710,Ronald Reagan,'{2, 2, 2}',SUBMITTED,N/A,2022-07-13 11:58:00,2022-07-13 11:58:00
6706,Alan Turing,'{1, 3, 5, 5}',PROCESSED,N/A,2022-07-13 11:54:00,2022-07-13 12:54:00
6707,Bob Barker,'{1, 1, 3}',PROCESSED,N/A,2022-07-13 11:55:00,2022-07-13 12:55:00
6708,Chris Farley,'{2, 4}',PROCESSED,N/A,2022-07-13 11:56:00,2022-07-13 12:56:00
6709,Luke Skywalker,{1},PROCESSED,N/A,2022-07-13 11:57:00,2022-07-13 12:57:00
6710,Ronald Reagan,'{2, 2, 2}',PROCESSED,N/A,2022-07-13 11:58:00,2022-07-13 12:58:00
6708,Chris Farley,'{2, 4}',IN-TRANSIT,1349826936,2022-07-13 11:56:00,2022-07-14 11:56:00
6709,Luke Skywalker,{1},IN-TRANSIT,7616308716,2022-07-13 11:57:00,2022-07-14 11:57:00
6710,Ronald Reagan,'{2, 2, 2}',IN-TRANSIT,4276596882,2022-07-13 11:58:00,2022-07-14 11:58:00
6709,Luke Skywalker,{1},SHIPPED,7616308716,2022-07-13 11:57:00,2022-07-16 11:57:00
6710,Ronald Reagan,'{2, 2, 2}',SHIPPED,4276596882,2022-07-13 11:58:00,2022-07-16 11:58:00
*/

/*
productId,productName,productCost,productQuantity,sellerName,productLastUpdateTime
1,Pork - Caul Fat,$5.63,16,Rad Rainbird,2022-07-11 18:58:42
2,'Tarragon - Primerba, Paste',$27.94,20,Clarence Hulstrom,2022-07-09 20:05:52
3,Bagel - Ched Chs Presliced,$18.01,26,Neddie Labell,2022-07-10 04:32:17
4,V8 Splash Strawberry Kiwi,$33.85,16,Tess Loiterton,2022-07-08 12:52:26
5,'Potatoes - Yukon Gold, 80 Ct',$33.92,12,Randie Gresser,2022-07-11 07:09:15
/*

/*
customerId,customerName,customerEmail,customerAddress,
53-570-6948,Linet Pedroni,lpedroni0@whitehouse.gov,56 Di Loreto Terrace,
23-606-4767,Peria Olivey,polivey1@google.com.br,593 Thompson Drive,
14-786-6861,Greg Vane,gvane2@skyrock.com,1 Gale Court,
58-308-6113,Jeremy Jiri,jjiri3@discovery.com,2 Declaration Pass,
19-791-0773,Julee Bradnum,jbradnum4@so-net.ne.jp,32 Bluestem Avenue,
*/

/*
sellerId,sellerName,sellerCompany,sellerEmail,sellerAddress
87-017-4611,Rad Rainbird,Nlounge,rrainbird0@blogtalkradio.com,13 Sundown Way
51-894-3698,Clarence Hulstrom,Mybuzz,chulstrom1@comsenz.com,26 Iowa Lane
79-156-2194,Neddie Labell,Wordware,nlabell2@shop-pro.jp,82 Mifflin Alley
50-617-6068,Tess Loiterton,Skivee,tloiterton3@ted.com,71 Washington Hill
35-950-3000,Randie Gresser,Skipstorm,rgresser4@globo.com,1 Montana Court
*/