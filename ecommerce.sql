 -- 1. Create the database 
CREATE DATABASE ecommerce;
USE ecommerce;

--create the tables 

-- customer table
CREATE TABLE customers (
       id INT AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100),
      email VARCHAR(100),
      address VARCHAR(255)
       );

-- orders table

CREATE TABLE orders (
      id INT AUTO_INCREMENT PRIMARY KEY,
      customer_id INT,
      order_date DATE,
      total_amount DECIMAL(10,2),
      FOREIGN KEY (customer_id) REFERENCES customers(id)
      );   

      --products table
  CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10,2),
  description varchar(255)
);

--insert the data into the customers table
    INSERT INTO customers(name,email,address)      
     VALUES("jhon","john@gmail.com","12 street "), 
    ("marry","marry@gmail.com","34 street"),
    ("priya","priya@gmail.com","56 street");

mysql> select * from customers;
+----+-------+-----------------+------------+
| id | name  | email           | address    |
+----+-------+-----------------+------------+
|  1 | jhon  | john@gmail.com  | 12 street  |
|  2 | marry | marry@gmail.com | 34 street  |
|  3 | priya | priya@gmail.com | 56 street  |
+----+-------+-----------------+------------+


--insert the data into the orders table
INSERT INTO orders(customer_id,order_date,total_amount)  
    VALUES(1,curdate(),100),
    (2,curdate()-interval 10 day,200 ),
    (3,curdate()-interval 7 day,250);

mysql>select * from orders;
+----+-------------+------------+--------------+
| id | customer_id | order_date | total_amount |
+----+-------------+------------+--------------+
|  1 |           1 | 2025-04-18 |       100.00 |
|  2 |           2 | 2025-04-08 |       200.00 |
|  3 |           3 | 2025-04-11 |       250.00 |
+----+-------------+------------+--------------+

--insert the data into the products table hello

INSERT INTO products(name,price,description)    
 VALUES("product A",100,"product A details"),
       ("product B",150,"product B details"),
       ("product C",200,"product C details");

mysql> select * from products;
+----+-----------+--------+-------------------+
| id | name      | price  | description       |
+----+-----------+--------+-------------------+
|  1 | product A | 100.00 | product A details |
|  2 | product B | 150.00 | product B details |
|  3 | product C | 200.00 | product C details |
+----+-----------+--------+-------------------+
--Queries :
1) Retrieve all customers who have placed an order in the last 30 days.

