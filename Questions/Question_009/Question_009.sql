-- ============================================================================
-- SQL INTERVIEW QUESTION #009
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

The Customer Analytics team wants to identify each customer's most recent
purchase.

This report is used to power personalized recommendations, customer
segmentation, and re-engagement campaigns.

As a Data Engineer, your task is to retrieve the latest order placed by
every customer.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : orders

Approx. Rows     : 14 (Sample Dataset)

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
    (102,1,'2024-02-15',350.00),
    (103,1,'2024-04-10',800.00),

    (104,2,'2024-01-20',600.00),
    (105,2,'2024-03-18',900.00),

    (106,3,'2024-02-05',400.00),

    (107,4,'2024-01-12',200.00),
    (108,4,'2024-02-28',700.00),
    (109,4,'2024-05-01',950.00),

    (110,5,'2024-01-25',300.00),
    (111,5,'2024-02-14',450.00),

    (112,6,'2024-03-01',1000.00),
    (113,6,'2024-03-20',1200.00),
    (114,6,'2024-04-15',1500.00);

/*
==============================================================================
INPUT DATA
==============================================================================

orders

+----------+-------------+------------+---------+
| order_id | customer_id | order_date | amount  |
+----------+-------------+------------+---------+
| 101      | 1           | 2024-01-01 | 500.00  |
| 102      | 1           | 2024-02-15 | 350.00  |
| 103      | 1           | 2024-04-10 | 800.00  |
| 104      | 2           | 2024-01-20 | 600.00  |
| 105      | 2           | 2024-03-18 | 900.00  |
| 106      | 3           | 2024-02-05 | 400.00  |
| 107      | 4           | 2024-01-12 | 200.00  |
| 108      | 4           | 2024-02-28 | 700.00  |
| 109      | 4           | 2024-05-01 | 950.00  |
| 110      | 5           | 2024-01-25 | 300.00  |
| 111      | 5           | 2024-02-14 | 450.00  |
| 112      | 6           | 2024-03-01 | 1000.00 |
| 113      | 6           | 2024-03-20 | 1200.00 |
| 114      | 6           | 2024-04-15 | 1500.00 |
+----------+-------------+------------+---------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Return the most recent order placed by each customer.

Return the following columns:

- customer_id
- order_id
- order_date
- amount

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Return exactly one row for each customer.
2. The row must represent the latest order.
3. Sort the result by `customer_id`.

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Every customer can place multiple orders.
2. The latest order is determined by `order_date`.
3. Assume there are no duplicate order dates for the same customer.
4. Write production-quality SQL.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */
 select