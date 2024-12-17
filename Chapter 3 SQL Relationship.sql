
----------------------------------------
-- (3.1) Relationships
----------------------------------------

----------------------------------------
-- (3.2) JOIN
----------------------------------------

drop schema `new_schema`;
CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES 
  (1, 'John', 40),
  (2, 'May', 30),
  (3, 'Tim', 25);
  
  
CREATE TABLE `new_schema`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT,
  `note` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
);
 
INSERT INTO `new_schema`.`orders` (`id`, `user_id`, `note`) VALUES 
  (1, 1, 'some info'), 
  (2, 2, 'some comments'),
  (3, 2, 'no comments'),
  (4, NULL, 'weird');


select * from `new_schema`.`users`;
select * from `new_schema`.`orders`;

SELECT *
FROM `new_schema`.`users`
LEFT JOIN `new_schema`.`orders` ON `users`.`id` = `orders`.`user_id`;

SELECT *
FROM `new_schema`.`users`
RIGHT JOIN `new_schema`.`orders` ON `users`.`id` = `orders`.`user_id`;

SELECT *
FROM `new_schema`.`users`
INNER JOIN `new_schema`.`orders` ON `users`.`id` = `orders`.`user_id`;

SELECT `orders`.`id` AS order_id , `name`
FROM `new_schema`.`users`
INNER JOIN `new_schema`.`orders` ON `users`.`id` = `orders`.`user_id`;


/* EXAMPLE 1: 1581. Customer Who Visited but Did Not Make Any Transactions

Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Return the result table sorted in any order.

The result format is in the following example.

*/

Create table If Not Exists Visits(visit_id int, customer_id int);
Create table If Not Exists Transactions(transaction_id int, visit_id int, amount int);
Truncate table Visits;
insert into Visits (visit_id, customer_id) values ('1', '23');
insert into Visits (visit_id, customer_id) values ('2', '9');
insert into Visits (visit_id, customer_id) values ('4', '30');
insert into Visits (visit_id, customer_id) values ('5', '54');
insert into Visits (visit_id, customer_id) values ('6', '96');
insert into Visits (visit_id, customer_id) values ('7', '54');
insert into Visits (visit_id, customer_id) values ('8', '54');
Truncate table Transactions;
insert into Transactions (transaction_id, visit_id, amount) values ('2', '5', '310');
insert into Transactions (transaction_id, visit_id, amount) values ('3', '5', '300');
insert into Transactions (transaction_id, visit_id, amount) values ('9', '5', '200');
insert into Transactions (transaction_id, visit_id, amount) values ('12', '1', '910');
insert into Transactions (transaction_id, visit_id, amount) values ('13', '2', '970');

select * from Visits;
select * from Transactions;

select customer_id, count(*) as count_no_trans
from (
    select Visits.visit_id as visit_id, customer_id, transaction_id
    from Visits
    left join Transactions on Visits.visit_id = Transactions.visit_id
) as subquery
where transaction_id is null
group by customer_id;

-- OR --

SELECT 
  customer_id, COUNT(visit_id) AS count_no_trans 
FROM 
  Visits 
WHERE 
  visit_id NOT IN (
    SELECT 
      visit_id 
    FROM 
      Transactions
  ) 
GROUP BY 
  customer_id


/* EXAMPLE 2: 175. Combine Two Tables

Write a solution to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.

Return the result table in any order.

The result format is in the following example.

*/

drop table if exists Person;
drop table if exists Address;
Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255));
Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255));
Truncate table Person;
insert into Person (personId, lastName, firstName) values (1, 'Wang', 'Allen');
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
Truncate table Address;
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');

select * from Person;
select * from Address;

select firstName, lastName, city, state
from Person
left join Address on Person.personId = Address.personId;


/* EXAMPLE 3: 1158. Market Analysis I

Write a solution to find for each user, the join date and the number of orders they made as a buyer in 2019.

Return the result table in any order.

The result format is in the following example.

*/

