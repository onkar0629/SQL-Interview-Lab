-- ============================================================================
-- SQL INTERVIEW QUESTION #008
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Microsoft (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Human Resources
-- Estimated Time  : 35-45 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The HR Analytics team wants to identify employees who have received salary
increments over time.

An employee is considered to have received a salary increment if their current
salary is greater than their previous recorded salary.

The report will be used to verify payroll updates and identify salary growth
patterns.

As a Data Engineer, your task is to identify every salary increment event.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : employee_salary

Approx. Rows     : 14 (Sample Dataset)

Primary Key      : record_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS employee_salary;

CREATE TABLE employee_salary
(
    record_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL
);

INSERT INTO employee_salary
(record_id, employee_id, salary, effective_date)
VALUES
    (101,1,50000,'2024-01-01'),
    (102,1,55000,'2024-04-01'),
    (103,1,60000,'2024-07-01'),

    (104,2,70000,'2024-01-01'),
    (105,2,68000,'2024-05-01'),

    (106,3,45000,'2024-02-01'),

    (107,4,80000,'2024-01-01'),
    (108,4,82000,'2024-03-01'),
    (109,4,82000,'2024-06-01'),

    (110,5,60000,'2024-01-15'),
    (111,5,65000,'2024-02-15'),
    (112,5,63000,'2024-03-15'),
    (113,5,70000,'2024-05-15'),

    (114,6,90000,'2024-01-01');


/*
==============================================================================
INPUT DATA
==============================================================================

employee_salary

+-----------+-------------+----------+----------------+
| record_id | employee_id | salary   | effective_date |
+-----------+-------------+----------+----------------+
| 101       | 1           | 50000    | 2024-01-01     |
| 102       | 1           | 55000    | 2024-04-01     |
| 103       | 1           | 60000    | 2024-07-01     |
| 104       | 2           | 70000    | 2024-01-01     |
| 105       | 2           | 68000    | 2024-05-01     |
| 106       | 3           | 45000    | 2024-02-01     |
| 107       | 4           | 80000    | 2024-01-01     |
| 108       | 4           | 82000    | 2024-03-01     |
| 109       | 4           | 82000    | 2024-06-01     |
| 110       | 5           | 60000    | 2024-01-15     |
| 111       | 5           | 65000    | 2024-02-15     |
| 112       | 5           | 63000    | 2024-03-15     |
| 113       | 5           | 70000    | 2024-05-15     |
| 114       | 6           | 90000    | 2024-01-01     |
+-----------+-------------+----------+----------------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify every salary increment event.

Return the following columns:

- employee_id
- previous_salary
- current_salary
- effective_date

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Compare each salary with the employee's immediately previous salary.
2. Return only records where the salary increased.
3. Ignore the employee's first salary record.
4. Sort the result by:
   - employee_id
   - effective_date

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Every employee can have multiple salary records.
2. Compare only consecutive salary records.
3. Equal salaries are NOT increments.
4. Salary decreases should not be returned.
5. Write production-quality SQL.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */

WITH salary_history AS
         (
             SELECT
                 employee_id,
                 LAG(salary) OVER
                     (
                     PARTITION BY employee_id
                     ORDER BY effective_date
                     ) AS previous_salary,
                 salary AS current_salary,
                 effective_date
             FROM employee_salary
         )

SELECT
    employee_id,
    previous_salary,
    current_salary,
    effective_date
FROM salary_history
WHERE previous_salary IS NOT NULL
  AND current_salary > previous_salary
ORDER BY
    employee_id,
    effective_date;