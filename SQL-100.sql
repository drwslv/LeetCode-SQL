


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



-- May 14 --



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

-- OR, use NOT IN (maybe conceptually easier)
SELECT 
  customer_id, 
  COUNT(visit_id) AS count_no_trans 
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



-- May 15 --



/* 1280. Students and Examinations [E]
Write a solution to find the number of times each student attended each exam.
Return the result table ordered by student_id and subject_name.
*/

Drop table if exists Students;
Drop table if exists Subjects;
Drop table if exists Examinations;
Create table If Not Exists Students (student_id int, student_name varchar(20));
Create table If Not Exists Subjects (subject_name varchar(20));
Create table If Not Exists Examinations (student_id int, subject_name varchar(20));
Truncate table Students;
insert into Students (student_id, student_name) values ('1', 'Alice');
insert into Students (student_id, student_name) values ('2', 'Bob');
insert into Students (student_id, student_name) values ('13', 'John');
insert into Students (student_id, student_name) values ('6', 'Alex');
Truncate table Subjects;
insert into Subjects (subject_name) values ('Math');
insert into Subjects (subject_name) values ('Physics');
insert into Subjects (subject_name) values ('Programming');
Truncate table Examinations;
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Programming');
insert into Examinations (student_id, subject_name) values ('2', 'Programming');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Programming');
insert into Examinations (student_id, subject_name) values ('13', 'Physics');
insert into Examinations (student_id, subject_name) values ('2', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Math');

SELECT *
FROM Students;

SELECT *
FROM Subjects;

SELECT *
FROM Examinations;

SELECT S.student_id AS student_id, S.student_name AS student_name, S.subject_name AS subject_name, IFNULL(E.attended_exams, 0) AS attended_exams
FROM (
    SELECT *
    FROM Students St
    CROSS JOIN Subjects Su
) AS S
LEFT JOIN (
    SELECT student_id, subject_name, COUNT(subject_name) AS attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
) AS E
ON S.student_id = E.student_id AND S.subject_name = E.subject_name
ORDER BY S.student_id, S.subject_name;


/* 1251. Average Selling Price [E]
Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.
If a product does not have any sold units, its average selling price is assumed to be 0.
Return the result table in any order.

*/

Drop table if exists Prices;
Drop table if exists UnitsSold;
Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int);
Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int);
Truncate table Prices;
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30');
Truncate table UnitsSold;
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30');

SELECT *
FROM Prices;

SELECT *
FROM UnitsSold;

SELECT Pd.product_id AS product_id, IFNULL(T.average_price,0) AS average_price
FROM (
    SELECT DISTINCT product_id
    FROM Prices
) AS Pd
LEFT JOIN (
    SELECT R.product_id, ROUND(SUM(R.agg_rev)/SUM(R.units), 2) AS average_price
    FROM (
        SELECT P.product_id, U.units, (P.price * U.units) AS agg_rev
        FROM Prices P
        LEFT JOIN UnitsSold U
        ON P.product_id = U.product_id
        WHERE U.purchase_date >= P.start_date AND U.purchase_date <= P.end_date
    ) AS R
    GROUP BY R.product_id
) AS T
ON Pd.product_id = T.product_id;


SELECT
    p.product_id,
    IFNULL(ROUND(SUM(p.price * u.units) / SUM(u.units), 2), 0) AS average_price
FROM
    Prices AS p
LEFT JOIN
    UnitsSold AS u
ON
    p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
    p.product_id;


/* 1934. Confirmation Rate [M]
The confirmation rate of a user is the number of 'confirmed' messages divided by the total number
of requested confirmation messages. The confirmation rate of a user that did not request any
confirmation messages is 0. Round the confirmation rate to two decimal places.

Write a solution to find the confirmation rate of each user.

Return the result table in any order.
*/

Drop table if exists Signups;
Drop table if exists Confirmations;
Create table If Not Exists Signups (user_id int, time_stamp datetime);
Create table If Not Exists Confirmations (user_id int, time_stamp datetime, action ENUM('confirmed','timeout'));
Truncate table Signups;
insert into Signups (user_id, time_stamp) values ('3', '2020-03-21 10:16:13');
insert into Signups (user_id, time_stamp) values ('7', '2020-01-04 13:57:59');
insert into Signups (user_id, time_stamp) values ('2', '2020-07-29 23:09:44');
insert into Signups (user_id, time_stamp) values ('6', '2020-12-09 10:39:37');
Truncate table Confirmations;
insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-01-06 03:30:46', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-07-14 14:00:00', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-12 11:57:29', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-13 12:58:28', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-14 13:59:27', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-01-22 00:00:00', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-02-28 23:59:59', 'timeout');

SELECT *
FROM Signups;

SELECT *
FROM Confirmations;

SELECT S.user_id AS user_id, IFNULL( ROUND( SUM(C.action = 'confirmed')/COUNT(C.action), 2)    , 0) AS confirmation_rate
FROM Signups S
LEFT JOIN
Confirmations C
ON S.user_id = C.user_id
GROUP BY S.user_id;


/* 610. Triangle Judgement [E]
Report for every three line segments whether they can form a triangle.
Return the result table in any order.
*/

Drop table if exists Triangle;
Create table If Not Exists Triangle (x int, y int, z int);
Truncate table Triangle;
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

SELECT *
FROM Triangle;

-- max < sum of other two sides
-- max < sum of all sides - max
-- 0 < sum of all sides - 2 max

SELECT *, IF((x + y + z) - 2*GREATEST(x, y, z) > 0, 'Yes', 'No') AS triangle
FROM Triangle;

-- OR more simply

SELECT 
    x,
    y,
    z,
    CASE
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS 'triangle'
FROM
    triangle
;


