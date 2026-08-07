-- ============================================================================
-- SQL INTERVIEW QUESTION #005
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Amazon (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : E-Commerce
-- Estimated Time  : 35-45 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Product Analytics team wants to identify the **best-selling products**
for each category.

The dashboard should display only the product(s) with the highest total
sales amount within every category.

If multiple products have the same highest sales amount in a category,
all of them should be returned.

As a Data Engineer, your task is to build this report.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : sales

Approx. Rows     : 15 (Sample Dataset)

Primary Key      : sale_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS sales;

CREATE TABLE sales
(
    sale_id INT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    sale_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO sales
(sale_id, category, product_name, sale_amount)
VALUES
    (101,'Electronics','Laptop',1000),
    (102,'Electronics','Laptop',800),
    (103,'Electronics','Mobile',1200),
    (104,'Electronics','Mobile',600),
    (105,'Electronics','Tablet',500),

    (106,'Furniture','Chair',400),
    (107,'Furniture','Chair',300),
    (108,'Furniture','Table',900),
    (109,'Furniture','Table',200),
    (110,'Furniture','Sofa',1100),

    (111,'Clothing','T-Shirt',250),
    (112,'Clothing','T-Shirt',250),
    (113,'Clothing','Jeans',500),
    (114,'Clothing','Jacket',700),
    (115,'Clothing','Jacket',300);


/*
==============================================================================
INPUT DATA
==============================================================================

sales

+---------+--------------+--------------+-------------+
| sale_id | category     | product_name | sale_amount |
+---------+--------------+--------------+-------------+
| 101     | Electronics  | Laptop       | 1000.00     |
| 102     | Electronics  | Laptop       | 800.00      |
| 103     | Electronics  | Mobile       | 1200.00     |
| 104     | Electronics  | Mobile       | 600.00      |
| 105     | Electronics  | Tablet       | 500.00      |
| 106     | Furniture    | Chair        | 400.00      |
| 107     | Furniture    | Chair        | 300.00      |
| 108     | Furniture    | Table        | 900.00      |
| 109     | Furniture    | Table        | 200.00      |
| 110     | Furniture    | Sofa         | 1100.00     |
| 111     | Clothing     | T-Shirt      | 250.00      |
| 112     | Clothing     | T-Shirt      | 250.00      |
| 113     | Clothing     | Jeans        | 500.00      |
| 114     | Clothing     | Jacket       | 700.00      |
| 115     | Clothing     | Jacket       | 300.00      |
+---------+--------------+--------------+-------------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Find the **best-selling product(s)** in each category.

Return the following columns:

- category
- product_name
- total_sales

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Calculate the total sales for each product.
2. Return only the product(s) having the **highest total sales** within each category.
3. If multiple products tie for the highest sales, return all of them.
4. Sort the result by:
   - category
   - product_name

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Multiple sales can exist for the same product.
2. Products must first be aggregated before ranking.
3. Handle ties correctly.
4. Write production-quality SQL.
5. The production table contains hundreds of millions of sales records.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================

 */

select category,
       product_name,
       sum(sale_amount) AS Total_sales
from sales
group by category,
         product_name
order by
    Total_sales DESC ;

with cte AS (
    select category,
           product_name,
           sum(sale_amount) AS Total_sales,
           dense_rank() over (partition by category order by sum(sale_amount) DESC) rn
    from sales
    group by category,
             product_name
)
select category,
       product_name,
       Total_sales
from cte
where rn = 1;