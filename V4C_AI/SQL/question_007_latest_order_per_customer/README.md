# Q7 — Latest Record Per Customer

## Interview Question

Given `orders(order_id, customer_id, order_date, order_amount)`, find the latest order for each customer.

## Initial Attempt

```sql
SELECT order_id,
       customer_id,
       order_date,
       order_amount
FROM orders
GROUP BY customer_id
HAVING MAX(order_date);
```

### Why it was incorrect

`GROUP BY customer_id` creates one group per customer, but `order_id`, `order_date`, and `order_amount` are not aggregated. `MAX(order_date)` identifies the latest date but does not automatically return the complete row associated with that date. `HAVING` is also not the right pattern for selecting the row with the maximum date.

## Correct Solution

```sql
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
```

## Concepts Tested

- `ROW_NUMBER()`
- `PARTITION BY`
- Window-function ordering
- Latest-record pattern
- CTEs
- Difference between aggregation and row selection

## Interview Explanation

`ROW_NUMBER()` assigns a unique number to each order within a customer. `PARTITION BY customer_id` starts the numbering separately for every customer, while `ORDER BY order_date DESC` puts the newest order first. Therefore, `rn = 1` returns the latest order for each customer.

**Score: 10/10** — Correct window-function approach and correct use of descending date order.
