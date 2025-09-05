

-- 08/25: 1/5 

/* 2995. Viewers Turned Streamers [H]
Write a solution to find the number of streaming sessions for users whose first session was as a viewer.

Return the result table ordered by count of streaming sessions, user_id in descending order.
*/

Drop table if exists Sessions;
Create table If Not Exists Sessions (user_id int, session_start datetime, session_end datetime, session_id int, session_type ENUM('Viewer','Streamer'));
Truncate table Sessions;
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('101', '2023-11-06 13:53:42', '2023-11-06 14:05:42', '375', 'Viewer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('101', '2023-11-22 16:45:21', '2023-11-22 20:39:21', '594', 'Streamer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('102', '2023-11-16 13:23:09', '2023-11-16 16:10:09', '777', 'Streamer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('102', '2023-11-17 13:23:09', '2023-11-17 16:10:09', '778', 'Streamer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('101', '2023-11-20 07:16:06', '2023-11-20 08:33:06', '315', 'Streamer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('104', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '797', 'Viewer');
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values ('103', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '798', 'Streamer');


SELECT *
FROM Sessions;


WITH Validusers AS (
    WITH First AS (
        SELECT user_id, MIN(session_start) AS first_session -- Earliest Sessions
        FROM Sessions
        GROUP BY user_id
    )
    SELECT S.user_id
    FROM Sessions S
    JOIN First F
    ON S.user_id = F.user_id AND S.session_start = F.first_session
    WHERE S.session_type = 'Viewer'
)
SELECT S2.user_id, SUM(S2.session_type = 'Streamer') AS sessions_count
FROM Sessions S2
JOIN Validusers
ON S2.user_id = Validusers.user_id
GROUP BY S2.user_id
HAVING sessions_count != 0
ORDER BY sessions_count DESC, S2.user_id DESC;

-- Beats 95% whooo!

Drop table if exists Sessions;



-- 08/25: 1/5 

/* 585. Investments in 2016 [M]
Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

* have the same tiv_2015 value as one or more other policyholders, and

* are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).

Round tiv_2016 to two decimal places.
*/

Drop table if exists Insurance;
Create Table If Not Exists Insurance (pid int, tiv_2015 float, tiv_2016 float, lat float, lon float);
Truncate table Insurance;
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40');

SELECT *
FROM Insurance;


WITH shared AS (
    SELECT tiv_2015, COUNT(*) AS shared_tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING shared_tiv_2015 > 1
)

WITH uniquell AS (
    SELECT lat, lon, COUNT(*) AS shared_lat_lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING shared_lat_lon = 1
)
SELECT *
FROM uniquell;


SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance I
WHERE I.tiv_2015 IN (
    SELECT S1.tiv_2015
    FROM (
        SELECT tiv_2015, COUNT(*) AS shared_tiv_2015
        FROM Insurance
        GROUP BY tiv_2015
        HAVING shared_tiv_2015 > 1
    ) AS S1
)
AND (I.lat, I.lon) IN (
    SELECT S2.lat, S2.lon
    FROM (
        SELECT lat, lon, COUNT(*) AS shared_lat_lon
        FROM Insurance
        GROUP BY lat, lon
        HAVING shared_lat_lon = 1
    ) AS S2
);


-- Using JOIN is often faster for optimizer

Drop table if exists Insurance;


/* 1045. Customers Who Bought All Products [M]
Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.
*/

Drop table if exists Customer;
Drop table if exists Product;
Create table If Not Exists Customer (customer_id int, product_key int);
Create table Product (product_key int);
Truncate table Customer;
insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('1', '6');
Truncate table Product;
insert into Product (product_key) values ('5');
insert into Product (product_key) values ('6');

SELECT *
FROM Customer;

SELECT *
FROM Product;


WITH Invalid AS (
    SELECT DISTINCT C.customer_id AS invalid_id, P.product_key, C2.customer_id
    FROM Customer C
    CROSS JOIN (
        SELECT product_key
        FROM Product
    ) P
    LEFT JOIN Customer C2
    ON C.customer_id = C2.customer_id
    AND P.product_key = C2.product_key
    WHERE C2.customer_id IS NULL
)
SELECT DISTINCT C3.customer_id
FROM Customer C3
WHERE C3.customer_id NOT IN (
    SELECT I.invalid_id
    FROM Invalid I
);

Drop table if exists Customer;
Drop table if exists Product;


/* 601. Human Traffic of Stadium [H]
Write a solution to display the records with three or more rows with consecutive id's,
and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.
*/

Drop table if exists Stadium;
Create table If Not Exists Stadium (id int, visit_date DATE NULL, people int);
Truncate table Stadium;
insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');

SELECT *
FROM Stadium;


WITH gt100 AS (
    SELECT *
    FROM Stadium S
    WHERE S.people >= 100
    ORDER BY S.id ASC
),
numbered AS (
    SELECT *, id - ROW_NUMBER() OVER (ORDER BY id) AS group_key
    FROM gt100
),
grouped AS (
    SELECT group_key, COUNT(*) AS consec_count
    FROM numbered
    GROUP BY group_key
    HAVING consec_count >= 3
)
SELECT id, visit_date, people
FROM numbered
JOIN grouped
USING(group_key)
ORDER BY visit_date ASC;


Drop table if exists Stadium;



/* 608. Tree Node[M]
Each node in the tree can be one of three types:

* "Leaf": if the node is a leaf node.

* "Root": if the node is the root of the tree.

* "Inner": If the node is neither a leaf node nor a root node.

Write a solution to report the type of each node in the tree.

Return the result table in any order.
*/

Drop table if exists Tree;
Create table If Not Exists Tree (id int, p_id int);
Truncate table Tree;
insert into Tree (id, p_id) values ('1', NULL);
insert into Tree (id, p_id) values ('2', '1');
insert into Tree (id, p_id) values ('3', '1');
insert into Tree (id, p_id) values ('4', '2');
insert into Tree (id, p_id) values ('5', '2');

SELECT *
FROM Tree;


WITH RootNodes AS (
    SELECT id, 'Root' AS type
    FROM Tree
    WHERE p_id IS NULL
),
LeafNodes AS (
    SELECT id, 'Leaf' AS type
    FROM Tree
    WHERE id NOT IN (
        SELECT p_id
        FROM Tree
        WHERE p_id IS NOT NULL
    )
    AND id NOT IN (
        SELECT id
        FROM RootNodes
    )
),
InnerNodes AS (
    SELECT id, 'Inner' AS type
    FROM Tree
    WHERE id IN (
        SELECT p_id
        FROM Tree
        WHERE p_id IS NOT NULL
    )
    AND id NOT IN (
        SELECT id
        FROM RootNodes
    )
)
SELECT *
FROM RootNodes
UNION ALL
SELECT *
FROM InnerNodes
UNION ALL
SELECT *
FROM LeafNodes;


Drop table if exists Tree;


/* 1327. List the Products Ordered in a Period [E]
Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

Return the result table in any order.
*/

Drop table if exists Products;
Drop table if exists Orders;
Create table If Not Exists Products (product_id int, product_name varchar(40), product_category varchar(40));
Create table If Not Exists Orders (product_id int, order_date date, unit int);
Truncate table Products;
insert into Products (product_id, product_name, product_category) values ('1', 'Leetcode Solutions', 'Book');
insert into Products (product_id, product_name, product_category) values ('2', 'Jewels of Stringology', 'Book');
insert into Products (product_id, product_name, product_category) values ('3', 'HP', 'Laptop');
insert into Products (product_id, product_name, product_category) values ('4', 'Lenovo', 'Laptop');
insert into Products (product_id, product_name, product_category) values ('5', 'Leetcode Kit', 'T-shirt');
Truncate table Orders;
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-05', '60');
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-10', '70');
insert into Orders (product_id, order_date, unit) values ('2', '2020-01-18', '30');
insert into Orders (product_id, order_date, unit) values ('2', '2020-02-11', '80');
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-17', '2');
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-24', '3');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-01', '20');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '30');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '60');
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-25', '50');
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-27', '50');
insert into Orders (product_id, order_date, unit) values ('5', '2020-03-01', '50');


