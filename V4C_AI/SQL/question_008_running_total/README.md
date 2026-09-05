# Q8 — Running Total

## Interview Question

Given `sales(employee_id, sale_date, sales_amount)`, calculate the cumulative sales total for each employee ordered by sale date.

## Final Solution

```sql
SELECT employee_id,
       sale_date,
       sales_amount,
       SUM(sales_amount) OVER (
           PARTITION BY employee_id
           ORDER BY sale_date
       ) AS cumulative_sum
FROM sales;
```

## Concepts Tested

- `SUM()` as a window function
- `OVER()`
- `PARTITION BY`
- `ORDER BY` inside a window function
- Running/cumulative totals

## Interview Explanation

`PARTITION BY employee_id` creates an independent calculation for each employee. `ORDER BY sale_date` processes each employee's sales chronologically. The windowed `SUM()` therefore produces a cumulative sales total for every row.

## Key Pattern

```text
SUM(value) OVER (
    PARTITION BY entity
    ORDER BY date
)
```

**Score: 10/10** — Correct solution. Only the alias spelling was normalized from `Cumilative_sum` to `cumulative_sum`.
