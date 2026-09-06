SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
WHERE salary > 30000
GROUP BY department_id
HAVING AVG(salary) > 50000;