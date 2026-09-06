-- Q11: Keep Latest Duplicate Order
-- Keep the most recently updated record for each order_id.

WITH cte AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY updated_at DESC
        ) AS rn
    FROM customer_orders
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_amount,
    updated_at
FROM cte
WHERE rn = 1;