SELECT *
FROM Products;

SELECT *
FROM Orders;


WITH T1 AS (
    SELECT product_id, SUM(unit) AS totals
    FROM Orders
    WHERE order_date >= '2020-02-01'
        AND order_date < '2020-03-01'
    GROUP BY product_id
    HAVING totals >= 100
)
SELECT product_name, totals as unit
FROM Products P
JOIN T1 USING(product_id);

Drop table if exists Products;
Drop table if exists Orders;



/* 1205. Monthly Transactions II [M]
Write a solution to find for each month and country:
the number of approved transactions and their total amount,
the number of chargebacks, and their total amount.

Note: In your solution, given the month and country, ignore rows with all zeros.

Return the result table in any order.
*/

Drop table if exists Transactions;
Drop table if exists Chargebacks;
Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);
Create table If Not Exists Chargebacks (trans_id int, trans_date date);
Truncate table Transactions;
insert into Transactions (id, country, state, amount, trans_date) values ('101', 'US', 'approved', '1000', '2019-05-18');
insert into Transactions (id, country, state, amount, trans_date) values ('102', 'US', 'declined', '2000', '2019-05-19');
insert into Transactions (id, country, state, amount, trans_date) values ('103', 'US', 'approved', '3000', '2019-06-10');
insert into Transactions (id, country, state, amount, trans_date) values ('104', 'US', 'declined', '4000', '2019-06-13');
insert into Transactions (id, country, state, amount, trans_date) values ('105', 'US', 'approved', '5000', '2019-06-15');
Truncate table Chargebacks;
insert into Chargebacks (trans_id, trans_date) values ('102', '2019-05-29');
insert into Chargebacks (trans_id, trans_date) values ('101', '2019-06-30');
insert into Chargebacks (trans_id, trans_date) values ('105', '2019-09-18');

