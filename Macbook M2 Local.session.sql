

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



