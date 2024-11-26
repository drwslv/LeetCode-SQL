
----------------------------------------
-- (1) SQL Data Structure
----------------------------------------


-- (1.1) Schema

CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;

CREATE TABLE `new_schema`.`new_table` (
  `id` INT NOT NULL COMMENT 'This is a primary index',
  PRIMARY KEY (`id`)
);


-- (1.2) Tables

CREATE TABLE `new_schema`.`new_table` (
  `id` INT NOT NULL COMMENT 'This is a primary index',
  PRIMARY KEY (`id`)
);

-- Display table
SHOW FULL COLUMNS FROM `new_schema`.`new_table`;

-- Delete table
DROP TABLE `new_schema`.`new_table`;

-- Clear Table
TRUNCATE `new_schema`.`new_table`;


-- (1.3) Columns

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  PRIMARY KEY (`id`)
);

-- Create columns
ALTER TABLE `new_schema`.`users`
    ADD COLUMN `age` INT NULL AFTER `name`;

-- Update columns
ALTER TABLE `new_schema`.`users`
CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT,
CHANGE COLUMN `name` `user_name` VARCHAR(45) NOT NULL DEFAULT 'No Name';

-- Delete columns
ALTER TABLE `new_schema`.`users`
    DROP COLUMN `age`;


----------------------------------------
-- (2.1) SELECT, INSERT, UPDATE, DELETE
----------------------------------------

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  `height` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (1, 'John', 50, 180);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES (2, 'May', 40);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (3, 'Tim', 10, 170);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (4, 'Jay', 20, 155);

-- INSERT
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES (5, 'Tom', 30);

SELECT * FROM `new_schema`.`users`;

SELECT `name`, `age` FROM `new_schema`.`users`;

SELECT `name`, `age` FROM `new_schema`.`users`
    WHERE id=2;

-- UPDATE
UPDATE `new_schema`.`users`
    SET `name` = 'Andy', `age` = 100
    WHERE `id` = 2;


-- DELETE
DELETE FROM `new_schema`.`users` WHERE `id` = 1;


----------------------------------------
-- (2.2) WHERE
----------------------------------------

drop table if exists new_schema.users

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  `height` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (1, 'John', 50, 180);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES (2, 'May', 40);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (3, 'Tim', 10, 170);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES (4, 'Jay', 20, 155);

SELECT * FROM new_schema.users

SELECT * FROM `new_schema`.`users` WHERE id > 1;

-- NULL is special
SELECT * FROM `new_schema`.`users` WHERE height IS NULL;

SELECT * FROM `new_schema`.`users` WHERE age < 40 AND height > 160;

SELECT * FROM `new_schema`.`users` WHERE age < 40 OR height > 160;

SELECT * FROM `new_schema`.`users` WHERE id < 4 AND (age > 30 OR height > 175);

-- Range queries
SELECT * FROM `new_schema`.`users` WHERE `id` IN (1, 3);

SELECT * FROM `new_schema`.`users` WHERE id NOT IN (1, 4);

-- Between
SELECT * FROM `new_schema`.`users` WHERE height BETWEEN 160 AND 190;

-- Like: % matches zero, one, or many characters
SELECT * FROM `new_schema`.`users` WHERE name LIKE '%a%';

SELECT * FROM `new_schema`.`users` WHERE name LIKE 'J%';

SELECT * FROM `new_schema`.`users` WHERE name LIKE '%y';


/* EXAMPLE 1: 595. Big Countries

A country is big if:

* it has an area of at least three million (i.e., 3000000 km2), or

* it has a population of at least twenty-five million (i.e., 25000000).

Write a solution to find the name, population, and area of the big countries.

Return the result table in any order. */

Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp bigint);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

SELECT name, population, area from World
    WHERE area >= 3000000 OR population >= 25000000;


/* EXAMPLE 2: 1757. Recyclable and Low Fat Products

Write a solution to find the ids of products that are both low fat and recyclable.

Return the result table in any order.

The result format is in the following example. */

Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'));
Truncate table Products;
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');

select * from Products;

select product_id from Products
    where low_fats='Y' and recyclable='Y';


/* EXAMPLE 3: 584. Find Customer Referree

Find the names of the customer that are not referred by the customer with id = 2.

Return the result table in any order.

The result format is in the following example. */

