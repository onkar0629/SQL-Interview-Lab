# Q10 — Top 2 Earners Per Department

## Interview Question

Find the top 2 highest-paid employees in each department. If employees have the same salary, all tied employees should be included.

## Initial Attempt

```sql
WITH cte AS (
    SELECT employee_id,
           employee_name,
           department_id,
           salary,
           ROW_NUMBER() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rn
    FROM employees
)
SELECT employee_id,
       employee_name,
       department_id,
       salary
FROM cte
WHERE rn <= 2;
```

### Why it needed correction

`ROW_NUMBER()` assigns a unique number to every row. If two employees have the same salary, one can receive rank 2 and the other rank 3, causing the tied employee to be excluded.

Because the requirement says to include ties, `DENSE_RANK()` is appropriate.

## Final Solution

```sql
WITH cte AS (
    SELECT
        employee_id,
        employee_name,
        department_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rn
    FROM employees
)
SELECT
    employee_id,
    employee_name,
    department_id,
    salary
FROM cte
WHERE rn <= 2;
```

## Concepts Tested

- `DENSE_RANK()`
- `ROW_NUMBER()` vs `DENSE_RANK()`
- `PARTITION BY`
- Ranking within groups
- Handling ties
- Top-N-per-group pattern

## Interview Explanation

`DENSE_RANK()` ranks salaries separately within each department, with the highest salary receiving rank 1. Employees with the same salary receive the same rank. Filtering with `rn <= 2` therefore returns the top two salary levels and includes all employees tied at those levels. Consequently, the result can contain more than two employees for a department.

### Important Distinction

- `ROW_NUMBER()` → exactly N rows per group, assuming enough rows.
- `RANK()` → includes ties, with gaps in ranking.
- `DENSE_RANK()` → includes ties, without gaps.

**Score: 10/10** — The corrected solution exactly matches the requirement to include ties.
