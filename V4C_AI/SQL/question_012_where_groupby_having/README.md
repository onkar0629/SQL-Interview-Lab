# Q12 — Department With Highest Average Salary

## Problem

Find departments where employees with `salary > 30000` are considered and the resulting department average salary is greater than `50000`.

## Key Concepts

- `WHERE` filters individual rows before grouping.
- `GROUP BY` creates one group per department.
- `AVG()` calculates the average salary for each department.
- `HAVING` filters groups after aggregation.

## Initial Attempt

The structure was correct, but both comparison operators were reversed:

```sql
WHERE salary < 30000
HAVING average_salary < 50000
```

They were corrected to `>` because the requirement was salary above 30,000 and average salary above 50,000.

## Final Solution

```sql
SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
WHERE salary > 30000
GROUP BY department_id
HAVING AVG(salary) > 50000;
```

## Interview Takeaway

`WHERE` filters rows before grouping; `HAVING` filters groups after aggregation.

## Score

**7/10 — completed after correcting the filter directions.**