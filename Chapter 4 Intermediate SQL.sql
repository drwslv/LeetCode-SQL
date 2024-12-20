

----------------------------------------
-- (4.1) Foreign Key
----------------------------------------

CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `new_schema`.`users`;
CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `age` INT NULL,
  PRIMARY KEY (`id`)
);
INSERT INTO `new_schema`.`users` (`id`, `name`, `age`) VALUES 
  (1, 'John', 40),
  (2, 'May', 30),
  (3, 'Tim', 22);
  
DROP TABLE IF EXISTS `new_schema`.`orders`;
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


-- Add a foreign key constraint --
ALTER TABLE `new_schema`.`orders`
    ADD CONSTRAINT `orders_user_id_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_schema`.`users` (`id`);

-- DELETE of foreign key reference (source key) prohibited
DELETE FROM `new_schema`.`users` WHERE (`id` = '1');

-- UPDATE of foreign key reference (source key) prohibited
UPDATE `new_schema`.`users` SET `id` = '6' WHERE (`id` = '1');

-- UPDATE of other variables is allowed
UPDATE `new_schema`.`users` SET `name` = 'Tony' WHERE (`id` = '1');
SELECT * FROM `new_schema`.`users`;

-- UPDATE of foreign key (relative key) is allowed
UPDATE `new_schema`.`orders` SET `user_id` = '3' WHERE (`id` = '1');
SELECT * FROM `new_schema`.`orders`;

-- Remove a foreign key constraint --
ALTER TABLE `new_schema`.`orders`
    DROP FOREIGN KEY `orders_user_id_key`;

-- Other constraint options
ALTER TABLE `new_schema`.`orders`
    ADD CONSTRAINT `orders_user_id_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_schema`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE RESTRICT;

-- NO ACTION or RESTRICT: command is not executed (both same in MySQL)

-- CASCADE: Dynamically set foreign keys referencing same source key to match (same value)

-- SET NULL: Dynamically set foreign keys refernceing same source key to NULL


----------------------------------------
-- (4.2) Transactions
----------------------------------------

DROP TABLE IF EXISTS `new_schema`.`products`;
CREATE TABLE `new_schema`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `title` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  `price` INT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `new_schema`.`products` (`id`, `price`, `title`) VALUES 
  (1, 10, 'chair'),
  (2, 100, 'desk'),
  (3, 200, 'bike'),
  (4, 200, 'motorcycle'),
  (5, 300, 'headphone'),
  (6, 300, 'phone');

SELECT * FROM `new_schema`.`products`;


-- First Query
START TRANSACTION;

-- Second Queries
UPDATE `new_schema`.`products` SET `price` = '500' WHERE id = 5;
UPDATE `new_schema`.`products` SET `price` = '500' WHERE id = 6;

-- Third Query
COMMIT;


-- First Query
START TRANSACTION;

-- Second Queries
UPDATE `new_schema`.`products` SET `price` = '500' WHERE id = 5;
..
-- error happened here!
..
UPDATE `new_schema`.`products` SET `price` = '500' WHERE id = 6;

-- Third Query
ROLLBACK;


-- With error checking
START TRANSACTION;

SELECT `new_schema`.`products` WHERE id = 5;
UPDATE `new_schema`.`products` SET `price` = '500' WHERE id = 5;

IF (@correct) THEN
  COMMIT;
ELSE
  ROLLBACK;
END IF;


----------------------------------------
-- (4.3) ACID
----------------------------------------

-- ACID: atomicity, consistency, isolation, durability

-- Atomicity: the ability for code blocks to be executed as a unit, i.e. a bank transfer

-- Consistency: the ability to return the dataset to "good" condition, i.e. ROLLBACK

-- Isolation: transactions do not affect one another, and are handled independently

-- Durability: resistance to hardware failures; if a result has been committed, it's in the data permanently


----------------------------------------
-- (4.4) Index
----------------------------------------

-- Pros: provides fast access to frequently-accessed records (read operations)

-- Cons: needs to be rebuilt, can require overhead for frequently-modified records (write operations)

-- Add an index
ALTER TABLE `new_schema`.`users`
    ADD INDEX `name_index` (`name`);

-- Add an index (alt)
CREATE INDEX `name_index` ON `new_schema`.`users` (`name`);

-- Remove an index
ALTER TABLE `new_schema`.`users`
    DROP INDEX `name_index`;

-- Index tips
-- 1. Use UNIQUE INDEX, otherwise, use KEY
-- 2. Add an index for the column that is often referenced by complex operations, such as GROUP BY
-- 3. Index the hotspot column that is frequently queried in WHERE
-- 4. Note index disk space usage
-- 5. Index the column with small values
-- 6. Try to avoid index on columns with NULL, which may affect the query efficiency


----------------------------------------
-- (4.5) User Privilage
----------------------------------------

-- Creat a user
CREATE USER 'john'@'localhost' IDENTIFIED BY 'password';

-- Show a user
SELECT * FROM `mysql`.`user`

-- Grant privileges
GRANT ALL ON `new_schema`.`orders` TO 'john'@'localhost'; -- user can perform all actions
GRANT SELECT ON `new_schema`.* TO 'root'@'150.10.12.1'; -- user can run SELECT statements only







