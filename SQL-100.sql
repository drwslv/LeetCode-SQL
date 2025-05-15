
-- May 12 --

/* 1757. Recyclable and Low Fat Products [E]
Write a solution to find the ids of products that are both low fat and recyclable.
*/

Drop table if exists Products;
Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'));
Truncate table Products;
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');

SELECT
    p.product_id
FROM
    Products p
WHERE
    p.low_fats = 'Y' AND p.recyclable = 'Y';


/* 584. Find Customer Referee [E]
Find the names of the customer that are not referred by the customer with id = 2.
Return the result table in any order.
*/

Drop table if exists Customer;
Create table If Not Exists Customer (id int, name varchar(25), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

SELECT
    c.name
FROM
    Customer c
WHERE
    NOT (c.referee_id = '2') OR (c.referee_id IS NULL);


/* 197. Rising Temperature [E]
Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.
*/

Drop table if exists Weather;
Create table If Not Exists Weather (id int, recordDate date, temperature int);
Truncate table Weather;
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');

SELECT
    w1.id
FROM
    Weather w1
JOIN (
    SELECT
        (recordDate + INTERVAL 1 DAY) AS recordDate,
        temperature AS temperature_yesterday
    FROM
        Weather
) AS w2 ON w1.recordDate = w2.recordDate
WHERE
    temperature > temperature_yesterday;


/* 175. Combine Two Tables [E]
Write a solution to report the first name, last name, city, and state of each person in the Person table.
If the address of a personId is not present in the Address table, report null instead.
Return the result table in any order.
*/

Drop table if exists Person;
Drop table if exists Address;
Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255));
Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255));
Truncate table Person;
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
Truncate table Address;
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');

SELECT
    firstName,
    lastName,
    city,
    state
FROM
    Person p 
LEFT JOIN
    Address a ON p.personId = a.personId;


/* 1148. Article Views I [E]
Write a solution to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.
*/

Drop table if exists Views;
Create table If Not Exists Views (article_id int, author_id int, viewer_id int, view_date date);
Truncate table Views;
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');

SELECT
    DISTINCT author_id AS id
FROM
    Views
WHERE
    author_id = viewer_id
ORDER BY
    author_id ASC;


-- May 13 --

/* 181. Employees Earning More Than Their Managers [E]
Write a solution to find the employees who earn more than their managers.
Return the result table in any order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int);
Truncate table Employee;
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

SELECT
    e1.name AS Employee
FROM
    Employee e1
INNER JOIN
    Employee e2 on e1.managerId = e2.id
WHERE
    e1.salary > e2.salary;


/* 176. Second Highest Salary [M]
Write a solution to find the second highest distinct salary from the Employee table.
If there is no second highest salary, return null (return None in Pandas).
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');

-- Wrapping in a SELECT statement guarantees it will return NULL if no second element found
SELECT (
    SELECT
        DISTINCT salary
    FROM
        Employee
    ORDER BY
        salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;


/* 570. Managers with at Least 5 Direct Reports [M]
Write a solution to find managers with at least five direct reports.
Return the result table in any order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, name varchar(255), department varchar(255), managerId int);
Truncate table Employee;
insert into Employee (id, name, department, managerId) values ('101', 'John', 'A', NULL);
insert into Employee (id, name, department, managerId) values ('102', 'Dan', 'A', '101');
insert into Employee (id, name, department, managerId) values ('103', 'James', 'A', '101');
insert into Employee (id, name, department, managerId) values ('104', 'Amy', 'A', '101');
insert into Employee (id, name, department, managerId) values ('105', 'Anne', 'A', '101');
insert into Employee (id, name, department, managerId) values ('106', 'Ron', 'B', '101');

SELECT e2.name
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
GROUP BY e2.id, e2.name
HAVING COUNT(e1.id) >= 5;


/* 1661. Average Time of Process per Machine [E]
There is a factory website that has several machines each running the same number of processes.
Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp.
The average time is calculated by the total time to complete every process on the machine divided
by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time,
which should be rounded to 3 decimal places.

Return the result table in any order.
*/

Drop table if exists Activity;
Create table If Not Exists Activity (machine_id int, process_id int, activity_type ENUM('start', 'end'), timestamp float);
Truncate table Activity;
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'start', '0.712');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'end', '1.52');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'start', '3.14');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'end', '4.12');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'start', '0.55');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'end', '1.55');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'start', '0.43');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'end', '1.42');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'start', '4.1');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'end', '4.512');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'start', '2.5');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'end', '5');

SELECT machine_id, ROUND(SUM(time_complete)/COUNT(process_id), 3) AS processing_time
FROM (
    SELECT T1.machine_id, T1.process_id, (T2.time_end - T1.time_start) AS time_complete
    FROM (
        SELECT machine_id, process_id, timestamp AS time_start
        FROM Activity a1
        WHERE activity_type = 'start' -- machine_id, process_id, time_start
    ) AS T1
    JOIN (
        SELECT machine_id, process_id, timestamp AS time_end
        FROM Activity a2
        WHERE activity_type = 'end' -- machine_id, process_id, time_end
    ) AS T2 ON T1.machine_id = T2.machine_id AND T1.process_id = T2.process_id
) AS T3
GROUP BY machine_id;


/* 595. Big Countries [E]
A country is big if:
-it has an area of at least three million (i.e., 3000000 km2), or
-it has a population of at least twenty-five million (i.e., 25000000).

Write a solution to find the name, population, and area of the big countries.
Return the result table in any order.
*/

Drop table if exists World;
Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp bigint);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;


-- May 13 --

/* 1378. Replace Employee ID With The Unique Identifier [E]
Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
Return the result table in any order.
*/

