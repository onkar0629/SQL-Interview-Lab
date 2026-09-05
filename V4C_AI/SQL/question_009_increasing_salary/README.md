# Q9 — Employees With Increasing Salary

## Interview Question

Given `employees(employee_id, employee_name, department_id, salary, salary_date)`, find salary records where the current salary is greater than the employee's previous salary.

Return `employee_id`, `salary_date`, `salary`, `previous_salary`, and `salary_difference`.

## Initial Attempt

```sql
SELECT employee_id,
       salary_date,
       salary,
       LAG(salary) OVER (
           PARTITION BY emloyee_id
           ORDER BY salary_date
       ) AS previous_salary,
       salary - LAG(salary) OVER (
           PARTITION BY emloyee_id
           ORDER BY salary_date
       ) AS salary_difference
FROM employees;
```

### Issues

1. `emloyee_id` was a typo; the column is `employee_id`.
2. The query calculated the previous salary and difference but did not filter for `salary > previous_salary`.

## Final Solution

```sql
WITH cte AS (
    SELECT
        employee_id,
        salary_date,
        salary,
        LAG(salary) OVER (
            PARTITION BY employee_id
            ORDER BY salary_date
        ) AS previous_salary
    FROM employees
)
SELECT
    employee_id,
    salary_date,
    salary,
    previous_salary,
    salary - previous_salary AS salary_difference
FROM cte
WHERE salary > previous_salary;
```

## Concepts Tested

- `LAG()` window function
- `PARTITION BY`
- Chronological ordering
- CTEs
- Comparing current and previous rows
- Calculating row-to-row differences

## Interview Explanation

The CTE uses `LAG(salary)` to retrieve the previous salary for each employee. `PARTITION BY employee_id` keeps each employee's salary history separate, and `ORDER BY salary_date` establishes the chronological sequence. The outer query keeps only records where the current salary is greater than the previous salary and calculates the increase using subtraction.

**Score: 9/10** — The final logic is correct. The only remaining issue in the submitted final attempt was a trailing comma after `previous_salary`, which was removed in the pushed version.
