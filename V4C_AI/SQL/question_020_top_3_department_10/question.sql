SELECT
    employee_id,
    employee_name,
    salary
FROM employees
WHERE department_id = 10
ORDER BY salary DESC
LIMIT 3;