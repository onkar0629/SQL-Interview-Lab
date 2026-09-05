-- Q7: Latest Record Per Customer
-- Find the latest order for each customer.

WITH cte AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn
    FROM orders
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_amount
FROM cte
WHERE rn = 1;
