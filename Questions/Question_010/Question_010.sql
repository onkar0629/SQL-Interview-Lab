-- ============================================================================
-- SQL INTERVIEW QUESTION #010
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Google (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : E-Commerce
-- Estimated Time  : 35-45 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Sales Analytics team wants to identify the highest-value order placed
by each customer.

The report is used to identify high-value customers and personalize
customer engagement strategies.

As a Data Engineer, your task is to identify the highest-value order
for every customer.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : customer_orders

Approx. Rows     : 15 (Sample Dataset)

Primary Key      : order_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS customer_orders;

CREATE TABLE customer_orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO customer_orders
(order_id, customer_id, order_date, amount)
VALUES
    (101,1,'2024-01-05',500.00),
    (102,1,'2024-02-10',900.00),
    (103,1,'2024-03-15',700.00),

    (104,2,'2024-01-10',1200.00),
    (105,2,'2024-02-20',1200.00),

    (106,3,'2024-01-12',450.00),

    (107,4,'2024-01-05',800.00),
    (108,4,'2024-02-15',1500.00),
    (109,4,'2024-03-20',1100.00),

    (110,5,'2024-01-08',600.00),
    (111,5,'2024-02-18',950.00),
    (112,5,'2024-03-25',950.00),

    (113,6,'2024-01-15',2000.00),
    (114,6,'2024-02-15',1800.00),
    (115,6,'2024-03-15',2000.00);


/*
==============================================================================
INPUT DATA
==============================================================================

customer_orders

+----------+-------------+------------+---------+
| order_id | customer_id | order_date | amount  |
+----------+-------------+------------+---------+
| 101      | 1           | 2024-01-05 | 500.00  |
| 102      | 1           | 2024-02-10 | 900.00  |
| 103      | 1           | 2024-03-15 | 700.00  |
| 104      | 2           | 2024-01-10 | 1200.00 |
| 105      | 2           | 2024-02-20 | 1200.00 |
| 106      | 3           | 2024-01-12 | 450.00  |
| 107      | 4           | 2024-01-05 | 800.00  |
| 108      | 4           | 2024-02-15 | 1500.00 |
| 109      | 4           | 2024-03-20 | 1100.00 |
| 110      | 5           | 2024-01-08 | 600.00  |
| 111      | 5           | 2024-02-18 | 950.00  |
| 112      | 5           | 2024-03-25 | 950.00  |
| 113      | 6           | 2024-01-15 | 2000.00 |
| 114      | 6           | 2024-02-15 | 1800.00 |
| 115      | 6           | 2024-03-15 | 2000.00 |
+----------+-------------+------------+---------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify the highest-value order for each customer.

Return:

- customer_id
- order_id
- order_date
- amount

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Find the maximum order amount for each customer.
2. Return the order record(s) having that maximum amount.
3. If multiple orders have the same maximum amount, return ALL tied orders.
4. Sort the result by:
   - customer_id
   - order_id

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. A customer may have multiple orders.
2. Multiple orders can have the same maximum amount.
3. All tied highest-value orders must be returned.
4. Do not return lower-value orders.
5. Write production-quality SQL.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */

with cte as(
select customer_id,
       order_id,
       order_date,
       amount,
       dense_rank() over (partition by customer_id order by amount DESC) rn
from customer_orders)
select customer_id,
       order_id,
       order_date,
       amount
from cte
where rn = 1;
