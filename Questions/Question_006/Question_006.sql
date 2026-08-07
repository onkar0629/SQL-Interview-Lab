-- ============================================================================
-- SQL INTERVIEW QUESTION #006
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Netflix (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Streaming
-- Estimated Time  : 35-45 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Content Analytics team wants to identify users who binge-watch content.

A user is considered a binge watcher if they watch **3 or more different
movies on the same day**.

This report is used to understand user engagement and recommend premium plans.

As a Data Engineer, your task is to identify all binge-watching sessions.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : watch_history

Approx. Rows     : 15 (Sample Dataset)

Primary Key      : watch_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS watch_history;

CREATE TABLE watch_history
(
    watch_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    watch_date DATE NOT NULL,
    watch_time TIME NOT NULL
);

INSERT INTO watch_history
(watch_id, user_id, movie_id, watch_date, watch_time)
VALUES
    (101,1,201,'2024-01-01','10:00:00'),
    (102,1,202,'2024-01-01','12:00:00'),
    (103,1,203,'2024-01-01','18:00:00'),

    (104,2,204,'2024-01-02','11:00:00'),
    (105,2,205,'2024-01-02','13:00:00'),

    (106,3,206,'2024-01-03','09:00:00'),
    (107,3,206,'2024-01-03','10:30:00'),
    (108,3,207,'2024-01-03','12:00:00'),

    (109,4,208,'2024-01-04','08:00:00'),
    (110,4,209,'2024-01-04','14:00:00'),
    (111,4,210,'2024-01-04','20:00:00'),
    (112,4,211,'2024-01-04','22:00:00'),

    (113,5,212,'2024-01-05','19:00:00'),
    (114,5,213,'2024-01-06','19:30:00'),
    (115,5,214,'2024-01-07','20:00:00');


/*
==============================================================================
INPUT DATA
==============================================================================

watch_history

+----------+---------+----------+------------+------------+
| watch_id | user_id | movie_id | watch_date | watch_time |
+----------+---------+----------+------------+------------+
| 101      | 1       | 201      | 2024-01-01 | 10:00:00   |
| 102      | 1       | 202      | 2024-01-01 | 12:00:00   |
| 103      | 1       | 203      | 2024-01-01 | 18:00:00   |
| 104      | 2       | 204      | 2024-01-02 | 11:00:00   |
| 105      | 2       | 205      | 2024-01-02 | 13:00:00   |
| 106      | 3       | 206      | 2024-01-03 | 09:00:00   |
| 107      | 3       | 206      | 2024-01-03 | 10:30:00   |
| 108      | 3       | 207      | 2024-01-03 | 12:00:00   |
| 109      | 4       | 208      | 2024-01-04 | 08:00:00   |
| 110      | 4       | 209      | 2024-01-04 | 14:00:00   |
| 111      | 4       | 210      | 2024-01-04 | 20:00:00   |
| 112      | 4       | 211      | 2024-01-04 | 22:00:00   |
| 113      | 5       | 212      | 2024-01-05 | 19:00:00   |
| 114      | 5       | 213      | 2024-01-06 | 19:30:00   |
| 115      | 5       | 214      | 2024-01-07 | 20:00:00   |
+----------+---------+----------+------------+------------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify users who watched **3 or more different movies on the same day**.

Return the following columns:

- user_id
- watch_date
- total_movies

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Count only **distinct movies** watched on the same day.
2. Ignore repeated watches of the same movie.
3. Return users who watched **3 or more distinct movies**.
4. Sort the result by:
   - user_id
   - watch_date

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. A user may watch the same movie multiple times in one day.
2. Count only unique (`DISTINCT`) movies.
3. Write production-quality SQL.
4. The production table contains billions of watch events.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */

SELECT
    user_id,
    watch_date,
    COUNT(DISTINCT movie_id) AS Total_Movies
FROM watch_history
GROUP BY
    user_id,
    watch_date
HAVING Total_Movies >= 3;