

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


-- (2.1) SELECT, INSERT, UPDATE, DELETE

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


-- (2.2) WHERE

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

