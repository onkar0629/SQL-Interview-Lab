-- Q9: Employees With Increasing Salary
-- Find salary records where the current salary is greater than the employee's previous salary.

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
