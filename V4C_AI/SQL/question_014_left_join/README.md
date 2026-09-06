# Q14 — LEFT JOIN

## Problem

Find all customers, including customers who have never placed an order. Return customer and order details.

## Final Solution

```sql
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
```

## Key Concept

A `LEFT JOIN` keeps every row from the left table. If there is no matching order, columns from `orders` are `NULL`.

To find only customers with no orders, use `WHERE o.order_id IS NULL`.

## Interview Takeaway

**LEFT JOIN = all rows from the left table + matching rows from the right table.**

## Score

**10/10 — correct on the first attempt.**