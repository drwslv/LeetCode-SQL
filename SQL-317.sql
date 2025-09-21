

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


/* 177. Nth Highest Salary [M]
Write a solution to find the nth highest distinct salary from the Employee table. If there are less than n distinct salaries, return null.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (Id int, Salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC
BEGIN
DECLARE M INT; 
    SET M = N-1;
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT M, 1 -- LIMIT 1, OFFSET M
  );
END

SELECT getNthHighestSalary(2);


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

WITH CTE AS (
    SELECT *, LAG(num, 1) OVER(ORDER BY id) - num AS l1, LAG(num, 2) OVER(ORDER BY id) - num AS l2
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM CTE
WHERE l1 = 0 AND l2 = 0;


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

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC;


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

WITH CTE AS (
    SELECT *, DATE_FORMAT(trans_date, '%Y-%m') AS month
    FROM Transactions
)
SELECT month, country, COUNT(*) as trans_count, SUM(IF(state='approved',1,0) ) AS approved_count, SUM(amount) AS trans_total_amount, SUM(IF(state='approved', amount, 0)) AS approved_total_amount
FROM CTE
GROUP BY month, country


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
WHERE area >= 3000000
    OR population >= 25000000;


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

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;


/* 584. Find Customer Referee [E]
Find the names of the customer that are either:
-referred by any customer with id != 2.
-not referred by any customer.
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

SELECT name
FROM Customer
WHERE referee_id != 2
    OR referee_id IS NULL;


/* 1661. Average Time of Process per Machine [E]
There is a factory website that has several machines each running the same number of processes.
Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp.
The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.
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

SELECT A1.machine_id, ROUND(AVG(A2.timestamp - A1.timestamp),3) AS processing_time
FROM Activity A1
JOIN Activity A2
    ON A1.machine_id = A2.machine_id
    AND A1.process_id = A2.process_id
WHERE A1.activity_type = 'start'
    AND A2.activity_type = 'end'
GROUP BY A1.machine_id;


/* 626. Exchange Seats [M]
Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
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

WITH CTE AS(
    SELECT id AS id_old, student, id%2 AS odd, LEAD(id) OVER(ORDER BY id) AS id_if_odd, LAG(id) OVER(ORDER BY id) AS id_if_even
    FROM Seat
)
SELECT 
    CASE
        WHEN odd = 1 THEN IFNULL(id_if_odd,id_old)
        WHEN odd = 0 THEN id_if_even
    END AS id,
    student
FROM CTE
ORDER BY id ASC;


/* 1581. Customer Who Visited but Did Not Make Any Transactions [E]
Write a solution to find the IDs of the users who visited without making any
transactions and the number of times they made these types of visits.
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

SELECT customer_id, COUNT(*) AS count_no_trans
FROM (
    SELECT *
    FROM Visits
    WHERE visit_id NOT IN (
        SELECT DISTINCT visit_id
        FROM Transactions
    )
) T1
GROUP BY customer_id;


/* 196. Delete Duplicate Emails [E]
Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
For Pandas users, please note that you are supposed to modify Person in place.
After running your script, the answer shown is the Person table. The driver will first
compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.
*/

Drop table if exists Person;
Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');

SELECT *
FROM Person;

DELETE P1
FROM Person P1
JOIN Person P2
    ON P1.Email = P2.Email
    AND P1.Id > P2.Id;


/* 178. Rank Scores [M]
Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:
-The scores should be ranked from the highest to the lowest.
-If there is a tie between two scores, both should have the same ranking.
-After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
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

SELECT score, DENSE_RANK() OVER(ORDER BY score DESC) AS 'rank'
FROM Scores;


/* 1934. Confirmation Rate [M]
The confirmation rate of a user is the number of 'confirmed' messages divided by the
total number of requested confirmation messages. The confirmation rate of a user that
did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
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

SELECT S.user_id, IFNULL(T.confirmation_rate, 0) as confirmation_rate
FROM Signups S
LEFT JOIN (
    SELECT user_id, ROUND( SUM(IF(action='confirmed',1,0)) / COUNT(*), 2) AS confirmation_rate
    FROM Confirmations
    GROUP BY user_id
) T
USING(user_id);


/* 1789. Primary Department for Each Employee [E]
Employees can belong to multiple departments. When the employee joins other departments,
they need to decide which department is their primary department. Note that when an employee
belongs to only one department, their primary column is 'N'.
Write a solution to report all the employees with their primary department.
For employees who belong to one department, report their only department.
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

SELECT E1.employee_id, E1.department_id
FROM Employee E1
LEFT JOIN (
    SELECT employee_id, COUNT(*) as num_dept
    FROM Employee
    GROUP BY employee_id
) E2
    USING(employee_id)
WHERE E1.primary_flag = 'Y'
    OR E2.num_dept = 1;


/* 184. Department Highest Salary [M]
Write a solution to find employees who have the highest salary in each of the departments.
Return the result table in any order.
*/

