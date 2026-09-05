# Question 002 — Duplicate Records

## Interview Question

Given the table:

`customers(customer_id, customer_name, email, phone)`

Identify duplicate customers based on `email` and return:

- `email`
- `duplicate_count`

## User's Initial Approach

The first attempt used `ROW_NUMBER()` to identify repeated occurrences of the same email.

```sql
WITH cte AS (
    SELECT email,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS dp
    FROM customers
)
SELECT email,
       COUNT(email) AS duplicate_count
FROM cte
WHERE dp > 1;
```

### Corrections

1. `GROUP BY email` is required because `COUNT(*)` is used with `email` in the `SELECT` list.
2. `dp > 1` counts duplicate occurrences beyond the first occurrence. For example, if an email appears 3 times, `dp > 1` returns rows 2 and 3, so `duplicate_count = 2`.
3. If the interviewer instead means the **total number of records for each duplicated email**, the simpler `GROUP BY ... HAVING COUNT(*) > 1` solution is preferable.

## Final User Solution

```sql
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
```

## Alternative — Total Duplicate Records

If `duplicate_count` is intended to mean the total number of records sharing the email:

```sql
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;
```

## Key Interview Concepts

- `PARTITION BY email` groups rows with the same email for the window function.
- `ROW_NUMBER()` assigns a unique sequence within each email group.
- `dp > 1` identifies occurrences after the first record.
- `GROUP BY` is required when aggregating with `COUNT(*)`.
- `HAVING COUNT(*) > 1` is the simplest pattern for finding duplicate values.

## Interview Tip

Before writing the query, clarify what the interviewer means by **duplicate_count**:

- **Extra duplicates:** count rows after the first occurrence → `ROW_NUMBER()` + `WHERE rn > 1`.
- **Total occurrences:** count all rows for duplicated values → `GROUP BY` + `HAVING COUNT(*) > 1`.
