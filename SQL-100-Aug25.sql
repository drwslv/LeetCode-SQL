

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


