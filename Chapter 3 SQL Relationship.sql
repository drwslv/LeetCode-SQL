
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


/* EXAMPLE 1: 

*/


