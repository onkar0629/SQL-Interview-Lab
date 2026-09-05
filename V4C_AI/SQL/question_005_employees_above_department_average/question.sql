-- Q5: Find employees whose salary is greater than their department's average salary.

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