/* 182. Duplicate Emails [E]
Write a solution to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.
Return the result table in any order.
*/

Drop table if exists Person;
Create table If Not Exists Person (id int, email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');

SELECT *
FROM Person;

SELECT T.email AS Email
FROM (
    SELECT email, COUNT(id) AS email_count
    FROM Person
    GROUP BY email
    HAVING email_count > 1
) AS T



-- May 16 --



/* 577. Employee Bonus [E]
Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
Return the result table in any order.
*/

Drop table if exists Employee;
Drop table if exists Bonus;
Create table If Not Exists Employee (empId int, name varchar(255), supervisor int, salary int);
Create table If Not Exists Bonus (empId int, bonus int);
Truncate table Employee;
insert into Employee (empId, name, supervisor, salary) values ('3', 'Brad', NULL, '4000');
insert into Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000');
insert into Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000');
insert into Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000');
Truncate table Bonus;
insert into Bonus (empId, bonus) values ('2', '500');
insert into Bonus (empId, bonus) values ('4', '2000');

SELECT *
FROM Employee;

SELECT *
FROM Bonus;

SELECT E.name as name, B.bonus as bonus
FROM Employee E
LEFT JOIN Bonus B
ON E.empId = B.empId
WHERE B.bonus < 1000 OR B.bonus IS NULL;


/* 180. Consecutive Numbers [M]
Find all numbers that appear at least three times consecutively.
Return the result table in any order.
*/

Drop table if exists Logs;
Create table If Not Exists Logs (id int, num int);
Truncate table Logs;
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');

SELECT *
FROM Logs;

SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT *, LAG(T.num_1) OVER (ORDER BY id) AS num_2
    FROM(
        SELECT *, LAG(num) OVER (ORDER BY id) AS num_1
        FROM Logs
    ) AS T
) AS T2
WHERE T2.num = T2.num_1 AND T2.num_1 = T2.num_2;

SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT *, LAG(num, 1) OVER () AS num_1, LAG(num, 2) OVER () AS num_2
    FROM Logs
) AS T
WHERE num = num_1 AND num_1 = num_2;

-- With three-way merge

SELECT DISTINCT
    l1.Num AS ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;


/* 550. Game Play Analysis IV [M]
Write a solution to report the fraction of players that logged in again on the day after the day
they first logged in, rounded to 2 decimal places. In other words, you need to count the number
of players that logged in for at least two consecutive days starting from their first login date,
then divide that number by the total number of players.
*/

Drop table if exists Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

SELECT *
FROM Activity;

-- FIRST (!) login

SELECT ROUND(
(
    SELECT COUNT(DISTINCT A.player_id) AS player_logged
    FROM Activity A
    INNER JOIN (
        SELECT player_id, DATE_ADD(T.first_login, INTERVAL 1 day) AS second_login -- Create necessary second logins by players and date
        FROM (
            SELECT player_id, min(event_date) AS first_login
            FROM Activity
            GROUP BY player_id
        ) AS T
    ) AS T2
    ON A.player_id = T2.player_id AND A.event_date = T2.second_login
) / 
(
    SELECT COUNT(DISTINCT player_id) AS player_total
    FROM Activity
),2) AS fraction;

-- Using WITH
WITH first_logins AS (
  SELECT
    A.player_id,
    MIN(A.event_date) AS first_login
  FROM
    Activity A
  GROUP BY
    A.player_id
), consec_logins AS (
  SELECT
    COUNT(A.player_id) AS num_logins
  FROM
    first_logins F
    INNER JOIN Activity A ON F.player_id = A.player_id
    AND F.first_login = DATE_SUB(A.event_date, INTERVAL 1 DAY)
)
SELECT
  ROUND(
    (SELECT C.num_logins FROM consec_logins C)
    / (SELECT COUNT(F.player_id) FROM first_logins F)
  , 2) AS fraction;


/* 626. Exchange Seats [M]
Write a solution to swap the seat id of every two consecutive students.
If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.
*/

Drop table if exists Seat;
Create table If Not Exists Seat (id int, student varchar(255));
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');

SELECT *
FROM Seat;

-- Shift down, save evens
-- Shift up, save odds

SELECT T.id as id, IFNULL(T.student_new, student) AS student
FROM (
    SELECT *
    FROM (
        SELECT *, LAG(student, 1) OVER () AS student_new
        FROM Seat
    ) AS S1
    WHERE MOD(S1.id, 2)=0
    UNION
    SELECT *
    FROM (
        SELECT *, LEAD(student, 1) OVER () AS student_new
        FROM Seat
    ) AS S2
    WHERE MOD(S2.id, 2)=1
) AS T
ORDER BY id ASC


/* 1070. Product Sales Analysis III [M]
Write a solution to select the product id, year, quantity, and price for the first year of every
product sold. If any product is bought multiple times in its first year, return all sales separately.
Return the resulting table in any order.
*/

Drop table if exists Sales;
Drop table if exists Product;
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

SELECT *
FROM Sales;

SELECT *
FROM Product;

SELECT
    T0.product_id AS product_id,
    T0.year AS first_year,
    T0.quantity AS quantity,
    T0.price as price
FROM (
    SELECT *
    From Sales
) AS T0
INNER JOIN (
    SELECT product_id, MIN(year) AS year -- Find earliest year for year-product combinations
    FROM Sales
    GROUP BY product_id
) AS T1
ON T0.product_id = T1.product_id AND T0.year = T1.year



-- May 17 --



/* 1068. Product Sales Analysis I [E]
Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
Return the resulting table in any order.
*/

Drop table if exists Sales;
Drop table if exists Product;
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

SELECT *
FROM Sales;

SELECT *
FROM Product;

SELECT P.product_name AS product_name, S.year AS year, S.price AS price
FROM Sales S
JOIN Product P
ON S.product_id = P.product_id;


