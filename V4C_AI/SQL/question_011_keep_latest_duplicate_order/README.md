# Q11 — Keep Latest Duplicate Order

## Problem

A customer order can appear multiple times because of duplicate loads. For each `order_id`, keep only the most recently updated record.

## Key Concept

Use `ROW_NUMBER()` with:
- `PARTITION BY order_id` to rank records for each order independently.
- `ORDER BY updated_at DESC` so the newest record receives `rn = 1`.
- `WHERE rn = 1` to keep the latest record.

## Initial Attempt

The first attempt had three issues:
1. Missing `SELECT` inside the CTE.
2. `ORDER BY updated_at` was ascending, which selected the oldest record.
3. `WHERE RN < 1` returned no rows because `ROW_NUMBER()` starts at 1.

## Final Solution

```sql
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
```

## Interview Takeaway

**Latest record = `ROW_NUMBER()` + `PARTITION BY duplicate_key` + `ORDER BY timestamp DESC` + `rn = 1`.**

## Score

**10/10 — completed after correction.**