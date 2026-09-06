SELECT
    employee_id,
    employee_name,
    salary,
    bonus,
    salary + COALESCE(bonus, 0) AS total_compensation
FROM employees;