/* 183. Customers Who Never Order [E]
Write a solution to find all customers who never order anything.
Return the result table in any order.
*/

Drop table if exists Customers;
Drop table if exists Orders;
Create table If Not Exists Customers (id int, name varchar(255));
Create table If Not Exists Orders (id int, customerId int);
Truncate table Customers;
insert into Customers (id, name) values ('1', 'Joe');
insert into Customers (id, name) values ('2', 'Henry');
insert into Customers (id, name) values ('3', 'Sam');
insert into Customers (id, name) values ('4', 'Max');
Truncate table Orders;
insert into Orders (id, customerId) values ('1', '3');
insert into Orders (id, customerId) values ('2', '1');

SELECT *
FROM Customers;

SELECT *
FROM Orders;

SELECT name AS Customers
FROM Customers
WHERE id NOT IN (
    SELECT customerId
    FROM Orders
);


/* 1174. Immediate Food Delivery II [M]
If the customer's preferred delivery date is the same as the order date, then the order is called immediate;
otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made.
It is guaranteed that a customer has precisely one first order.
Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
*/

Drop table if exists Delivery;
Create table If Not Exists Delivery (delivery_id int, customer_id int, order_date date, customer_pref_delivery_date date);
Truncate table Delivery;
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('1', '1', '2019-08-01', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('2', '2', '2019-08-02', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('3', '1', '2019-08-11', '2019-08-12');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('4', '3', '2019-08-24', '2019-08-24');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('5', '3', '2019-08-21', '2019-08-22');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('6', '2', '2019-08-11', '2019-08-13');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('7', '4', '2019-08-09', '2019-08-09');

SELECT *
FROM Delivery;

SELECT ROUND(100*SUM(T.immediate)/COUNT(*),2) AS immediate_percentage
FROM (
    SELECT D1.order_date AS order_date, customer_pref_delivery_date, IF(D1.order_date = D1.customer_pref_delivery_date, 1, 0) AS immediate
    FROM Delivery D1
    INNER JOIN (
        SELECT customer_id, MIN(order_date) AS order_date -- First orders
        FROM Delivery
        GROUP BY customer_id
    ) AS DF
    ON D1.customer_id = DF.customer_id AND D1.order_date = DF.order_date
) T;

SELECT ROUND(100*SUM(T.order_date = T.customer_pref_delivery_date)/COUNT(*),2) AS immediate_percentage
FROM (
    SELECT D1.order_date AS order_date, customer_pref_delivery_date
    FROM Delivery D1
    INNER JOIN (
        SELECT customer_id, MIN(order_date) AS order_date -- First orders
        FROM Delivery
        GROUP BY customer_id
    ) AS DF
    ON D1.customer_id = DF.customer_id AND D1.order_date = DF.order_date
) T;


/* 196. Delete Duplicate Emails [E]
Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.

For Pandas users, please note that you are supposed to modify Person in place.

After running your script, the answer shown is the Person table. The driver will first compile and
run your piece of code and then show the Person table. The final order of the Person table does not matter.
*/

Drop table if exists Person;
Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');

SELECT *
FROM Person;

DELETE FROM Person
WHERE Id NOT IN (
    SELECT *
    FROM (
        SELECT MIN(Id)
        FROM Person
        GROUP BY Email
    ) AS sub
)

-- OR, more efficient
DELETE P1 
FROM Person P1, Person P2
WHERE P1.Email = P2.email AND P1.Id > P2.Id


/* 1683. Invalid Tweets [E]
Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of
characters used in the content of the tweet is strictly greater than 15.
Return the result table in any order.
*/

Drop table if exists Tweets;
Create table If Not Exists Tweets(tweet_id int, content varchar(50));
Truncate table Tweets;
insert into Tweets (tweet_id, content) values ('1', 'Let us Code');
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!');

SELECT *
FROM Tweets;

SELECT tweet_id
FROM Tweets
WHERE CHAR_LENGTH(content) > 15



-- May 18 --



/* 177. Nth Highest Salary [M]
Write a solution to find the nth highest distinct salary from the Employee table.
If there are less than n distinct salaries, return null.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (Id int, Salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');
insert into Employee (id, salary) values ('3', '300');


SELECT *
FROM Employee;

-- Can't use a window function (RANK) inside a function declaration
SELECT DISTINCT T.Salary
FROM (
    SELECT Salary, RANK() OVER (ORDER BY Salary) AS Salary_rank
    FROM Employee
) T
WHERE T.Salary_rank = 5;

-- Correlated subquery
-- For each salary in E1, how many distinct salaries in E2 are greater or equal?
-- If Salary=100 in E1, then in E2 there is 100, 200, and 300, so 3 distinct salaries, so 100 is rank 3
SELECT DISTINCT Salary
FROM Employee E1
WHERE 3 = (
    SELECT COUNT(DISTINCT Salary)
    FROM Employee E2
    WHERE E2.Salary >= E1.Salary
);

SELECT COUNT(DISTINCT Salary)
FROM Employee E2;

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        -- Write your MySQL query statement below.
        SELECT DISTINCT Salary
        FROM Employee E1
        WHERE N = (
            SELECT COUNT(DISTINCT Salary)
            FROM Employee E2
            WHERE E2.Salary >= E1.Salary
        )
    );
END

SELECT getNthHighestSalary(5);

-- OR, even easier, limit/offset
SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 2 OFFSET 1


/* 1204. Last Person to Fit in the Bus [M]
There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms,
so there may be some people who cannot board.
Write a solution to find the person_name of the last person that can fit on the bus without exceeding the
weight limit. The test cases are generated such that the first person does not exceed the weight limit.
Note that only one person can board the bus at any given turn.
*/

Drop table if exists Queue;
Create table If Not Exists Queue (person_id int, person_name varchar(30), weight int, turn int);
Truncate table Queue;
insert into Queue (person_id, person_name, weight, turn) values ('5', 'Alice', '250', '1');
insert into Queue (person_id, person_name, weight, turn) values ('4', 'Bob', '175', '5');
insert into Queue (person_id, person_name, weight, turn) values ('3', 'Alex', '350', '2');
insert into Queue (person_id, person_name, weight, turn) values ('6', 'John Cena', '400', '3');
insert into Queue (person_id, person_name, weight, turn) values ('1', 'Winston', '500', '6');
insert into Queue (person_id, person_name, weight, turn) values ('2', 'Marie', '200', '4');

SELECT *
FROM Queue;

SELECT person_name
FROM (
    SELECT *, SUM(weight) OVER (ORDER BY turn) AS weight_sum
    FROM Queue
) T
WHERE T.weight_sum <= 1000
ORDER BY weight_sum DESC
LIMIT 1;


-- Smarter: correlated subquery
SELECT 
    *
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1;


/* 1211. Queries Quality and Percentage
We define query quality as:
    The average of the ratio between query rating and its position.

We also define poor query percentage as:
    The percentage of all queries with rating less than 3.

Write a solution to find each query_name, the quality and poor_query_percentage.
Both quality and poor_query_percentage should be rounded to 2 decimal places.
Return the result table in any order.
*/

Drop table if exists Queries;
Create table If Not Exists Queries (query_name varchar(30), result varchar(50), position int, rating int);
Truncate table Queries;
insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Sphynx', '7', '4');

SELECT *
FROM Queries;

SELECT T.query_name AS query_name, ROUND(AVG(T.quality_ind), 2) AS quality, ROUND(AVG(T.poor_ind)*100,2) AS poor_query_percentage
FROM (
    SELECT *, (rating/position) AS quality_ind, IF(rating < 3, 1, 0) AS poor_ind
    FROM Queries
) AS T
GROUP BY T.query_name


/* 1321. Restaurant Growth [M]
You are the restaurant owner and you want to analyze a possible expansion
(there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window
(i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

*/

Drop table if exists Customer;
Create table If Not Exists Customer (customer_id int, name varchar(20), visited_on date, amount int);
Truncate table Customer;
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-01', '100');
insert into Customer (customer_id, name, visited_on, amount) values ('2', 'Daniel', '2019-01-02', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-03', '120');
insert into Customer (customer_id, name, visited_on, amount) values ('4', 'Khaled', '2019-01-04', '130');
insert into Customer (customer_id, name, visited_on, amount) values ('5', 'Winston', '2019-01-05', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('6', 'Elvis', '2019-01-06', '140');
insert into Customer (customer_id, name, visited_on, amount) values ('7', 'Anna', '2019-01-07', '150');
insert into Customer (customer_id, name, visited_on, amount) values ('8', 'Maria', '2019-01-08', '80');
insert into Customer (customer_id, name, visited_on, amount) values ('9', 'Jaze', '2019-01-09', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-10', '130');
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-10', '150');

SELECT *
FROM Customer;

SELECT T2.visited_on AS visited_on, T2.amount7 AS amount, T2.average_amount7 AS average_amount
FROM (
    SELECT *,
        ROUND(SUM(T.amount) OVER (
        ORDER BY visited_on ASC
        RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ),2) AS amount7,
        ROUND(AVG(T.amount) OVER (
        ORDER BY visited_on ASC
        RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ),2) AS average_amount7
    FROM (
        SELECT visited_on, SUM(amount) AS amount
        FROM Customer
        GROUP BY visited_on
    ) AS T
) AS T2
WHERE T2.visited_on >= (
    SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 day)
    FROM Customer
);


/* 1141. User Activity for the Past 30 Days I [E]
Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively.
A user was active on someday if they made at least one activity on that day.
Return the result table in any order.
*/

Drop table if exists Activity;
Create table If Not Exists Activity (user_id int, session_id int, activity_date date, activity_type ENUM('open_session', 'end_session', 'scroll_down', 'send_message'));
Truncate table Activity;
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'scroll_down');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'end_session');

SELECT *
FROM Activity;

SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 day) AND '2019-07-27'
GROUP BY activity_date;



-- May 18 Pt. 2 --



/* 1731. The Number of Employees Which Report to Each Employee [E]
For this problem, we will consider a manager [to be] an employee who has at least 1 other employee reporting to them.

Write a solution to report the ids and the names of all managers, the number of employees who report directly to them,
and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.
*/

Drop table if exists Employees;
Create table If Not Exists Employees(employee_id int, name varchar(20), reports_to int, age int);
Truncate table Employees;
insert into Employees (employee_id, name, reports_to, age) values ('9', 'Hercy', NULL, '43');
insert into Employees (employee_id, name, reports_to, age) values ('6', 'Alice', '9', '41');
insert into Employees (employee_id, name, reports_to, age) values ('4', 'Bob', '9', '36');
insert into Employees (employee_id, name, reports_to, age) values ('2', 'Winston', NULL, '37');

SELECT *
FROM Employees;

SELECT E2.employee_id AS employee_id, E2.name AS name, COUNT(*) AS reports_count, ROUND(AVG(E1.age),0) AS average_age
FROM Employees E1
INNER JOIN Employees E2
ON E1.reports_to = E2.employee_id
GROUP BY E2.employee_id, E2.name
ORDER BY employee_id;


/* 602. Friend Requests II: Who Has the Most Friends [M]
Write a solution to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.
*/

Drop table if exists RequestAccepted;
Create table If Not Exists RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null);
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

