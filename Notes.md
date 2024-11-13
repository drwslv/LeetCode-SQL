

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
