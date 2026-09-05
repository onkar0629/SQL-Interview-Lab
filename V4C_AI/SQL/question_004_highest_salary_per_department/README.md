# Q4 — Highest Salary Per Department

## Interview Question

Given `employees(employee_id, employee_name, department_id, salary)`, find the highest-paid employee in each department. If two or more employees have the same highest salary, return all of them.

## Initial Attempt

```sql
WITH cte AS (
    SELECT
        employee_id,
        employee_name,
        department_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary
        ) AS rn
    FROM employees
)
SELECT employee_id, employee_name, department_id, salary
FROM cte
WHERE rn = 1;
```

### Correction

`ORDER BY salary` sorts ascending, so `rn = 1` returns the lowest salary. Use `ORDER BY salary DESC` to rank the highest salary as 1.

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
WHERE rn = 1;
```

## Explanation

- `PARTITION BY department_id` ranks employees independently within each department.
- `ORDER BY salary DESC` places the highest salary first.
- `DENSE_RANK()` assigns rank 1 to every employee tied for the highest salary.
- `WHERE rn = 1` returns all highest-paid employees per department.

## Key Interview Concept

Use `DENSE_RANK()` when ties must be preserved. `ROW_NUMBER()` would return only one employee even when multiple employees share the highest salary.