SELECT *
FROM RequestAccepted;

SELECT T.id as id, COUNT(*) as num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id
    FROM RequestAccepted
) AS T
GROUP BY T.id
ORDER BY num DESC
LIMIT 1;


/* 620. Not Boring Movies [E]
Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
Return the result table ordered by rating in descending order.
*/

Drop table if exists cinema;
Create table If Not Exists cinema (id int, movie varchar(255), description varchar(255), rating float(2, 1));
Truncate table cinema;
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9');
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5');
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2');
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6');
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1');

SELECT *
FROM cinema;

SELECT *
FROM cinema
WHERE MOD(id, 2) = 1 and description != 'boring'
ORDER BY rating DESC;


/* 184. Department Highest Salary [M]
Write a solution to find employees who have the highest salary in each of the departments.
Return the result table in any order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

SELECT *
FROM Employee;

SELECT *
FROM Department;

SELECT T1.department AS Department, T1.name AS Employee, T1.salary AS Salary
FROM (
    SELECT E.id AS id, E.name AS name, E.salary AS salary, E.departmentId AS departmentId, D.name as department
    FROM Employee E
    LEFT JOIN Department D
    ON E.departmentId = D.id
) AS T1
LEFT JOIN (
    SELECT departmentId, MAX(salary) AS salary, 1 AS max_salary
    FROM Employee
    GROUP BY departmentId
) AS T2
ON T1.departmentId = T2.departmentId AND T1.salary = T2.salary
WHERE T2.max_salary = 1;


/* 3214. Year on Year Growth Rate [H]
Write a solution to calculate the year-on-year growth rate for the total spend for each product.

The result table should include the following columns:
* year: The year of the transaction.
* product_id: The ID of the product.
* curr_year_spend: The total spend for the current year.
* prev_year_spend: The total spend for the previous year.
* yoy_rate: The year-on-year growth rate percentage, rounded to 2 decimal places.

Return the result table ordered by product_id,year in ascending order.
*/

