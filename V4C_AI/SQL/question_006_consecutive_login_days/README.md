# Q6 — Consecutive Login Days

## Interview Question

Given a table `user_logins(user_id, login_date)`, find users who logged in on two consecutive days.

Expected users from the sample data: `101`, `103`.

## My Initial Attempt

```sql
WITH cte AS ( user_id, login_date,
    LAG(login_date) OVER (
        PARTITION BY user_id
        ORDER BY user_id
    ) AS previous_login_date
FROM user_logins)
SELECT user_id, login_date, previous_login_date
FROM cte;
```

### Issues

1. `SELECT` was missing inside the CTE.
2. `LAG()` must be ordered by `login_date`, not `user_id`.
3. The query needed `DATEDIFF()` to identify consecutive dates.

## Corrected Attempt

```sql
WITH cte AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS previous_login_date
    FROM user_logins
)
SELECT
    user_id,
    login_date,
    previous_login_date
FROM cte
WHERE DATEDIFF(login_date, previous_login_date) = 1;
```

## Final Solution

```sql
WITH cte AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS previous_login_date
    FROM user_logins
)
SELECT
    user_id,
    login_date,
    previous_login_date
FROM cte
WHERE DATEDIFF(login_date, previous_login_date) = 1;
```

## Concepts Tested

- `LAG()` window function
- `PARTITION BY`
- `ORDER BY` inside a window function
- `DATEDIFF()`
- CTEs
- Consecutive-date pattern

## Interview Explanation

`LAG()` gets the previous login date for each user. `PARTITION BY user_id` makes the comparison happen independently for each user, while `ORDER BY login_date` ensures the dates are evaluated chronologically. `DATEDIFF()` then checks whether the current login is exactly one day after the previous login.

**Score: 9/10** — The final query is correct. The main issues in the initial attempt were CTE syntax, ordering by the wrong column, and missing the consecutive-date condition.
