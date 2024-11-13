

-- Schema

CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;

CREATE TABLE `new_schema`.`new_table` (
  `id` INT NOT NULL COMMENT 'This is a primary index',
  PRIMARY KEY (`id`)
);


-- Tables

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