Drop table if exists user_transactions;
Create Table if not exists user_transactions( transaction_id int, product_id int, spend decimal(10,2), transaction_date datetime);
Truncate table user_transactions;
insert into user_transactions (transaction_id, product_id, spend, transaction_date) values ('1341', '123424', '1500.6', '2019-12-31 12:00:00');
insert into user_transactions (transaction_id, product_id, spend, transaction_date) values ('1423', '123424', '1000.2', '2020-12-31 12:00:00');
insert into user_transactions (transaction_id, product_id, spend, transaction_date) values ('1623', '123424', '1246.44', '2021-12-31 12:00:00');
insert into user_transactions (transaction_id, product_id, spend, transaction_date) values ('1322', '123424', '2145.32', '2022-12-31 12:00:00');

SELECT *
FROM user_transactions;

WITH Q1 AS (
    SELECT  T.year, T.product_id, SUM(spend) AS curr_year_spend
    FROM (
        SELECT *, SUBSTRING(transaction_date, 1, 4) AS year
        FROM user_transactions
    ) AS T
    GROUP BY T.product_id, T.year
)
SELECT Q1.year+0 AS year, Q1.product_id AS product_id, Q1.curr_year_spend as curr_year_spend,
    Q2.prev_year_spend AS prev_year_spend, ROUND(100*(Q1.curr_year_spend - Q2.prev_year_spend)/Q2.prev_year_spend,2) AS yoy_rate
FROM Q1
LEFT JOIN (
    SELECT year+1 AS year, product_id as product_id, curr_year_spend as prev_year_spend
    FROM Q1
) Q2
ON Q1.year = Q2.year AND Q1.product_id = Q2.product_id
ORDER BY product_id, year ASC



-- May 19 --



/* 1667. Fix Names in a Table [E]
Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id.
*/

Drop table if exists Users;
Create table If Not Exists Users (user_id int, name varchar(40));
Truncate table Users;
insert into Users (user_id, name) values ('1', 'aLice');
insert into Users (user_id, name) values ('2', 'bOB');

SELECT *
FROM Users;

