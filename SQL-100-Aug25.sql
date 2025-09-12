

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



/* 1795. Rearrange Products Table [E]
Write a solution to rearrange the Products table so that each row has (product_id, store, price).
If a product is not available in a store, do not include a row with that product_id and store combination in the result table.

Return the result table in any order.
*/

Drop table if exists Products;
Create table If Not Exists Products (product_id int, store1 int, store2 int, store3 int);
Truncate table Products;
insert into Products (product_id, store1, store2, store3) values ('0', '95', '100', '105');
insert into Products (product_id, store1, store2, store3) values ('1', '70', NULL, '80');

SELECT *
FROM Products;

WITH Products_long AS (
    SELECT product_id, 'store1' AS store, store1 AS price
    FROM Products
    UNION ALL
    SELECT product_id, 'store2' AS store, store2 AS price
    FROM Products
    UNION ALL
    SELECT product_id, 'store3' AS store, store3 AS price
    FROM Products
)
SELECT *
FROM Products_long
WHERE price IS NOT NULL;

Drop table if exists Products;


/* 619. Biggest Single Number [E]
A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.
*/

Drop table if exists MyNumbers;
Create table If Not Exists MyNumbers (num int);
Truncate table MyNumbers;
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

SELECT (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
    ORDER BY num DESC
    LIMIT 1
) AS num;

Drop table if exists MyNumbers;

/* 1393. Capital Gain/Loss [M]
Write a solution to report the Capital gain/loss for each stock.

The Capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times.

Return the result table in any order.
*/

Drop table if exists Stocks;
Create Table If Not Exists Stocks (stock_name varchar(15), operation ENUM('Sell', 'Buy'), operation_day int, price int);
Truncate table Stocks;
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Buy', '1', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '2', '10');
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Sell', '5', '9000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Buy', '17', '30000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '3', '1010');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '4', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '5', '500');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '6', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Sell', '29', '7000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '10', '10000');

SELECT *
FROM Stocks;

WITH CTE AS (
    SELECT stock_name,
        operation,
        CASE operation
            WHEN 'Buy' THEN -price
            WHEN 'Sell' THEN price
        END AS price2
    FROM Stocks
)
SELECT stock_name, SUM(price2) AS capital_gain_loss
FROM CTE
GROUP BY stock_name;

Drop table if exists Stocks;


/* 607. Sales Person [E]
Write a solution to find the names of all the salespersons who did not have any orders related to the company with the name "RED".

Return the result table in any order.
*/

