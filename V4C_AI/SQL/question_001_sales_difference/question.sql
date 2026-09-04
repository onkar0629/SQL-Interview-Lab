-- V4C.ai Interview Question 1
-- Calculate today's sales minus the previous day's sales for each employee.

WITH sales_with_previous AS (
    SELECT
        employee_id,
        sale_date,
        sales_amount,
        LAG(sales_amount) OVER (
            PARTITION BY employee_id
            ORDER BY sale_date
        ) AS previous_sales
    FROM sales
)
SELECT
    employee_id,
    sale_date,
    sales_amount,
    previous_sales,
    sales_amount - previous_sales AS sales_difference
FROM sales_with_previous;
