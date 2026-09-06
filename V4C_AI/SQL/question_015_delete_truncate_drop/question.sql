-- Q15: DELETE vs TRUNCATE vs DROP

-- DELETE: removes selected rows (or all rows without WHERE)
DELETE FROM employees
WHERE department_id = 10;

-- TRUNCATE: removes all rows while keeping the table structure
TRUNCATE TABLE employees;

-- DROP: removes the table, including its data and structure
DROP TABLE employees;