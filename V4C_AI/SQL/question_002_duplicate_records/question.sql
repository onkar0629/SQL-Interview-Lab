-- V4C.ai Interview Preparation
-- Question 002: Identify duplicate customers based on email

WITH cte AS (
    SELECT
        email,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS dp
    FROM customers
)
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM cte
WHERE dp > 1
GROUP BY email;
