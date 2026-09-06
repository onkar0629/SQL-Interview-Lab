SELECT
    employee_id,
    employee_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        WHEN salary < 50000 THEN 'Low'
    END AS salary_category
FROM employees;