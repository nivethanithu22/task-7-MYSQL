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
    (3,curdate()-interval 1 month,250);

mysql>select * from orders;
+----+-------------+------------+--------------+
| id | customer_id | order_date | total_amount |
+----+-------------+------------+--------------+
|  1 |           1 | 2025-04-18 |       100.00 |
|  2 |           2 | 2025-04-08 |       200.00 |
|  3 |           3 | 2025-03-19 |       250.00 |
+----+-------------+------------+--------------+

--insert the data into the products table

INSERT INTO products(name,price,description)    
 VALUES("product A",100,"product A details"),
       ("product B",150,"product B details"),
       ("product C",200,"product C details")
       ("product D",200,"product D details");

mysql> select * from products;
+----+-----------+--------+-------------------+
| id | name      | price  | description       |
+----+-----------+--------+-------------------+
|  1 | product A | 100.00 | product A details |
|  2 | product B | 150.00 | product B details |
|  3 | product C | 200.00 | product C details |
|  4 | product D | 120.00 | product D details |
+----+-----------+--------+-------------------+
--Queries :
1) Retrieve all customers who have placed an order in the last 30 days.

 SELECT c.id,c.name,c.email,c.address 
 FROM customers AS c 
 INNER JOIN
 orders AS o 
  ON c.id=o.customer_id WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;  
+----+-------+-----------------+------------+
| id | name  | email           | address    |
+----+-------+-----------------+------------+
|  1 | jhon  | john@gmail.com  | 12 street  |
|  2 | marry | marry@gmail.com | 34 street  |
+----+-------+-----------------+------------+

2)Get the total amount of all orders placed by each customer.
  
SELECT c.name,Sum(o.total_amount) AS total_spent
FROM customers as C
INNER JOIN
orders AS o
ON c.id=o.customer_id
GROUP BY c.id;

+-------+-------------+
| name  | total_spent |
+-------+-------------+
| jhon  |      100.00 |
| marry |      200.00 |
| priya |      250.00 |
+-------+-------------+

3) Update the price of Product C to 45.00.
 UPDATE products SET price=45 WHERE name="product C";
  +----+-----------+--------+-------------------+
| id | name      | price  | description       |
+----+-----------+--------+-------------------+
|  1 | product A | 100.00 | product A details |
|  2 | product B | 150.00 | product B details |
|  3 | product C |  45.00 | product C details |
+----+-----------+--------+-------------------+

4) Add a new column discount to the products table.
ALTER  TABLE products ADD discount DECIMAL(5, 2) DEFAULT 0.00;
+----+-----------+--------+-------------------+----------+
| id | name      | price  | description       | discount |
+----+-----------+--------+-------------------+----------+
|  1 | product A | 100.00 | product A details |     0.00 |
|  2 | product B | 150.00 | product B details |     0.00 |
|  3 | product C |  45.00 | product C details |     0.00 |
+----+-----------+--------+-------------------+----------+

5)Retrieve the top 3 products with the highest price.
SELECT * FROM products ORDER BY price DESC LIMIT 3;
+----+-----------+--------+-------------------+----------+
| id | name      | price  | description       | discount |
+----+-----------+--------+-------------------+----------+
|  2 | product B | 150.00 | product B details |     0.00 |
|  4 | product D | 120.00 | product D details |     0.00 |
|  1 | product A | 100.00 | product A details |     0.00 |
+----+-----------+--------+-------------------+----------+


  Normalize the database by creating a separate table 

 CREATE TABLE order_items1 (
 id INT AUTO_INCREMENT PRIMARY KEY,
      order_id INT,
      product_id INT,
      quantity INT,
      price DECIMAL(10,2),
      FOREIGN KEY (order_id) REFERENCES orders(id),
      FOREIGN KEY (product_id) REFERENCES products(id)
    );
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 100.00),
(1, 2, 1, 150.00),
(2, 3, 1, 200.00),
(2, 4, 3, 120.00),

+----+----------+------------+----------+--------+
| id | order_id | product_id | quantity | price  |
+----+----------+------------+----------+--------+
|  1 |        1 |          1 |        2 | 100.00 |
|  2 |        1 |          2 |        1 | 150.00 |
|  3 |        2 |          3 |        1 | 200.00 |
|  4 |        2 |          4 |        3 | 120.00 |
+----+----------+------------+----------+--------+

6) Get the names of customers who have ordered Product A.
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

+------+
| name |
+------+
| jhon |
+------+

7) Join the orders and customers tables to retrieve the customer's name and order date for each order. 

SELECT c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

+-------+------------+
| name  | order_date |
+-------+------------+
| jhon  | 2025-04-18 |
| marry | 2025-04-08 |
| priya | 2025-03-19 |
+-------+------------+

8) Retrieve the orders with a total amount greater than 150.00.
SELECT * FROM orders
WHERE total_amount > 150.00;
+----+-------------+------------+--------------+
| id | customer_id | order_date | total_amount |
+----+-------------+------------+--------------+
|  2 |           2 | 2025-04-08 |       200.00 |
|  3 |           3 | 2025-03-19 |       250.00 |
+----+-------------+------------+--------------+

9) --Normalize the order_items table

10) Retrieve the average total of all orders.
 SELECT AVG(total_amount) AS total_order
FROM orders;

+-------------+
| total_order |
+-------------+
|  183.333333 |
+-------------+