SELECT *
FROM Transactions;

SELECT *
FROM Chargebacks;

WITH Chg AS (
    SELECT *
    FROM Chargebacks C
    LEFT JOIN (
        SELECT id AS trans_id, country, amount AS chargeback_amount
        FROM Transactions
    ) T
    USING (trans_id)
),
App AS (
    SELECT DATE_FORMAT(trans_date, '%Y-%m') AS trans_month, country, 1 AS approved_count, amount AS approved_amount, 0 AS chargeback_count, 0 AS chargeback_amount
    FROM Transactions 
    WHERE state = 'approved'
),
AllData AS (
    SELECT DATE_FORMAT(trans_date, '%Y-%m') AS trans_month, country, 0 AS approved_count, 0 as approved_amount, 1 AS chargeback_count, chargeback_amount
    FROM Chg
    UNION ALL
    SELECT *
    FROM App
)
SELECT trans_month AS month, country,
    SUM(approved_count) AS approved_count,
    SUM(approved_amount) AS approved_amount,
    SUM(chargeback_count) AS chargeback_count,
    SUM(chargeback_amount) AS chargeback_amount
FROM AllData
GROUP BY trans_month, country;

Drop table if exists Transactions;
Drop table if exists Chargebacks;



/* 597. Friend Requests I: Overall Acceptance Rate [E]
Find the overall acceptance rate of requests, which is the number of acceptance divided by the number of requests.
Return the answer rounded to 2 decimals places.

Note that:

* The accepted requests are not necessarily from the table friend_request. In this case, Count the total accepted requests
(no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.

* It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once.
In this case, the ‘duplicated’ requests or acceptances are only counted once.

* If there are no requests at all, you should return 0.00 as the accept_rate.
*/

Drop table if exists FriendRequest;
Drop table if exists RequestAccepted;
Create table If Not Exists FriendRequest (sender_id int, send_to_id int, request_date date);
Create table If Not Exists RequestAccepted (requester_id int, accepter_id int, accept_date date);
Truncate table FriendRequest;
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '2', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '3', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '4', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('2', '3', '2016/06/02');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('3', '4', '2016/06/09');
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/10');

SELECT *
FROM FriendRequest;

SELECT *
FROM RequestAccepted;

SELECT IFNULL(ROUND(
(
    SELECT COUNT(*) AS ac_count
    FROM (
        SELECT requester_id, accepter_id
        FROM RequestAccepted
        GROUP BY requester_id, accepter_id
    ) AS RA
) / (
    SELECT COUNT(*) AS rq_count
    FROM (
        SELECT sender_id, send_to_id
        FROM FriendRequest
        GROUP BY sender_id, send_to_id
    ) AS FR
)
,2),0) AS accept_rate;