Drop table if exists Employees;
Drop table if exists EmployeeUNI;
Create table If Not Exists Employees (id int, name varchar(20));
Create table If Not Exists EmployeeUNI (id int, unique_id int);
Truncate table Employees;
insert into Employees (id, name) values ('1', 'Alice');
insert into Employees (id, name) values ('7', 'Bob');
insert into Employees (id, name) values ('11', 'Meir');
insert into Employees (id, name) values ('90', 'Winston');
insert into Employees (id, name) values ('3', 'Jonathan');
Truncate table EmployeeUNI;
insert into EmployeeUNI (id, unique_id) values ('3', '1');
insert into EmployeeUNI (id, unique_id) values ('11', '2');
insert into EmployeeUNI (id, unique_id) values ('90', '3');

SELECT unique_id, name
FROM Employees
LEFT JOIN EmployeeUNI ON Employees.id = EmployeeUNI.id;


/* 185. Department Top Three Salaries [H]
A company's executives are interested in seeing who earns the most money in each of the company's departments.
A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write a solution to find the employees who are high earners in each of the departments.

Return the result table in any order.
*/

Drop table if exists Employee;
Drop table if exists Department;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Max', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (id, name, salary, departmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

-- Using first N rows
SELECT d.name AS Department,
    e1.name AS Employee,
    e1.salary AS Salary
FROM Employee e1
JOIN Department d
ON e1.departmentId = d.id
WHERE
    3 > (SELECT COUNT(DISTINCT e2.salary) -- Are there any higher salaries in the same department? There can be at most 2 higher
    FROM Employee e2
    WHERE e2.salary > e1.salary AND e1.departmentId = e2.departmentId
    );

-- Using DENSE_RANK()
SELECT Department, Employee, Salary
FROM (
    SELECT d.id, 
        d.name AS Department, 
        salary AS Salary, 
        e.name AS Employee, 
        DENSE_RANK() OVER(PARTITION BY d.id ORDER BY salary DESC) AS rnk
    FROM Department d
    JOIN Employee e
    ON d.id = e.departmentId
) AS T1
WHERE T1.rnk <= 3;


/* 1193. Monthly Transactions I [M]
Write an SQL query to find for each month and country, the number of transactions and their total amount,
the number of approved transactions and their total amount.
Return the result table in any order.
*/

Drop table if exists Transactions;
Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);
Truncate table Transactions;
insert into Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18');
insert into Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19');
insert into Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01');
insert into Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07');

-- With JOIN
SELECT T1.month AS month, T1.country AS country, trans_count, IFNULL(approved_count,0) AS approved_count, trans_total_amount, IFNULL(approved_total_amount,0) AS approved_total_amount
FROM (
    SELECT country, DATE_FORMAT(trans_date, '%Y-%m') as month, COUNT(id) AS trans_count, SUM(amount) AS trans_total_amount
    FROM Transactions
    GROUP BY country, month
) AS T1
LEFT JOIN 
(
    SELECT country, DATE_FORMAT(trans_date, '%Y-%m') as month, COUNT(id) AS approved_count, SUM(amount) AS approved_total_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY country, month
) AS T2
ON T1.country <=> T2.country AND T1.month = T2.month -- note <=> to include NULL in matching

-- Simpler *********
SELECT 
    LEFT(trans_date, 7) AS month,
    country, 
    COUNT(id) AS trans_count,
    SUM(state = 'approved') AS approved_count, -- SUM only hwere state = 'approved'
    SUM(amount) AS trans_total_amount,
    SUM((state = 'approved') * amount) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;


/* 1164. Product Price at a Given Date [M]
Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
Return the result table in any order.
*/

Drop table if exists Products;
Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

SELECT *
FROM Products;

-- Reference product list
SELECT DISTINCT product_id
FROM Products

-- List of prices at certain date
-- Remove any dates after 2019-08-16
-- Then, ake most recent date
SELECT product_id, MAX(change_date) AS change_date
FROM Products
WHERE change_date <= '2019-08-16'
GROUP BY product_id

-- Merge - any mulls should be replaced with 10
SELECT p1.product_id AS product_id, new_price AS price -- Relevant dates merged with appropriate prices
FROM Products p1
INNER JOIN (
    SELECT product_id, MAX(change_date) AS change_date
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
) AS p2
ON p1.product_id = p2.product_id AND p1.change_date = p2.change_date

-- All together
SELECT T1.product_id AS product_id, IFNULL(price, 10) AS price
FROM (
    SELECT DISTINCT product_id
    FROM Products
) AS T1 -- Unique produce IDs
LEFT JOIN (
    SELECT p1.product_id AS product_id, new_price AS price -- Relevant dates merged with appropriate prices
    FROM Products p1
    INNER JOIN (
        SELECT product_id, MAX(change_date) AS change_date
        FROM Products
        WHERE change_date <= '2019-08-16'
        GROUP BY product_id
    ) AS p2
    ON p1.product_id = p2.product_id AND p1.change_date = p2.change_date
) T2
ON T1.product_id = T2.product_id

-- OR, select obs with minimum change date over the threshold, set the price fo those to 10
-- and then UNION ALL that with the MAX(change_date) < '2019-09-16' block


/* 1581. Customer Who Visited but Did Not Make Any Transactions [E]
Write a solution to find the IDs of the users who visited without making any
transactionsand the number of times they made these types of visits.
Return the result table sorted in any order.
*/

Drop table if exists Visits;
Drop table if exists Transactions;
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

SELECT *
FROM Visits;

SELECT *
FROM Transactions;

SELECT V.customer_id AS customer_id, COUNT(V.visit_id) AS count_no_trans
FROM Visits V
LEFT JOIN Transactions T
ON V.visit_id = T.visit_id
WHERE T.transaction_id is NULL
GROUP BY customer_id

