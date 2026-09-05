-- Q6: Consecutive Login Days
-- Find users who logged in on consecutive days.

WITH cte AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS previous_login_date
    FROM user_logins
)
SELECT
    user_id,
    login_date,
    previous_login_date
FROM cte
WHERE DATEDIFF(login_date, previous_login_date) = 1;
