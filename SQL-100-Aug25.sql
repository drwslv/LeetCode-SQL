

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