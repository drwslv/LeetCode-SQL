

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

SELECT *
FROM Person;

SELECT *
FROM Address;

SELECT firstName, lastName, city, state
FROM Person
LEFT JOIN Address
    USING(personId);


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

SELECT *
FROM Employee;

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;


/* 1757. Recyclable and Low Fat Products [E]
Write a solution to find the ids of products that are both low fat and recyclable.
Return the result table in any order.
*/

Drop table if exists Products;
Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'));
Truncate table Products;
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');

SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';


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

SELECT *
FROM Employee;

SELECT E.name as Employee
FROM Employee E
JOIN Employee M
ON E.managerId = M.id
WHERE E.salary > M.salary;


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

SELECT *
FROM Employee;

-- Incorrect
SELECT E.name
FROM Employee E
JOIN
(
    SELECT managerId, COUNT(*) AS managerCnt
    FROM Employee
    GROUP BY managerId
    HAVING managerId IS NOT NULL
        AND COUNT(*) > 5
) AS M
ON E.id = M.managerId

-- Correct
WITH Grp AS (
    SELECT managerId, COUNT(*) AS managerCnt
    FROM Employee
    GROUP BY managerId
),
Grp2 AS (
    SELECT *
    FROM Grp
    WHERE managerId IS NOT NULL
        AND managerCnt >= 5
)
SELECT E.name
FROM Grp2
JOIN Employee E
    ON Grp2.managerId = E.id;


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

WITH WT AS (
    SELECT *, DATE_SUB(recordDate, INTERVAL 1 DAY) AS yesterdayDate
    FROM Weather
)
SELECT WT.id AS id
FROM WT
LEFT JOIN Weather WY
    ON WT.yesterdayDate = WY.recordDate
WHERE WT.temperature > WY.temperature;


