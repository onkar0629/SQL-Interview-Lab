-- ============================================================================
-- SQL INTERVIEW QUESTION #001
-- ============================================================================
-- Difficulty      : Medium
-- Company         : Amazon (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : E-Commerce
-- Estimated Time  : 20-30 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Product Analytics team wants to measure customer retention.

One of the KPIs displayed on the executive dashboard is:

"Customers whose SECOND order was placed within 30 days of their FIRST order."

As a Data Engineer, your task is to generate this report for the Analytics team.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : orders

Approx. Rows     : 11 (Sample Dataset)

Primary Key      : order_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders
(order_id, customer_id, order_date, amount)
VALUES
    (101,1,'2024-01-01',500.00),
    (102,1,'2024-01-20',350.00),
    (103,1,'2024-03-15',700.00),

    (104,2,'2024-02-10',200.00),
    (105,2,'2024-04-15',450.00),

    (106,3,'2024-01-05',800.00),

    (107,4,'2024-02-01',150.00),
    (108,4,'2024-02-25',300.00),

    (109,5,'2024-03-10',900.00),
    (110,5,'2024-03-30',400.00),
    (111,5,'2024-04-10',250.00);


/*
==============================================================================
INPUT DATA
==============================================================================

orders

+----------+-------------+------------+---------+
| order_id | customer_id | order_date | amount  |
+----------+-------------+------------+---------+
| 101      | 1           | 2024-01-01 | 500.00  |
| 102      | 1           | 2024-01-20 | 350.00  |
| 103      | 1           | 2024-03-15 | 700.00  |
| 104      | 2           | 2024-02-10 | 200.00  |
| 105      | 2           | 2024-04-15 | 450.00  |
| 106      | 3           | 2024-01-05 | 800.00  |
| 107      | 4           | 2024-02-01 | 150.00  |
| 108      | 4           | 2024-02-25 | 300.00  |
| 109      | 5           | 2024-03-10 | 900.00  |
| 110      | 5           | 2024-03-30 | 400.00  |
| 111      | 5           | 2024-04-10 | 250.00  |
+----------+-------------+------------+---------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify customers whose SECOND order was placed within 30 days of their
FIRST order.

Return the following columns:

- customer_id
- first_order_date
- second_order_date
- days_between_orders

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

Return one row for each qualifying customer.

- Compare only the FIRST and SECOND orders.
- Ignore the third, fourth, or later orders.
- Include customers whose second order is exactly 30 days after the first.
- Return the final result ordered by customer_id.

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. A customer can place multiple orders.

2. Some customers may have only one order.

3. Compare ONLY the first and second orders.

4. Write production-quality SQL.

5. Think about deterministic ordering for production systems.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================

 */

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date
            ) AS rn
    FROM orders
),
     first_second_orders AS (
         SELECT
             customer_id,
             MAX(CASE WHEN rn = 1 THEN order_date END) AS first_order_date,
             MAX(CASE WHEN rn = 2 THEN order_date END) AS second_order_date
         FROM ranked_orders
         WHERE rn IN (1, 2)
         GROUP BY customer_id
     )

SELECT
    customer_id,
    first_order_date,
    second_order_date,
    DATEDIFF(second_order_date, first_order_date) AS days_between_orders
FROM first_second_orders
WHERE second_order_date IS NOT NULL
  AND DATEDIFF(second_order_date, first_order_date) <= 30
ORDER BY customer_id;