-- Q3: Delete duplicate customer records while keeping one record per email
-- Keep the smallest customer_id for each email.

WITH cte AS (
    SELECT
        customer_id,
        customer_name,
        email,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM customers
)
DELETE FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM cte
    WHERE rn > 1
);