Create table If Not Exists Customer (id int, name varchar(25), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

select * from Customer;

select name from Customer
where id not in (
    select id from Customer
    where referee_id = 2
);


/* EXAMPLE 4: 1873. Calculate Special Bonus

Write a solution to calculate the bonus of each employee. The bonus of an employee is 100% of their salary
if the ID of the employee is an odd number and the employee's name does not start with the character 'M'.
The bonus of an employee is 0 otherwise.

Return the result table ordered by employee_id.

The result format is in the following example. */

drop table Employees

Create table If Not Exists Employees (employee_id int, name varchar(30), salary int);
Truncate table Employees;
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000');
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800');
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400');
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100');
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700');

select * from Employees;

ALTER TABLE Employees
ADD COLUMN bonus INT NULL AFTER salary;

UPDATE Employees
SET bonus = salary
WHERE (employee_id % 2 = 1) and (name not like 'M%');

UPDATE Employees
SET bonus = 0
Where bonus is NULL;

SELECT employee_id, bonus from Employees;

-- OR

SELECT 
    employee_id,
    IF(employee_id % 2 = 1 AND name NOT REGEXP '^M', salary, 0) AS bonus 
FROM 
    Employees 
ORDER BY 
    employee_id

SELECT 
    employee_id,
    IF(employee_id % 2 = 1 AND name NOT like 'M%', salary, 0) AS bonus 
FROM 
    Employees 
ORDER BY 
    employee_id

----------------------------------------
-- (2.3) JSON
----------------------------------------

drop table if exists new_schema.users

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  PRIMARY KEY (`id`)
);

ALTER TABLE `new_schema`.`users` ADD COLUMN `contact` JSON NULL AFTER `id`;

INSERT INTO `new_schema`.`users` (`id`, `name`, `contact`) VALUES 
  (1, 'John', JSON_OBJECT('phone', '123-456', 'address', 'New York')),
  (2, 'May', JSON_OBJECT('phone', '888-99', 'address', 'LA')),
  (3, 'Tim', JSON_OBJECT('phone', '1236')),
  (4, 'Jay', JSON_OBJECT('phone', '321-6', 'address', 'Boston'));

select * from new_schema.users

-- JSON read

SELECT `id`, JSON_EXTRACT(contact, '$.phone') AS phone
FROM `new_schema`.`users`;

SELECT `id`, JSON_UNQUOTE(JSON_EXTRACT(contact, '$.phone')) AS phone
FROM `new_schema`.`users`;

SELECT `id`, JSON_UNQUOTE(JSON_EXTRACT(contact, '$.phone')) AS phone
FROM `new_schema`.`users`
WHERE JSON_UNQUOTE(JSON_EXTRACT(contact, '$.phone')) like '123%';

-- JSON add

INSERT INTO `new_schema`.`users` (`id`, `name`, `contact`) VALUES (5, 'Harry', JSON_OBJECT('phone', '1231123', 'address', 'Miami'));

-- JSON updates

UPDATE `new_schema`.`users` SET `contact` = JSON_SET(contact, '$.phone', '6666', '$.phone_2', '888') WHERE `id` = 2;


/* EXAMPLE 5. 627. Swap Salary

Write a solution to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa)

with a single update statement and no intermediate temporary tables.

Note that you must write a single update statement, do not write any select statement for this problem.

The result format is in the following example.

*/

drop table if exists Salary;

Create table If Not Exists Salary (id int, name varchar(100), sex char(1), salary int);
Truncate table Salary;
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500');

select * from Salary;


update Salary set sex = if(sex = 'm', 'f', 'm');

-- OR

update Salary
set
    sex = case sex
        when 'm' then 'f'
        else 'm'
    end;


----------------------------------------
-- (2.4) Auxillary SELECT
----------------------------------------

drop table if exists new_schema.users

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  `height` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES 
  (1, 'John', 40, 150),
  (2, 'May', 30, 140),
  (3, 'Tim', 25, 170),
  (4, 'Jay', 60, 185),
  (5, 'Maria', 30, 190),
  (6, 'Tom', 53, 200),
  (7, 'Carter', 40, 145);

select * from new_schema.users;

-- Uniqueness: DISTINCT

SELECT DISTINCT age FROM `new_schema`.`users`;

