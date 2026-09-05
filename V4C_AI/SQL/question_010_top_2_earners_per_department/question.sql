-- Q10: Top 2 Earners Per Department
-- Find the top 2 highest-paid employees in each department, including ties.

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
