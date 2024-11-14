

# SQL Schema

* Database Software (version)

* Database

* Schema

* Tables

## Schema Syntax

Create a schema with the unicode character set, with the additional options for emojis (`_ci`)

```
CREATE SCHEMA `new_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## Tables

```
CREATE TABLE `new_schema`.`new_table` (
  `id` INT NOT NULL COMMENT 'This is a primary index',
  PRIMARY KEY (`id`)
);
```

### Read Table
```
SHOW FULL COLUMNS FROM `new_schema`.`new_table`;
```

### Destroy Table

Completely delete a table.

```
DROP TABLE `new_schema`.`new_table`;
```

### Clean Table

Delete the data within a table, but not the table itself.

```
TRUNCATE `new_schema`.`new_table`;
```

## Columns

### Number
`BIGINT`, `INT`, `MEDIUMINT`, `SMALLINT`, `TINYINT`

`DOUBLE`, `FLOAT`, `DECIMAL` (most precise)

### Datetime
`DATE`, `MONTH`, `YEAR`

`DATETIME`, `TIMESTAMP`

### Text
`CHAR` (shorter length), `VARCHAR` (longer length, typically 45 chars)

`TEXT`, `LONGTEXT` (both for unkonwn lengths)

### Special types
`BINARY`, `BLOB`

`BOOLEAN`

`JSON`

```
CREATE TABLE `new_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'This is the primary index',
  `name` VARCHAR(45) NOT NULL DEFAULT 'N/A',
  PRIMARY KEY (`id`)
);
```

### Create a column
```
ALTER TABLE `new_schema`.`users`
ADD COLUMN `age` INT NULL AFTER `name`;
```

### Update a column
```
ALTER TABLE `new_schema`.`users`
CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT,
CHANGE COLUMN `name` `user_name` VARCHAR(45) NOT NULL DEFAULT 'No Name';
```