-- Pagination: LIMIT & OFFSET

SELECT * FROM `new_schema`.`users` LIMIT 3 OFFSET 1;

-- Sorting: ORDER

SELECT * FROM `new_schema`.`users` ORDER BY age;

SELECT * FROM `new_schema`.`users` ORDER BY age ASC;

SELECT * FROM `new_schema`.`users` ORDER BY age DESC;

SELECT * FROM `new_schema`.`users` ORDER BY age DESC, height DESC;

-- Grouping: GROUP BY

SELECT `age` FROM `new_schema`.`users` GROUP BY age;

SELECT COUNT(*), `age` FROM `new_schema`.`users` GROUP BY age;

SELECT COUNT(*) AS `age_count`, `age`
FROM `new_schema`.`users`
GROUP BY age
ORDER BY `age_count`;


/* EXAMPLE 6: 1148. Article Views I

Write a solution to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.

The result format is in the following example.

*/

drop table if exists Views

Create table If Not Exists Views (article_id int, author_id int, viewer_id int, view_date date);
Truncate table Views;
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');

select * from Views;

select distinct author_id as id from Views
where author_id = viewer_id
order by author_id;


----------------------------------------
-- (2.4) Aggregate Function
----------------------------------------

drop table if exists `new_schema`.`users`;

CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  `height` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`users` (`id`, `name`, `age`, `height`) VALUES 
  (1, 'John', 40, 150),
  (2, 'May', 30, 140),
  (3, 'Tim', 25, 180),
  (4, 'Jay', 40, 160);

select * from `new_schema`.`users`;

-- Counting: COUNT

SELECT COUNT(*) AS `user_count` FROM `new_schema`.`users` WHERE id > 1;

-- Total: SUM

SELECT SUM(`age`) AS `sum_of_user_ages` FROM `new_schema`.`users`;

-- Average: AVG

SELECT AVG(`height`) AS `avg_user_height` FROM `new_schema`.`users`;

-- Minimum & Maximum: MIN & MAX

SELECT MIN(`height`) AS `user_min` FROM `new_schema`.`users`;

SELECT MAX(`height`) AS `user_max` FROM `new_schema`.`users`;

-- CONCAT

SELECT CONCAT(`id`, '-', `name`) AS `identification`, `age` 
FROM `new_schema`.`users`;

-- Subqueries in FROM

SELECT * FROM (
  SELECT CONCAT(`id`, '-', `name`) AS `identification`, `age` 
  FROM `new_schema`.`users`
) AS subquery
WHERE `identification` LIKE '%J%';

WITH CTE_Users AS (
  SELECT CONCAT(`id`, '-', `name`) AS `identification`, `age`
  FROM `new_schema`.`users`
)
SELECT * FROM CTE_Users
WHERE `identification` LIKE '%J%';


/* EXAMPLE 7: 1693. Daily Leads and Partners

For each date_id and make_name, find the number of distinct lead_id's and distinct partner_id's.

Return the result table in any order.

The result format is in the following example.

*/

delete table if exists DailySales;

Create table If Not Exists DailySales(date_id date, make_name varchar(20), lead_id int, partner_id int);
Truncate table DailySales;
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '0');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '2', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '2', '1');

select * from DailySales;

select date_id, make_name, count(distinct lead_id) as unique_leads, count(distinct partner_id) as unique_partners
from DailySales
group by date_id, make_name
order by make_name desc;

/* EXAMPLE 8: 1729. Find Followers Count

Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.

*/
drop table if exists Followers;

Create table If Not Exists Followers(user_id int, follower_id int);
Truncate table Followers;
insert into Followers (user_id, follower_id) values ('0', '1');
insert into Followers (user_id, follower_id) values ('1', '0');
insert into Followers (user_id, follower_id) values ('2', '0');
insert into Followers (user_id, follower_id) values ('2', '1');

select * from Followers;

select user_id, count(distinct follower_id) as followers_count
from Followers
group by user_id
order by user_id asc;


/* EXAMPLE 9: 511. Game Play Analysis I

Write a solution to find the first login date for each player.

Return the result table in any order.

The result format is in the following example.

*/

drop table if exists Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

select * from Activity;

select player_id, min(event_date) as first_login
from Activity
group by player_id
order by player_id asc;