Drop table if exists FriendRequest;
Drop table if exists RequestAccepted;



/* 1107. New Users Daily Count [M]
Write a solution to report for every date within at most 90 days from today,
the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

Return the result table in any order.
*/

Drop table if exists Traffic;
Create table If Not Exists Traffic (user_id int, activity ENUM('login', 'logout', 'jobs', 'groups', 'homepage'), activity_date date);
Truncate table Traffic;
insert into Traffic (user_id, activity, activity_date) values ('1', 'login', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('1', 'homepage', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('1', 'logout', '2019-05-01');
insert into Traffic (user_id, activity, activity_date) values ('2', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('2', 'logout', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('3', 'login', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('3', 'jobs', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('3', 'logout', '2019-01-01');
insert into Traffic (user_id, activity, activity_date) values ('4', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('4', 'groups', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('4', 'logout', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('5', 'login', '2019-03-01');
insert into Traffic (user_id, activity, activity_date) values ('5', 'logout', '2019-03-01');
insert into Traffic (user_id, activity, activity_date) values ('5', 'login', '2019-06-21');
insert into Traffic (user_id, activity, activity_date) values ('5', 'logout', '2019-06-21');

SELECT *
FROM Traffic;

WITH FirstLogins AS (
    SELECT user_id, MIN(activity_date) AS login_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
)
SELECT login_date, COUNT(user_id) AS user_count
FROM FirstLogins
WHERE login_date >= DATE_SUB('2019-06-30', INTERVAL 90 DAY)
    AND login_date <= DATE_ADD('2019-06-30', INTERVAL 90 DAY)
GROUP BY login_date;


Drop table if exists Traffic;



/* 1225. Report Contiguous Dates [H]
A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write a solution to report the period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded.
Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.
*/

Drop table if exists Failed;
Drop table if exists Succeeded;
Create table If Not Exists Failed (fail_date date);
Create table If Not Exists Succeeded (success_date date);
Truncate table Failed;
insert into Failed (fail_date) values ('2018-12-28');
insert into Failed (fail_date) values ('2018-12-29');
insert into Failed (fail_date) values ('2019-01-04');
insert into Failed (fail_date) values ('2019-01-05');
Truncate table Succeeded;
insert into Succeeded (success_date) values ('2018-12-30');
insert into Succeeded (success_date) values ('2018-12-31');
insert into Succeeded (success_date) values ('2019-01-01');
insert into Succeeded (success_date) values ('2019-01-02');
insert into Succeeded (success_date) values ('2019-01-03');
insert into Succeeded (success_date) values ('2019-01-06');

SELECT *
FROM Failed;

SELECT *
FROM Succeeded;

WITH IntFailed AS (
    SELECT fail_date AS date, 0 AS state, TO_DAYS(fail_date) - ROW_NUMBER() OVER(ORDER BY fail_date) AS diff
    FROM Failed
    WHERE fail_date >= '2019-01-01' AND fail_date <= '2019-12-31'
    ORDER BY fail_date ASC
),
IntSucceeded AS (
    SELECT success_date AS date, 0 AS state, TO_DAYS(success_date) - ROW_NUMBER() OVER(ORDER BY success_date) AS diff
    FROM Succeeded
    WHERE success_date >= '2019-01-01' AND success_date <= '2019-12-31'
    ORDER BY success_date ASC
)
SELECT 'failed' AS period_state, MIN(date) AS start_date, MAX(date) AS end_date
FROM IntFailed
GROUP BY diff
UNION ALL
SELECT 'succeeded' AS period_state, MIN(date) AS start_date, MAX(date) AS end_date
FROM IntSucceeded
GROUP BY diff
ORDER BY start_date;

/*
Using PARTITION BY instead
*/

WITH Combined AS (
  SELECT fail_date AS date, 'failed' AS state
  FROM Failed
  WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
  
  UNION ALL
  
  SELECT success_date AS date, 'succeeded' AS state
  FROM Succeeded
  WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
),
Numbered AS (
  SELECT *,
         TO_DAYS(date) - ROW_NUMBER() OVER (PARTITION BY state ORDER BY date) AS diff
  FROM Combined
)
SELECT state AS period_state, MIN(date) AS start_date, MAX(date) AS end_date
FROM Numbered
GROUP BY state, diff
ORDER BY start_date;


Drop table if exists Failed;
Drop table if exists Succeeded;


/* 1050. Actors and Directors Who Cooperated At Least Three Times [E]
Write a solution to find all the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.

Return the result table in any order.
*/

Drop table if exists ActorDirector;
Create table If Not Exists ActorDirector (actor_id int, director_id int, timestamp int);
Truncate table ActorDirector;
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0');
insert into ActorDirector (actor_id, dirsector_id, timestamp) values ('1', '1', '1');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6');

SELECT *
FROM ActorDirector;

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;

Drop table if exists ActorDirector;



/* 3374. First Letter Capitalization II [H]
Write a solution to transform the text in the content_text column by applying the following rules:

* Convert the first letter of each word to uppercase and the remaining letters to lowercase

* Special handling for words containing special characters:
  * For words connected with a hyphen -, both parts should be capitalized (e.g., top-rated → Top-Rated)

* All other formatting and spacing should remain unchanged

Return the result table that includes both the original content_text and the modified text following the above rules.
*/

Drop table if exists user_content;
CREATE TABLE If not exists user_content (
    content_id INT,
    content_text VARCHAR(255)
);
Truncate table user_content;
insert into user_content (content_id, content_text) values ('1', 'hello world of SQL');
insert into user_content (content_id, content_text) values ('2', 'the QUICK-brown fox');
insert into user_content (content_id, content_text) values ('3', 'modern-day DATA science');
insert into user_content (content_id, content_text) values ('4', 'web-based FRONT-end development');

SELECT *
FROM user_content;

-- With help from ChatGPT
WITH RECURSIVE
-- 1) Make hyphens their own tokens
prep AS (
  SELECT
    content_id,
    content_text,
    REPLACE(content_text, '-', ' - ') AS new_text
  FROM user_content
),

-- 2) Count tokens = spaces + 1 (handles empty / single-word too)
tok_count AS (
  SELECT
    content_id,
    content_text,
    new_text,
    1 + CHAR_LENGTH(new_text) - CHAR_LENGTH(REPLACE(new_text, ' ', '')) AS token_count
  FROM prep
),

-- 3) Build 1..token_count per row
seq AS (
  SELECT content_id, content_text, new_text, 1 AS n, token_count
  FROM tok_count
  UNION ALL
  SELECT content_id, content_text, new_text, n + 1, token_count
  FROM seq
  WHERE n < token_count
),

-- 4) Extract the n-th token, in order
tokens AS (
  SELECT
    content_id,
    content_text,
    n AS ordinal,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(new_text, ' ', n), ' ', -1)) AS token
  FROM seq
),

-- 5) Title-case each token (keep '-' as a literal hyphen)
converted AS (
  SELECT
    content_id,
    content_text,
    ordinal,
    CASE
      WHEN token = '-' THEN '-'
      WHEN token = ''  THEN ''
      ELSE CONCAT(UPPER(LEFT(token, 1)), LOWER(SUBSTRING(token, 2)))
    END AS converted
  FROM tokens
)

-- 6) Reassemble and clean spaces around hyphens
SELECT
  content_id,
  content_text AS original_text,
  REPLACE(
    GROUP_CONCAT(converted ORDER BY ordinal SEPARATOR ' '),
    ' - ', '-'
  ) AS converted_text
FROM converted
GROUP BY content_id, original_text
ORDER BY content_id;


Drop table if exists user_content;



/* 1729. Find Followers Count [E]
Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.
*/

Drop table if exists Followers;
Create table If Not Exists Followers(user_id int, follower_id int);
Truncate table Followers;
insert into Followers (user_id, follower_id) values ('0', '1');
insert into Followers (user_id, follower_id) values ('1', '0');
insert into Followers (user_id, follower_id) values ('2', '0');
insert into Followers (user_id, follower_id) values ('2', '1');

SELECT user_id, COUNT(*) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;


Drop table if exists Followers;


