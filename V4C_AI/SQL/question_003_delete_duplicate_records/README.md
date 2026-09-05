# Q3 — Delete Duplicate Records

## Interview Question

Given `customers(customer_id, customer_name, email, phone)`, duplicate customers are identified by `email`.

Write a SQL query to delete duplicate records while keeping exactly one record for each email.

Example:

| customer_id | customer_name | email |
|---:|---|---|
| 101 | Amit | amit@gmail.com |
| 102 | Amit | amit@gmail.com |
| 103 | Rahul | rahul@gmail.com |
| 104 | Amit | amit@gmail.com |

Keep one record for each email. This solution keeps the smallest `customer_id`.

## Initial Attempt

```sql
WITH cte AS (
    SELECT customer_id, customer_name, email,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id DESC) AS rn
    FROM customers
)
DELETE FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM cte
    WHERE rn > 1
);
```

## Final Solution

```sql
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
```

## Explanation

- `PARTITION BY email` creates a separate numbering sequence for each email.
- `ORDER BY customer_id` makes the smallest customer ID `rn = 1`.
- `rn = 1` is retained.
- `rn > 1` identifies duplicate records for deletion.
- The outer `DELETE` removes those duplicate `customer_id` values.

## Key Interview Concept

`ROW_NUMBER()` is useful for deduplication when you need to identify exactly which row to keep and which rows to remove.

Be especially careful with the ordering column because it determines which duplicate survives.