Drop table if exists SalesPerson;
Drop table if exists Company;
Drop table if exists Orders;
Create table If Not Exists SalesPerson (sales_id int, name varchar(255), salary int, commission_rate int, hire_date date);
Create table If Not Exists Company (com_id int, name varchar(255), city varchar(255));
Create table If Not Exists Orders (order_id int, order_date date, com_id int, sales_id int, amount int);
Truncate table SalesPerson;
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('1', 'John', '100000', '6', '2006-4-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('2', 'Amy', '12000', '5', '2010-5-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('3', 'Mark', '65000', '12', '2008-12-25');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('4', 'Pam', '25000', '25', '2005-1-1');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('5', 'Alex', '5000', '10', '2007-2-3');
Truncate table Company;
insert into Company (com_id, name, city) values ('1', 'RED', 'Boston');
insert into Company (com_id, name, city) values ('2', 'ORANGE', 'New York');
insert into Company (com_id, name, city) values ('3', 'YELLOW', 'Boston');
insert into Company (com_id, name, city) values ('4', 'GREEN', 'Austin');
Truncate table Orders;
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('1', '2014-1-1', '3', '4', '10000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('2', '2014-2-1', '4', '5', '5000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('3', '2014-3-1', '1', '1', '50000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('4', '2014-3-1', '1', '4', '25000');

SELECT *
FROM SalesPerson;

SELECT *
FROM Company;

SELECT *
FROM Orders;

SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
    SELECT sales_id
    FROM Orders O
    JOIN Company C
        USING(com_id)
    WHERE C.name = 'RED'
);

Drop table if exists SalesPerson;
Drop table if exists Company;
Drop table if exists Orders;


/* 569. Median Employee Salary [H]
Write a solution to find the rows that contain the median salary of each company. While calculating the median,
when you sort the salaries of the company, break the ties by id.

Return the result table in any order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, company varchar(255), salary int);
Truncate table Employee;
insert into Employee (id, company, salary) values ('1', 'A', '2341');
insert into Employee (id, company, salary) values ('2', 'A', '341');
insert into Employee (id, company, salary) values ('3', 'A', '15');
insert into Employee (id, company, salary) values ('4', 'A', '15314');
insert into Employee (id, company, salary) values ('5', 'A', '451');
insert into Employee (id, company, salary) values ('6', 'A', '513');
insert into Employee (id, company, salary) values ('7', 'B', '15');
insert into Employee (id, company, salary) values ('8', 'B', '13');
insert into Employee (id, company, salary) values ('9', 'B', '1154');
insert into Employee (id, company, salary) values ('10', 'B', '1345');
insert into Employee (id, company, salary) values ('11', 'B', '1221');
insert into Employee (id, company, salary) values ('12', 'B', '234');
insert into Employee (id, company, salary) values ('13', 'C', '2345');
insert into Employee (id, company, salary) values ('14', 'C', '2645');
insert into Employee (id, company, salary) values ('15', 'C', '2645');
insert into Employee (id, company, salary) values ('16', 'C', '2652');
insert into Employee (id, company, salary) values ('17', 'C', '65');

SELECT *
FROM Employee;

WITH Ordered AS (
    SELECT id,
        company,
        salary,
        ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id) AS ordinal,
        COUNT(*) OVER(PARTITION BY company) cnt
    FROM Employee
)
SELECT id, company, salary
FROM Ordered
WHERE ordinal IN (FLOOR((cnt + 1) / 2), FLOOR((cnt + 2) / 2));

Drop table if exists Employee;


/* 1890. The Latest Login in 2020 [E]
Write a solution to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.

Return the result table in any order.
*/

Drop table if exists Logins;
Create table If Not Exists Logins (user_id int, time_stamp datetime);
Truncate table Logins;
insert into Logins (user_id, time_stamp) values ('6', '2020-06-30 15:06:07');
insert into Logins (user_id, time_stamp) values ('6', '2021-04-21 14:06:06');
insert into Logins (user_id, time_stamp) values ('6', '2019-03-07 00:18:15');
insert into Logins (user_id, time_stamp) values ('8', '2020-02-01 05:10:53');
insert into Logins (user_id, time_stamp) values ('8', '2020-12-30 00:46:50');
insert into Logins (user_id, time_stamp) values ('2', '2020-01-16 02:49:50');
insert into Logins (user_id, time_stamp) values ('2', '2019-08-25 07:59:08');
insert into Logins (user_id, time_stamp) values ('14', '2019-07-14 09:00:00');
insert into Logins (user_id, time_stamp) values ('14', '2021-01-06 11:59:59');

SELECT *
FROM Logins;

SELECT user_id, MAX(time_stamp) AS last_stamp
FROM Logins
WHERE YEAR(time_stamp) = '2020'
GROUP BY user_id;

Drop table if exists Logins;


/* 603. Consecutive Available Seats [E]
Find all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.
*/

Drop table if exists Cinema;
Create table If Not Exists Cinema (seat_id int primary key auto_increment, free bool);
Truncate table Cinema;
insert into Cinema (seat_id, free) values ('1', '1');
insert into Cinema (seat_id, free) values ('2', '0');
insert into Cinema (seat_id, free) values ('3', '1');
insert into Cinema (seat_id, free) values ('4', '1');
insert into Cinema (seat_id, free) values ('5', '1');

SELECT *
FROM Cinema;

WITH Free AS (
    SELECT *
    FROM Cinema
    WHERE free = 1
),
Labeled AS (
    SELECT *, seat_id - ROW_NUMBER() OVER(ORDER BY seat_id) AS grp_id
    FROM Free
),
Grouped AS (
    SELECT grp_id
    FROM Labeled
    GROUP BY grp_id
    HAVING COUNT(*)  > 1
)
SELECT seat_id
FROM Labeled
JOIN Grouped USING(grp_id);


Drop table if exists Cinema;


/* 571. Find Median Given Frequency of Numbers [H]
The median is the value separating the higher half from the lower half of a data sample.

Write a solution to report the median of all the numbers in the database after decompressing the Numbers table.
Round the median to one decimal point.
*/

Drop table if exists Numbers;
Create table If Not Exists Numbers (num int, frequency int);
Truncate table Numbers;
insert into Numbers (num, frequency) values ('0', '7');
insert into Numbers (num, frequency) values ('1', '1');
insert into Numbers (num, frequency) values ('2', '3');
insert into Numbers (num, frequency) values ('3', '1');

Drop table if exists Numbers;
Create table If Not Exists Numbers (num int, frequency int);
Truncate table Numbers;
insert into Numbers (num, frequency) values ('1', '3');
insert into Numbers (num, frequency) values ('2', '3');

SELECT *
FROM Numbers;

WITH CTE AS (
    SELECT *,
        SUM(frequency) OVER(ORDER BY num) AS upper_bound,
        (
            SELECT FLOOR((SUM(frequency)+1)/2)
            FROM Numbers
        ) AS med1,
        (
            SELECT FLOOR((SUM(frequency)+2)/2)
            FROM Numbers
        ) AS med2
    FROM Numbers
),
    CTE2 AS (
    SELECT *,
        IFNULL(LAG(upper_bound) OVER(ORDER BY num) + 1, 1) AS lower_bound
    FROM CTE
)
SELECT ROUND(AVG(num),1) AS median
FROM CTE2
WHERE (med1 >= lower_bound AND med1 <= upper_bound)
    OR (med2 >= lower_bound AND med2 <= upper_bound);

Drop table if exists Numbers;


/* 534. Game Play Analysis III [M]
Write a solution to report for each player and date, how many games played so far by the player.
That is, the total number of games played by the player until that date. Check the example for clarity.

Return the result table in any order.
*/

Drop table if exists Activity;
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

SELECT *
FROM Activity;

SELECT player_id, event_date,
    SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date) AS games_played_so_far
FROM Activity;

Drop table if exists Activity;


/* 3220. Odd and Even Transactions [M]
Write a solution to find the sum of amounts for odd and even transactions for each day.
If there are no odd or even transactions for a specific date, display as 0.

Return the result table ordered by transaction_date in ascending order.
*/

Drop table if exists transactions;
Create table if not exists transactions ( transaction_id int, amount int, transaction_date date);
Truncate table transactions;
insert into transactions (transaction_id, amount, transaction_date) values ('1', '150', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('2', '200', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('3', '75', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('4', '300', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('5', '50', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('6', '120', '2024-07-03');

SELECT *
FROM transactions;

WITH CTE AS (
    SELECT *, amount%2 as odd
    FROM transactions
),
Evens AS (
    SELECT transaction_date, SUM(amount) AS even_sum
    FROM CTE
    WHERE odd = 0
    GROUP BY transaction_date
),
Odds AS (
    SELECT transaction_date, SUM(amount) AS odd_sum
    FROM CTE
    WHERE odd = 1
    GROUP BY transaction_date)
SELECT transaction_date, IFNULL(odd_sum,0) AS odd_sum, IFNULL(even_sum,0) AS even_sum
FROM Evens
LEFT JOIN Odds USING(transaction_date)
UNION
SELECT transaction_date, IFNULL(odd_sum,0) AS odd_sum, IFNULL(even_sum,0) AS even_sum
FROM Odds
LEFT JOIN Evens USING(transaction_date)
ORDER BY transaction_date ASC;

-- Better
SELECT transaction_date, 
    SUM(CASE WHEN amount%2 != 0 THEN amount ELSE 0 END) AS odd_sum,
    SUM(CASE WHEN amount%2 = 0 THEN amount ELSE 0 END) AS even_sum
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date;

Drop table if exists transactions;


/* 596. Classes With at Least 5 Students [E]
Write a solution to find all the classes that have at least five students.

Return the result table in any order.
*/

Drop table if exists Courses;
Create table If Not Exists Courses (student varchar(255), class varchar(255));
Truncate table Courses;
insert into Courses (student, class) values ('A', 'Math');
insert into Courses (student, class) values ('B', 'English');
insert into Courses (student, class) values ('C', 'Math');
insert into Courses (student, class) values ('D', 'Biology');
insert into Courses (student, class) values ('E', 'Math');
insert into Courses (student, class) values ('F', 'Computer');
insert into Courses (student, class) values ('G', 'Math');
insert into Courses (student, class) values ('H', 'Math');
insert into Courses (student, class) values ('I', 'Math');

SELECT *
FROM Courses;

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(*) >= 5;

Drop table if exists Courses;


/* 1527. Patients With a Condition [E]
Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes.
Type I Diabetes always starts with DIAB1 prefix.

Return the result table in any order.
*/

Drop table if exists Patients;
Create table If Not Exists Patients (patient_id int, patient_name varchar(30), conditions varchar(100));
Truncate table Patients;
insert into Patients (patient_id, patient_name, conditions) values ('1', 'Daniel', 'YFEV COUGH');
insert into Patients (patient_id, patient_name, conditions) values ('2', 'Alice', '');
insert into Patients (patient_id, patient_name, conditions) values ('3', 'Bob', 'DIAB100 MYOP');
insert into Patients (patient_id, patient_name, conditions) values ('4', 'George', 'ACNE DIAB100');
insert into Patients (patient_id, patient_name, conditions) values ('5', 'Alain', 'DIAB201');

SELECT *
FROM Patients;

SELECT *
FROM Patients
WHERE conditions LIKE 'DIAB1%'
    OR conditions LIKE '% DIAB1%';

Drop table if exists Patients;


/* 579. Find Cumulative Salary of an Employee [H]
Write a solution to calculate the cumulative salary summary for every employee in a single unified table.

The cumulative salary summary for an employee can be calculated as follows:

* For each month that the employee worked, sum up the salaries in that month and the previous two months.
    This is their 3-month sum for that month. If an employee did not work for the company in previous months, their effective salary for those months is 0.

* Do not include the 3-month sum for the most recent month that the employee worked for in the summary.

* Do not include the 3-month sum for any month the employee did not work.

Return the result table ordered by id in ascending order. In case of a tie, order it by month in descending order.
*/

Drop table if exists Employee;
Create table If Not Exists Employee (id int, month int, salary int);
Truncate table Employee;
insert into Employee (id, month, salary) values ('1', '1', '20');
insert into Employee (id, month, salary) values ('2', '1', '20');
insert into Employee (id, month, salary) values ('1', '2', '30');
insert into Employee (id, month, salary) values ('2', '2', '30');
insert into Employee (id, month, salary) values ('3', '2', '40');
insert into Employee (id, month, salary) values ('1', '3', '40');
insert into Employee (id, month, salary) values ('3', '3', '60');
insert into Employee (id, month, salary) values ('1', '4', '60');
insert into Employee (id, month, salary) values ('3', '4', '70');
insert into Employee (id, month, salary) values ('1', '7', '90');
insert into Employee (id, month, salary) values ('1', '8', '90');

SELECT *
FROM Employee;

-- This version incorrect; works for previous 3 months as record, not previoius 3 months by month number
WITH CTE AS (
    SELECT id, month, SUM(salary) AS salary,
        MAX(month) OVER(PARTITION BY id) AS max_month
    FROM Employee
    GROUP BY id, month
),
CTE2 AS (
    SELECT id, month, salary
    FROM CTE
    WHERE month != max_month
),
Full AS (
    SELECT *,
        LAG(month, 1) OVER(PARTITION BY id) AS month_1,
        LAG(month, 2) OVER(PARTITION BY id) AS month_2
    FROM CTE2
)
SELECT F.id, F.month, F.salary, F.month_1, F.month_2, L1.salary, L2.salary
FROM Full F
LEFT JOIN Full L1
ON F.id = L1.id AND F.month_1 = L1.month
LEFT JOIN Full L2
ON F.id = L2.id AND F.month_2 = L2.month;

-- This version is correct
WITH CTE AS (
    SELECT id, month, SUM(salary) AS salary,
        MAX(month) OVER(PARTITION BY id) AS max_month
    FROM Employee
    GROUP BY id, month
),
CTE2 AS (
    SELECT id, month, salary
    FROM CTE
    WHERE month != max_month
)
SELECT M.id AS id, M.month AS month, M.salary + IFNULL(M1.salary,0) + IFNULL(M2.salary,0) AS salary
FROM CTE2 M
LEFT JOIN CTE2 M1
    ON M.id = M1.id AND M.month = M1.month + 1
LEFT JOIN CTE2 M2
    ON M.id = M2.id AND M.month = M2.month + 2
ORDER BY M.id ASC, M.month DESC;
-- M.salary AS salary, IFNULL(M1.salary,0) AS salary_1, IFNULL(M2.salary,0) AS salary_2

-- Even better
SELECT
    E1.id,
    E1.month,
    (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary, 0)) AS Salary
FROM
    (SELECT
        id, MAX(month) AS month
    FROM
        Employee
    GROUP BY id
    HAVING COUNT(*) > 1) AS maxmonth
        LEFT JOIN
    Employee E1 ON (maxmonth.id = E1.id
        AND maxmonth.month > E1.month)
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
        LEFT JOIN
    Employee E3 ON (E3.id = E1.id
        AND E3.month = E1.month - 2)
ORDER BY id ASC , month DESC
;

Drop table if exists Employee;


/* 1587. Bank Account Summary II [E]
Write a solution to report the name and balance of users with a balance higher than 10000.
The balance of an account is equal to the sum of the amounts of all transactions involving that account.

Return the result table in any order.
*/

Drop table if exists Users;
Drop table if exists Transactions;
Create table If Not Exists Users (account int, name varchar(20));
Create table If Not Exists Transactions (trans_id int, account int, amount int, transacted_on date);
Truncate table Users;
insert into Users (account, name) values ('900001', 'Alice');
insert into Users (account, name) values ('900002', 'Bob');
insert into Users (account, name) values ('900003', 'Charlie');
Truncate table Transactions;
insert into Transactions (trans_id, account, amount, transacted_on) values ('1', '900001', '7000', '2020-08-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('2', '900001', '7000', '2020-09-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('3', '900001', '-3000', '2020-09-02');
insert into Transactions (trans_id, account, amount, transacted_on) values ('4', '900002', '1000', '2020-09-12');
insert into Transactions (trans_id, account, amount, transacted_on) values ('5', '900003', '6000', '2020-08-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('6', '900003', '6000', '2020-09-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('7', '900003', '-4000', '2020-09-11');

WITH Grps AS (
    SELECT name, SUM(amount) AS balance
    FROM Transactions
    LEFT JOIN Users USING(account)
    GROUP BY name
)
SELECT name, balance
FROM Grps
WHERE balance > 10000;

Drop table if exists Users;
Drop table if exists Transactions;


/* 1484. Group Sold Products By The Date [E]
Write a solution to find for each date the number of different products sold and their names.

The sold products names for each date should be sorted lexicographically.

Return the result table ordered by sell_date.
*/

Drop table if exists Activities;
Create table If Not Exists Activities (sell_date date, product varchar(20));
Truncate table Activities;
insert into Activities (sell_date, product) values ('2020-05-30', 'Headphone');
insert into Activities (sell_date, product) values ('2020-06-01', 'Pencil');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'Basketball');
insert into Activities (sell_date, product) values ('2020-06-01', 'Bible');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'T-Shirt');

SELECT *
FROM Activities;

SELECT sell_date, COUNT(DISTINCT product) AS num_sold, GROUP_CONCAT(DISTINCT product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

Drop table if exists Activities;


/* 615. Average Salary: Departments VS Company [H]
Find the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.

Return the result table in any order.
*/

Drop table if exists Salary;
Drop table if exists Employee;
Create table If Not Exists Salary (id int, employee_id int, amount int, pay_date date);
Create table If Not Exists Employee (employee_id int, department_id int);
Truncate table Salary;
insert into Salary (id, employee_id, amount, pay_date) values ('1', '1', '9000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('2', '2', '6000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('3', '3', '10000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('4', '1', '7000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('5', '2', '6000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('6', '3', '8000', '2017/02/28');
Truncate table Employee;
insert into Employee (employee_id, department_id) values ('1', '1');
insert into Employee (employee_id, department_id) values ('2', '2');
insert into Employee (employee_id, department_id) values ('3', '2');

SELECT *
FROM Salary;

SELECT *
FROM Employee;

WITH SalEmp AS (
    SELECT *, DATE_FORMAT(pay_date, '%Y-%m') AS pay_month
    FROM Salary
    JOIN Employee
        USING (employee_id)
),
DepGrp AS (
    SELECT pay_month, department_id, AVG(amount) AS salary_dep
    FROM SalEmp
    GROUP BY pay_month, department_id
),
ComGrp AS(
    SELECT pay_month, AVG(amount) AS salary_com
    FROM SalEmp
    GROUP BY pay_month
)
SELECT pay_month, department_id,
    CASE
        WHEN salary_dep > salary_com THEN 'higher'
        WHEN salary_dep < salary_com THEN 'lower'
        WHEN salary_dep = salary_com THEN 'same'
    END AS comparison
FROM DepGrp
LEFT JOIN ComGrp USING(pay_month);

Drop table if exists Salary;
Drop table if exists Employee;


/* 1965. Employees With Missing Information [E]
Write a solution to report the IDs of all the employees with missing information. The information of an employee is missing if:

* The employee's name is missing, or

* The employee's salary is missing.

Return the result table ordered by employee_id in ascending order.
*/

Drop table if exists Employees;
Drop table if exists Salaries;
Create table If Not Exists Employees (employee_id int, name varchar(30));
Create table If Not Exists Salaries (employee_id int, salary int);
Truncate table Employees;
insert into Employees (employee_id, name) values ('2', 'Crew');
insert into Employees (employee_id, name) values ('4', 'Haven');
insert into Employees (employee_id, name) values ('5', 'Kristian');
Truncate table Salaries;
insert into Salaries (employee_id, salary) values ('5', '76071');
insert into Salaries (employee_id, salary) values ('1', '22517');
insert into Salaries (employee_id, salary) values ('4', '63539');

SELECT *
FROM Employees;

SELECT *
FROM Salaries;

WITH CTE AS (
    SELECT employee_id, name, salary, IF(salary IS NULL OR name IS NULL, 1, 0) AS missing
    FROM Employees
    LEFT JOIN Salaries USING(employee_id)
    UNION
    SELECT employee_id, name, salary, IF(salary IS NULL OR name IS NULL, 1, 0) AS missing
    FROM Employees
    RIGHT JOIN Salaries USING(employee_id)
)
SELECT employee_id
FROM CTE
WHERE missing = 1
ORDER BY employee_id ASC;

Drop table if exists Employees;
Drop table if exists Salaries;


/* 1741. Find Total Time Spent by Each Employee [E]
Write a solution to calculate the total time in minutes spent by each employee on each day at the office.
Note that within one day, an employee can enter and leave more than once. The time spent in the office for a single entry is out_time - in_time.

Return the result table in any order.
*/

Drop table if exists Employees;
Create table If Not Exists Employees(emp_id int, event_day date, in_time int, out_time int);
Truncate table Employees;
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74');

SELECT *
FROM Employees;

WITH CTE AS (
    SELECT *, out_time - in_time AS total_time
    FROM Employees
)
SELECT event_day AS day, emp_id, SUM(total_time) AS total_time
FROM CTE
GROUP BY event_day, emp_id;

Drop table if exists Employees;


/* 1873. Calculate Special Bonus [E]
Write a solution to calculate the bonus of each employee. The bonus of an employee is 100% of their salary
if the ID of the employee is an odd number and the employee's name does not start with the character 'M'.
The bonus of an employee is 0 otherwise.

Return the result table ordered by employee_id.
*/

Drop table if exists Employees;
Create table If Not Exists Employees (employee_id int, name varchar(30), salary int);
Truncate table Employees;
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000');
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800');
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400');
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100');
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700');

SELECT *
FROM Employees;

SELECT employee_id,
    CASE
        WHEN employee_id%2 = 1 AND name NOT LIKE 'M%' THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;

Drop table if exists Employees;


/* 574. Winning Candidate [M]
Write a solution to report the name of the winning candidate (i.e., the candidate who got the largest number of votes).

The test cases are generated so that exactly one candidate wins the elections.
*/

Drop table if exists Candidate;
Drop table if exists Vote;
Create table If Not Exists Candidate (id int, name varchar(255));
Create table If Not Exists Vote (id int, candidateId int);
Truncate table Candidate;
insert into Candidate (id, name) values ('1', 'A');
insert into Candidate (id, name) values ('2', 'B');
insert into Candidate (id, name) values ('3', 'C');
insert into Candidate (id, name) values ('4', 'D');
insert into Candidate (id, name) values ('5', 'E');
Truncate table Vote;
insert into Vote (id, candidateId) values ('1', '2');
insert into Vote (id, candidateId) values ('2', '4');
insert into Vote (id, candidateId) values ('3', '3');
insert into Vote (id, candidateId) values ('4', '2');
insert into Vote (id, candidateId) values ('5', '5');

SELECT *
FROM Candidate;

SELECT *
FROM Vote;

WITH VotesGrp AS (
    SELECT candidateId, COUNT(id) AS votes
    FROM Vote
    GROUP BY candidateId
),
VotesWin AS (
    SELECT *
    FROM VotesGrp VG
    WHERE votes = (
        SELECT MAX(votes)
        FROM VotesGrp
    )
)
SELECT name
FROM VotesWin VW
LEFT JOIN Candidate C
    ON VW.candidateId = C.id;


Drop table if exists Candidate;
Drop table if exists Vote;


/* 578. Get Highest Answer Rate Question [M]
The answer rate for a question is the number of times a user answered the question by the number of times a user showed the question.

Write a solution to report the question that has the highest answer rate.
If multiple questions have the same maximum answer rate, report the question with the smallest question_id.
*/

Drop table if exists SurveyLog;
Create table If Not Exists SurveyLog (id int, action varchar(255), question_id int, answer_id int, q_num int, timestamp int);
Truncate table SurveyLog;
insert into SurveyLog (id, action, question_id, answer_id, q_num, timestamp) values ('5', 'show', '285', NULL, '1', '123');
insert into SurveyLog (id, action, question_id, answer_id, q_num, timestamp) values ('5', 'answer', '285', '124124', '1', '124');
insert into SurveyLog (id, action, question_id, answer_id, q_num, timestamp) values ('5', 'show', '369', NULL, '2', '125');
insert into SurveyLog (id, action, question_id, answer_id, q_num, timestamp) values ('5', 'skip', '369', NULL, '2', '126');

SELECT *
FROM SurveyLog;

WITH Shown AS (
    SELECT question_id, COUNT(*) AS show_cnt
    FROM SurveyLog
    WHERE action = 'show'
    GROUP BY question_id
),
Answered AS (
    SELECT question_id, COUNT(*) AS answer_cnt
    FROM SurveyLog
    WHERE action = 'answer'
    GROUP BY question_id
),
    CTE AS (
    SELECT *, IFNULL(answer_cnt, 0)/show_cnt AS ratio
    FROM Shown
    LEFT JOIN Answered USING(question_id)
)
SELECT question_id as survey_log
FROM CTE
WHERE ratio = (
    SELECT MAX(ratio)
    FROM CTE
)
ORDER BY question_id ASC
LIMIT 1;

Drop table if exists SurveyLog;


/* 580. Count Student Number in Departments [M]
Write a solution to report the respective department name and number of students majoring in each department for all departments
in the Department table (even ones with no current students).

Return the result table ordered by student_number in descending order. In case of a tie, order them by dept_name alphabetically.
*/

Drop table if exists Student;
Drop table if exists Department;
Create table If Not Exists Student (student_id int,student_name varchar(45), gender varchar(6), dept_id int);
Create table If Not Exists Department (dept_id int, dept_name varchar(255));
Truncate table Student;
insert into Student (student_id, student_name, gender, dept_id) values ('1', 'Jack', 'M', '1');
insert into Student (student_id, student_name, gender, dept_id) values ('2', 'Jane', 'F', '1');
insert into Student (student_id, student_name, gender, dept_id) values ('3', 'Mark', 'M', '2');
Truncate table Department;
insert into Department (dept_id, dept_name) values ('1', 'Engineering');
insert into Department (dept_id, dept_name) values ('2', 'Science');
insert into Department (dept_id, dept_name) values ('3', 'Law');

SELECT *
FROM Student;

SELECT *
FROM Department;

WITH StuGrp AS (
    SELECT dept_id, COUNT(*) AS student_number
    FROM Student
    GROUP BY dept_id
)
SELECT D.dept_name, IFNULL(S.student_number, 0) AS student_number
FROM Department D
LEFT JOIN StuGrp S USING(dept_id)
ORDER BY student_number DESC, dept_name ASC;

Drop table if exists Student;
Drop table if exists Department;


/* 612. Shortest Distance in a Plane [M]
The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).

Write a solution to report the shortest distance between any two points from the Point2D table. Round the distance to two decimal points.
*/

Drop table if exists Point2D;
Create Table If Not Exists Point2D (x int not null, y int not null);
Truncate table Point2D;
insert into Point2D (x, y) values ('-1', '-1');
insert into Point2D (x, y) values ('0', '0');
insert into Point2D (x, y) values ('-1', '-2');

SELECT *
FROM Point2D;

WITH Combos AS (
    SELECT PA.x AS xA, PA.y as yA, PB.x AS xB, PB.y as yB
    FROM Point2D PA, Point2D PB
    WHERE (PA.x , PA.y ) != (PB.x, PB.y)
),
Calc AS (
    SELECT SQRT(POW((xB - xA) + 0.0, 2) + POW((yB - yA) + 0.0, 2)) AS dist
    FROM Combos
)
SELECT ROUND(MIN(dist),2) as shortest
from Calc;

-- Better

SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))),2) AS shortest
FROM
    point_2d p1
        JOIN
    point_2d p2 ON (p1.x <= p2.x AND p1.y < p2.y)
        OR (p1.x <= p2.x AND p1.y > p2.y)
        OR (p1.x < p2.x AND p1.y = p2.y)
;

Drop table if exists Point2D;

