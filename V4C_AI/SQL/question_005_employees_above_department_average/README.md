# Q5 — Employees Above Department Average

## Interview Question

Find employees whose salary is greater than the average salary of their own department.

## User Solution

```sql
WITH cte AS (
    SELECT employee_id,
           employee_name,
           department_id,
           salary,
           AVG(salary) OVER (PARTITION BY department_id) AS avg
    FROM employees
)
SELECT employee_id,
       employee_name,
       department_id,
       salary
FROM cte
WHERE salary > avg;
```

## Final Interview-Ready Solution

```sql
WITH cte AS (
    SELECT
        employee_id,
        employee_name,
        department_id,
        salary,
        AVG(salary) OVER (
            PARTITION BY department_id
        ) AS department_avg_salary
    FROM employees
)
SELECT
    employee_id,
    employee_name,
    department_id,
    salary
FROM cte
WHERE salary > department_avg_salary;
```

## Explanation

`AVG(salary) OVER (PARTITION BY department_id)` calculates the average salary for each department while retaining the individual employee rows. The outer query then filters employees whose salary is greater than that department average.

## Key Interview Concept

Window aggregation differs from `GROUP BY`: a window function calculates a department-level value without collapsing employee rows into one row per department.