SELECT user_id, CONCAT(UPPER(SUBSTRING(name,1,1)), LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id;


/* 511. Game Play Analysis I [E]
Write a solution to find the first login date for each player.
Return the result table in any order.
*/

Drop table if exists Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

SELECT *
FROM Activity;

SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;


/* 262. Trips and Users [H]
The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users
by the total number of requests with unbanned users on that day.
Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not be banned)
each day between "2013-10-01" and "2013-10-03" with at least one trip. Round Cancellation Rate to two decimal points.
Return the result table in any order.
*/

Drop table if exists Trips;
Drop table if exists Users;
Create table If Not Exists Trips (id int, client_id int, driver_id int, city_id int, status ENUM('completed', 'cancelled_by_driver', 'cancelled_by_client'), request_at varchar(50));
Create table If Not Exists Users (users_id int, banned varchar(50), role ENUM('client', 'driver', 'partner'));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

SELECT *
FROM Trips;

SELECT *
FROM Users;

SELECT A.request_at AS Day, ROUND(SUM(status = 'cancelled_by_client' or status = 'cancelled_by_driver')/COUNT(status),2) AS 'Cancellation Rate'
FROM (
    SELECT status, request_at
    FROM Trips T
    LEFT JOIN ( -- LEFT JOIN with client info only
        SELECT users_id AS client_id, banned AS banned_client
        FROM Users
        WHERE role = 'client'
    ) AS C
    ON T.client_id = C.client_id 
    LEFT JOIN ( -- LEFT JOIN with driver info only
        SELECT users_id as driver_id, banned AS banned_driver
        FROM Users
        WHERE role = 'driver'
    ) AS D
    ON T.driver_id = D.driver_id
    WHERE C.banned_client = 'No' AND D.banned_driver = 'no' -- filter valid clients and drivers
        AND T.request_at >= '2013-10-01' AND T.request_at <= '2013-10-03' 
) AS A
GROUP BY A.request_at;

-- Without top subqueries
SELECT request_at AS Day, ROUND(SUM(status = 'cancelled_by_client' or status = 'cancelled_by_driver')/COUNT(status),2) AS 'Cancellation Rate'
    FROM Trips T
    LEFT JOIN ( -- LEFT JOIN with client info only
        SELECT users_id AS client_id, banned AS banned_client
        FROM Users
        WHERE role = 'client'
    ) AS C
    ON T.client_id = C.client_id 
    LEFT JOIN ( -- LEFT JOIN with driver info only
        SELECT users_id as driver_id, banned AS banned_driver
        FROM Users
        WHERE role = 'driver'
    ) AS D
    ON T.driver_id = D.driver_id
    WHERE C.banned_client = 'No' AND D.banned_driver = 'no' -- filter valid clients and drivers
        AND T.request_at >= '2013-10-01' AND T.request_at <= '2013-10-03' 
GROUP BY T.request_at;


/* 1978. Employees Whose Manager Left the Company [E]
Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company.
When a manager leaves the company, their information is deleted from the Employees table,
but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id.
*/

Drop table if exists Employees;
Create table If Not Exists Employees (employee_id int, name varchar(20), manager_id int, salary int);
Truncate table Employees;
insert into Employees (employee_id, name, manager_id, salary) values ('3', 'Mila', '9', '60301');
insert into Employees (employee_id, name, manager_id, salary) values ('12', 'Antonella', NULL, '31000');
insert into Employees (employee_id, name, manager_id, salary) values ('13', 'Emery', NULL, '67084');
insert into Employees (employee_id, name, manager_id, salary) values ('1', 'Kalel', '11', '21241');
insert into Employees (employee_id, name, manager_id, salary) values ('9', 'Mikaela', NULL, '50937');
insert into Employees (employee_id, name, manager_id, salary) values ('11', 'Joziah', '6', '28485');

SELECT *
FROM Employees;

SELECT employee_id
FROM Employees
WHERE salary < 30000
AND manager_id NOT IN (
    SELECT E2.employee_id
    FROM Employees E2
)
ORDER BY employee_id;


/* 1596. The Most Frequently Ordered Products for Each Customer [M]
Write a solution to find the most frequently ordered product(s) for each customer.
The result table should have the product_id and product_name for each customer_id who ordered at least one order.
Return the result table in any order.
*/

Drop table if exists Customers;
Drop table if exists Orders;
Drop table if exists Products;
Create table If Not Exists Customers (customer_id int, name varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, customer_id int, product_id int);
Create table If Not Exists Products (product_id int, product_name varchar(20), price int);
Truncate table Customers;
insert into Customers (customer_id, name) values ('1', 'Alice');
insert into Customers (customer_id, name) values ('2', 'Bob');
insert into Customers (customer_id, name) values ('3', 'Tom');
insert into Customers (customer_id, name) values ('4', 'Jerry');
insert into Customers (customer_id, name) values ('5', 'John');
Truncate table Orders;
insert into Orders (order_id, order_date, customer_id, product_id) values ('1', '2020-07-31', '1', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('2', '2020-7-30', '2', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('3', '2020-08-29', '3', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('4', '2020-07-29', '4', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('5', '2020-06-10', '1', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('6', '2020-08-01', '2', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('7', '2020-08-01', '3', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('8', '2020-08-03', '1', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('9', '2020-08-07', '2', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('10', '2020-07-15', '1', '2');
Truncate table Products;
insert into Products (product_id, product_name, price) values ('1', 'keyboard', '120');
insert into Products (product_id, product_name, price) values ('2', 'mouse', '80');
insert into Products (product_id, product_name, price) values ('3', 'screen', '600');
insert into Products (product_id, product_name, price) values ('4', 'hard disk', '450');

SELECT *
FROM Customers;

SELECT *
FROM Orders;

SELECT *
FROM Products;

WITH PC AS ( -- unique customer_id, product_id with purchase_count
    SELECT customer_id, product_id, COUNT(*) AS purchase_count
    FROM Orders
    GROUP BY customer_id, product_id
)
SELECT PC1.customer_id AS customer_id, PC1.product_id AS product_id, P.product_name AS product_name
FROM PC PC1
INNER JOIN ( -- max product count number per customer_id
    SELECT customer_id, MAX(purchase_count) AS pc_max
    FROM PC
    GROUP BY customer_id
) AS PC2
ON PC1.customer_id = PC2.customer_id AND PC1.purchase_count = PC2.pc_max
INNER JOIN -- add product_name
    Products P
ON PC1.product_id = P.product_id
ORDER BY PC1.customer_id;



-- May 20 / May 21 --



/* 178. Rank Scores [M]
Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:

* The scores should be ranked from the highest to the lowest.
* If there is a tie between two scores, both should have the same ranking.
* After a tie, the next ranking number should be the next consecutive integer value. In other words,
there should be no holes between ranks.

Return the result table ordered by score in descending order.
*/

Drop table if exists Scores;
Create table If Not Exists Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');

SELECT *
FROM Scores;

SELECT S1.score AS score, S2.rnk AS 'rank'
FROM Scores S1
LEFT JOIN (
    SELECT *, RANK() OVER (ORDER BY G.score DESC) AS rnk
    FROM (
        SELECT score
        FROM Scores
        GROUP BY score
    ) as G
) AS S2
ON S1.score = S2.score
ORDER BY S1.score DESC;


/* 1336. Number of Transactions per Visit [H]
A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank
and the corresponding number of visitors who have done this number of transaction in one visit.

Write a solution to find how many users visited the bank and didn't do any transactions, how many
visited the bank and did one transaction, and so on.

The result table will contain two columns:

* transactions_count which is the number of transactions done in one visit.
* visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.

transactions_count should take all values from 0 to max(transactions_count) done by one or more users.

Return the result table ordered by transactions_count.
*/

Drop table if exists Visits;
Drop table if exists Transactions;
Create table If Not Exists Visits (user_id int, visit_date date);
Create table If Not Exists Transactions (user_id int, transaction_date date, amount int);
Truncate table Visits;
insert into Visits (user_id, visit_date) values ('1', '2020-01-01');
insert into Visits (user_id, visit_date) values ('2', '2020-01-02');
insert into Visits (user_id, visit_date) values ('12', '2020-01-01');
insert into Visits (user_id, visit_date) values ('19', '2020-01-03');
insert into Visits (user_id, visit_date) values ('1', '2020-01-02');
insert into Visits (user_id, visit_date) values ('2', '2020-01-03');
insert into Visits (user_id, visit_date) values ('1', '2020-01-04');
insert into Visits (user_id, visit_date) values ('7', '2020-01-11');
insert into Visits (user_id, visit_date) values ('9', '2020-01-25');
insert into Visits (user_id, visit_date) values ('8', '2020-01-28');
Truncate table Transactions;
insert into Transactions (user_id, transaction_date, amount) values ('1', '2020-01-02', '120');
insert into Transactions (user_id, transaction_date, amount) values ('2', '2020-01-03', '22');
insert into Transactions (user_id, transaction_date, amount) values ('7', '2020-01-11', '232');
insert into Transactions (user_id, transaction_date, amount) values ('1', '2020-01-04', '7');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '33');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '66');
insert into Transactions (user_id, transaction_date, amount) values ('8', '2020-01-28', '1');
insert into Transactions (user_id, transaction_date, amount) values ('9', '2020-01-25', '99');

SELECT *
FROM Visits;

SELECT *
FROM Transactions;

WITH RECURSIVE R AS( -- transactions_count, visits_count
    SELECT transactions_count, COUNT(*) AS visits_count
    FROM(
        SELECT V.user_id AS user_id, V.visit_date AS visit_date, IFNULL(T.transactions_count, 0) AS transactions_count
        FROM Visits V
        LEFT JOIN (
            SELECT user_id, transaction_date, COUNT(*) AS transactions_count
            FROM Transactions 
            GROUP BY user_id, transaction_date
        ) AS T
        ON V.user_id = T.user_id AND V.visit_date = T.transaction_date
    ) AS G
    GROUP BY transactions_count
),
seq(n) AS ( -- This creates a sequence from 0 to MAX(transactions_count)
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM seq
  WHERE n < (SELECT MAX(transactions_count) FROM R)
)
SELECT S.transactions_count AS transactions_count, IFNULL(visits_count, 0) AS visits_count
FROM (
    SELECT n AS transactions_count
    from seq
) S
LEFT JOIN R
ON S.transactions_count = R.transactions_count
ORDER BY S.transactions_count;


/* 1789. Primary Department for Each Employee [E]
Employees can belong to multiple departments. When the employee joins other departments,
they need to decide which department is their primary department. Note that when an employee
belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who
belong to one department, report their only department.

Return the result table in any order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (employee_id int, department_id int, primary_flag ENUM('Y','N'));
Truncate table Employee;
insert into Employee (employee_id, department_id, primary_flag) values ('1', '1', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('2', '1', 'Y');
insert into Employee (employee_id, department_id, primary_flag) values ('2', '2', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('3', '3', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '2', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '3', 'Y');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '4', 'N');

SELECT *
FROM Employee

SELECT E1.employee_id AS employee_id, E1.department_id AS department_id
FROM Employee E1
JOIN (
    SELECT E2.employee_id, COUNT(*) AS dept_cnt
    FROM Employee E2
    GROUP BY E2.employee_id
    HAVING dept_cnt = 1
) AS G
ON E1.employee_id = G.employee_id
UNION ALL
SELECT E.employee_id AS employee_id, E.department_id AS department_id
FROM Employee E
WHERE primary_flag = 'Y'
ORDER BY employee_id


/* 586. Customer Placing the Largest Number of Orders [E]
Write a solution to find the customer_number for the customer who has placed the largest number of orders.
The test cases are generated so that exactly one customer will have placed more orders than any other customer.
*/

Drop table if exists orders;
Create table If Not Exists orders (order_number int, customer_number int);
Truncate table orders;
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');

SELECT *
FROM orders;

SELECT T.customer_number AS customer_number
FROM (
    SELECT customer_number, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_number
) AS T
ORDER BY order_count DESC
LIMIT 1


/* 633. Percentage of Users Attended a Contest [E]
Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.
*/

Drop table if exists Users;
Drop table if exists Register;
Create table If Not Exists Users (user_id int, user_name varchar(20));
Create table If Not Exists Register (contest_id int, user_id int);
Truncate table Users;
insert into Users (user_id, user_name) values ('6', 'Alice');
insert into Users (user_id, user_name) values ('2', 'Bob');
insert into Users (user_id, user_name) values ('7', 'Alex');
Truncate table Register;
insert into Register (contest_id, user_id) values ('215', '6');
insert into Register (contest_id, user_id) values ('209', '2');
insert into Register (contest_id, user_id) values ('208', '2');
insert into Register (contest_id, user_id) values ('210', '6');
insert into Register (contest_id, user_id) values ('208', '6');
insert into Register (contest_id, user_id) values ('209', '7');
insert into Register (contest_id, user_id) values ('209', '6');
insert into Register (contest_id, user_id) values ('215', '7');
insert into Register (contest_id, user_id) values ('208', '7');
insert into Register (contest_id, user_id) values ('210', '2');
insert into Register (contest_id, user_id) values ('207', '2');
insert into Register (contest_id, user_id) values ('210', '7');

SELECT *
FROM Users;

SELECT *
FROM Register;

SELECT contest_id,
    (
        ROUND(100*COUNT(*)/(SELECT COUNT(user_id) FROM Users), 2)
    ) AS percentage
FROM Register R
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC



-- May 22 --



/* 627. Swap Salary [E]
Write a solution to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a
single update statement and no intermediate temporary tables.
Note that you must write a single update statement, do not write any select statement for this problem.
*/

Drop table if exists Salary;
Create table If Not Exists Salary (id int, name varchar(100), sex char(1), salary int);
Truncate table Salary;
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500');

SELECT *
FROM Salary;

UPDATE Salary
SET sex = CASE
    WHEN sex = 'm' THEN 'f'
    WHEN sex = 'f' THEN 'm'
END;


/* 2356. Number of Unique Subjects Taught by Each Teacher [E]
Write a solution to calculate the number of unique subjects each teacher teaches in the university.
Return the result table in any order.
*/

Drop table if exists Teacher;
Create table If Not Exists Teacher (teacher_id int, subject_id int, dept_id int);
Truncate table Teacher;
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '4');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '3', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '1', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '2', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '3', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '4', '1');

SELECT *
FROM Teacher;

SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;


/* 1341. Movie Rating [M]
Write a solution to:

* Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.

* Find the movie name with the highest average rating in February 2020. In case of a tie,
return the lexicographically smaller movie name.
*/

Drop table if exists Movies;
Drop table if exists Users;
Drop table if exists MovieRating;
Create table If Not Exists Movies (movie_id int, title varchar(30));
Create table If Not Exists Users (user_id int, name varchar(30));
Create table If Not Exists MovieRating (movie_id int, user_id int, rating int, created_at date);
Truncate table Movies;
insert into Movies (movie_id, title) values ('1', 'Avengers');
insert into Movies (movie_id, title) values ('2', 'Frozen 2');
insert into Movies (movie_id, title) values ('3', 'Joker');
Truncate table Users;
insert into Users (user_id, name) values ('1', 'Daniel');
insert into Users (user_id, name) values ('2', 'Monica');
insert into Users (user_id, name) values ('3', 'Maria');
insert into Users (user_id, name) values ('4', 'James');
Truncate table MovieRating;
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '1', '3', '2020-01-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '2', '4', '2020-02-11');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '3', '2', '2020-02-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '4', '1', '2020-01-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '1', '5', '2020-02-17');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '2', '2', '2020-02-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '3', '2', '2020-03-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '1', '3', '2020-02-22');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '2', '4', '2020-02-25');

SELECT *
FROM Movies;

SELECT *
FROM Users;

SELECT *
FROM MovieRating;

SELECT Q1.results AS results
FROM (
    SELECT U.name AS results
    FROM (
        SELECT user_id, COUNT(rating) AS cnt
        FROM MovieRating
        GROUP BY user_id
    ) AS T
    LEFT JOIN Users U
    ON T.user_id = U.user_id
    ORDER BY cnt DESC, name ASC
    LIMIT 1
) AS Q1
UNION ALL
SELECT Q2. results AS results
FROM (
    SELECT M.title AS results
    FROM (
        SELECT movie_id, AVG(rating) AS avg_rating
        FROM MovieRating
        WHERE SUBSTRING(created_at,1,7) = '2020-02'
        GROUP BY movie_id
    ) AS T2
    LEFT JOIN Movies M
    ON T2.movie_id = M.movie_id
    ORDER BY T2.avg_rating DESC, M.title ASC
    LIMIT 1
) AS Q2;


/* 1972. First and Last Call On the Same Day [H]
Write a solution to report the IDs of the users whose first and last calls on any day were with
the same person. Calls are counted regardless of being the caller or the recipient.
Return the result table in any order.
*/

Drop table if exists Calls;
Create table If Not Exists Calls (caller_id int, recipient_id int, call_time datetime);
Truncate table Calls;
insert into Calls (caller_id, recipient_id, call_time) values ('8', '4', '2021-08-24 17:46:07');
insert into Calls (caller_id, recipient_id, call_time) values ('4', '8', '2021-08-24 19:57:13');
insert into Calls (caller_id, recipient_id, call_time) values ('5', '1', '2021-08-11 05:28:44');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '3', '2021-08-17 04:04:15');
insert into Calls (caller_id, recipient_id, call_time) values ('11', '3', '2021-08-17 13:07:00');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '11', '2021-08-17 22:22:22');

SELECT *
FROM Calls;


WITH D AS (
    SELECT *, SUBSTRING(call_time,1,10) AS call_day -- all calls as caller_id
    FROM (
        SELECT *
        FROM Calls C1
        UNION ALL
        SELECT *
        FROM (
            SELECT C2.recipient_id AS caller_id, C2.caller_id AS recipient_id, call_time
            FROM Calls C2
        ) C2
    ) AS T
)
SELECT DISTINCT D1.caller_id AS user_id -- D1.caller_id, D1.call_day, D1.first_call, D1.last_call, D2.recipient_id AS first_recipient, D3.recipient_id AS last_recipient
FROM (
    SELECT D.caller_id, D.call_day, MIN(D.call_time) AS first_call, MAX(D.call_time) AS last_call
    FROM D
    GROUP BY D.caller_id, D.call_day
) D1
JOIN D D2
ON D1.caller_id = D2.caller_id AND D1.first_call = D2.call_time -- D2 for first calls
JOIN D D3
ON D1.caller_id = D3.caller_id AND D1.last_call = D3.call_time -- D3 for last calls
WHERE D2.recipient_id = D3.recipient_id

 -- (WOW, actually solved it, and beats 82.97%)


 