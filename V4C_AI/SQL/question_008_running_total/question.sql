-- Q8: Running Total
-- Calculate cumulative sales for each employee ordered by sale date.

SELECT employee_id,
       sale_date,
       sales_amount,
       SUM(sales_amount) OVER (
           PARTITION BY employee_id
           ORDER BY sale_date
       ) AS cumulative_sum
FROM sales;