drop table if exists Users;
drop table if exists Orders;
drop table if exists Items;

Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
insert into Users (user_id, join_date, favorite_brand) values ('1', '2018-01-01', 'Lenovo');
insert into Users (user_id, join_date, favorite_brand) values ('2', '2018-02-09', 'Samsung');
insert into Users (user_id, join_date, favorite_brand) values ('3', '2018-01-19', 'LG');
insert into Users (user_id, join_date, favorite_brand) values ('4', '2018-05-21', 'HP');
Truncate table Orders;
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('1', '2019-08-01', '4', '1', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('2', '2018-08-02', '2', '1', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('3', '2019-08-03', '3', '2', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('4', '2018-08-04', '1', '4', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('5', '2018-08-04', '1', '3', '4');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
insert into Items (item_id, item_brand) values ('1', 'Samsung');
insert into Items (item_id, item_brand) values ('2', 'Lenovo');
insert into Items (item_id, item_brand) values ('3', 'LG');
insert into Items (item_id, item_brand) values ('4', 'HP');

select * from Users;
select * from Orders;

select q2.user_id as buyer_id, q2.join_date, count(q2.order_id) as orders_in_2019
from (
    select *
    from Users
    left join (
        select order_id, order_date, buyer_id
        from Orders
        where order_date between '2019-01-01' and '2019-12-31'
    ) as q1
    on Users.user_id = q1.buyer_id
) as q2
group by q2.user_id, q2.join_date;

-- OR --

select u.user_id, u.join_date, count(o.item_id) as orders_in_2019
from Users u
    left join Orders o on u.user_id = o.buyer_id
    and year(o.order_date) = 2019
group by u.user_id, u.join_date;


----------------------------------------
-- (3.3) Subqueries
----------------------------------------


CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

drop table if exists  `new_schema`.`users`;
CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES 
  (1, 'John', 40),
  (2, 'May', 30),
  (3, 'Jim', 22);
  
drop table if exists  `new_schema`.`orders`;
CREATE TABLE `new_schema`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT,
  `note` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
);
 
INSERT INTO `new_schema`.`orders` (`id`, `user_id`, `note`) VALUES 
  (1, 1, 'some information'), 
  (2, 2, 'some comments'),
  (3, 2, 'no comments'),
  (4, 3, 'more comments');


select * from `new_schema`.`users`;
select * from `new_schema`.`orders`;

-- Equal Condition
-- Only works if subquery returns a single record
-- Select only a single column

SELECT * FROM `new_schema`.`orders`
WHERE user_id = (
  SELECT id FROM `new_schema`.`users`
  WHERE name = 'John'
);

SELECT id FROM `new_schema`.`users`
    WHERE name = 'John';


-- Contain Condition
-- Works if subquery contains single or multiple records
-- Select only a single column

SELECT * FROM `new_schema`.`orders`
WHERE user_id IN (
  SELECT id FROM `new_schema`.`users`
  WHERE name LIKE '%j%'
);

SELECT id FROM `new_schema`.`users`
  WHERE name LIKE '%j%';


/* EXAMPLE 4: 607. Sales Person

Write a solution to find the names of all the salespersons who did not have any orders related to the company with the name "RED".

Return the result table in any order.

The result format is in the following example.

*/

drop table if exists SalesPerson;
drop table if exists Company;
drop table if exists Orders;

Create table If Not Exists SalesPerson (sales_id int, name varchar(255), salary int, commission_rate int, hire_date date);
Create table If Not Exists Company (com_id int, name varchar(255), city varchar(255));
Create table If Not Exists Orders (order_id int, order_date date, com_id int, sales_id int, amount int);
Truncate table SalesPerson;
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('1', 'John', '100000', '6', '2006-4-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('2', 'Amy', '12000', '5', '2010-5-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('3', 'Mark', '65000', '12', '2008-12-25');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('4', 'Pam', '25000', '25', '2005-1-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('5', 'Alex', '5000', '10', '2007-2-3');
Truncate table Company;
insert into Company (com_id, name, city) values ('1', 'RED', 'Boston');
insert into Company (com_id, name, city) values ('2', 'ORANGE', 'New York');
insert into Company (com_id, name, city) values ('3', 'YELLOW', 'Boston');
insert into Company (com_id, name, city) values ('4', 'GREEN', 'Austin');
Truncate table Orders;
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('1', '2014-1-1', '3', '4', '10000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('2', '2014-2-1', '4', '5', '5000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('3', '2014-3-1', '1', '1', '50000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('4', '2014-4-1', '1', '4', '25000');

select * from SalesPerson;
select * from Company;
select * from Orders;


select name
from SalesPerson
where sales_id not in (
    select o.sales_id
    from Orders o
    left join Company c on o.com_id = c.com_id
    where c.name = "RED"
);


/* EXAMPLE 5: 183. Customers Who Never Order

Write a solution to find all customers who never order anything.

Return the result table in any order.

The result format is in the following example.

*/

drop table if exists Customers;
drop table if exists Orders;

Create table Customers (id int, name varchar(255));
Create table Orders (id int, customerId int);

insert into Customers (id, name) values ('1', 'Joe'),
    ('2', 'Henry'),
    ('3', 'Sam'),
    ('4', 'Max');

insert into Orders (id, customerId) values('1', '3'),
    ('2', '1');

select * from Customers;
select * from Orders;


select c.name as Customers
from Customers c
where c.id not in (
    select customerId
    from Orders
);


/* EXAMPLE 6: 586. Customer Placing the Largest Number of Orders

Write a solution to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed more orders than any other customer.

The result format is in the following example.

*/

drop table if exists orders;
Create table If Not Exists orders (order_number int, customer_number int);
insert into orders (order_number, customer_number) values ('1', '1'),
    ('2', '2'),
    ('3', '3'),
    ('4', '3');

select * from orders;

select c.customer_number
from (
    select customer_number, count(order_number) as order_count
    from orders
    group by customer_number
    order by order_count desc
    limit 1
) as c;

-- OR --

select customer_number
from orders
group by customer_number
order by count(*) desc
limit 1;


/* EXAMPLE 7: 1407. Top Travellers

Write a solution to report the distance traveled by each user.

Return the result table ordered by travelled_distance in descending order, if two or more users traveled the same distance, order them by their name in ascending order.

The result format is in the following example.

*/

drop table if exists Users;
drop table if exists Rides;

Create Table Users (id int, name varchar(30));
Create Table Rides (id int, user_id int, distance int);

insert into Users (id, name) values ('1', 'Alice'),
    ('2', 'Bob'),
    ('3', 'Alex'),
    ('4', 'Donald'),
    ('7', 'Lee'),
    ('13', 'Jonathan'),
    ('19', 'Elvis');

insert into Rides (id, user_id, distance) values ('1', '1', '120'),
    ('2', '2', '317'),
    ('3', '3', '222'),
    ('4', '7', '100'),
    ('5', '13', '312'),
    ('6', '19', '50'),
    ('7', '7', '120'),
    ('8', '19', '400'),
    ('9', '7', '230');

SELECT * FROM Users;
SELECT * FROM Rides;


SELECT u.name, IFNULL(r.travelled_distance, 0) AS travelled_distance
FROM Users AS u
LEFT JOIN (
    SELECT user_id, SUM(distance) AS travelled_distance
    FROM Rides
    GROUP BY user_id
) AS r ON u.id = r.user_id
ORDER BY r.travelled_distance DESC, u.name ASC;

-- OR --

SELECT 
    u.name, 
    IFNULL(SUM(distance),0) AS travelled_distance
FROM
    Users u
LEFT JOIN 
    Rides r
ON 
    u.id = r.user_id
GROUP BY 
    u.id
ORDER BY 2 DESC, 1 ASC