Drop table if exists Employee;
Drop table if exists Department;
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

WITH High AS (
    SELECT departmentId, MAX(salary) as max_sal
    FROM Employee
    GROUP BY departmentId
)
SELECT DISTINCT D.name AS Department, E.name AS Employee, E.salary AS Salary
FROM Employee E
LEFT JOIN Department D
    ON E.departmentId = D.id
JOIN High H
    ON E.salary = H.max_sal
    AND E.departmentId = H.departmentId;


/* 1164. Product Price at a Given Date [M]
Initially, all products have price 10.
Write a solution to find the prices of all products on the date 2019-08-16.
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

WITH CTE1 AS (
    SELECT *
    FROM Products
    WHERE change_date <= '2019-08-16'
), CTE2 AS (
    SELECT product_id, MAX(change_date) AS change_date
    FROM CTE1
    GROUP BY product_id
), CTE3 AS (
    SELECT *
    FROM CTE2
    JOIN Products
    USING(product_id, change_date)
)
SELECT product_id, IFNULL(new_price,10) AS price
FROM CTE3
RIGHT JOIN (
    SELECT DISTINCT product_id
    FROM Products
) J
USING(product_id);


/* 550. Game Play Analysis IV [M]
Write a solution to report the fraction of players that logged in again on the day after the day they first logged in,
rounded to 2 decimal places. In other words, you need to determine the number of players who logged in on the day
immediately following their initial login, and divide it by the number of total players.
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

WITH FL AS (
    SELECT player_id, MIN(event_date) AS event_date
    FROM  Activity
    GROUP BY player_id
),
NL AS (
    SELECT player_id, DATE_ADD(event_date, INTERVAL 1 DAY) AS next_date, 1 AS present
    FROM FL
),
GRP AS (
    SELECT A.player_id, IFNULL(MAX(present),0) AS present
    FROM Activity A
    LEFT JOIN NL
        ON A.player_id = NL.player_id
        AND A.event_date = NL.next_date
    GROUP BY A.player_id
)
SELECT ROUND(AVG(present),2) AS fraction
FROM GRP;


/* 610. Triangle Judgement [E]
Report for every three line segments whether they can form a triangle.
Return the result table in any order.
*/

Drop table if exists Triangle;
Create table If Not Exists Triangle (x int, y int, z int);
Truncate table Triangle;
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

-- max < sum - max, 2 max < sum, 0 < sum - 2 max
SELECT *, IF(x + y + z - 2 * GREATEST(x, y, z) > 0, 'Yes', 'No') AS triangle
FROM Triangle;


/*  185. Department Top Three Salaries [H]
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

SELECT *
FROM Employee;

SELECT *
FROM Department;

WITH CTE AS (
    SELECT DISTINCT departmentId, salary,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS salary_rank
    FROM Employee
),
    CTE2 AS (
    SELECT *
    FROM CTE
    WHERE salary_rank <= 3
)
SELECT D.name AS Department, E.name AS Employee, E.salary as Salary
FROM Employee E
JOIN CTE2 C USING(departmentId, salary)
LEFT JOIN Department D
    ON E.departmentId = D.id;


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

WITH Grp AS (
    SELECT student_id, subject_name, COUNT(*) as attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
),
StEx AS (
    SELECT *
    FROM Students, Subjects
)
SELECT S.student_id, S.student_name, S.subject_name, IFNULL(G.attended_exams,0) AS attended_exams
FROM StEx S
LEFT JOIN Grp G USING(student_id, subject_name, student_id)
ORDER BY student_id, subject_name;

