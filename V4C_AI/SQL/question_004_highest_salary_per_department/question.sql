-- Q4: Find the highest-paid employee(s) in each department.
-- If multiple employees share the highest salary, return all of them.

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
