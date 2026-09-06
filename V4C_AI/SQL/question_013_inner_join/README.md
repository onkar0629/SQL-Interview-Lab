# Q13 — INNER JOIN

## Problem

Find all customers who have placed at least one order. Return customer and order details.

## Final Solution

```sql
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;
```

## Key Concept

`JOIN` without another join type is an `INNER JOIN`. It returns only rows where the join condition matches in both tables.

## Interview Takeaway

**INNER JOIN = matching rows from both tables.**

## Score

**10/10 — correct on the first attempt.**