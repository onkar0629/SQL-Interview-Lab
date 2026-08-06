-- ============================================================================
-- SQL INTERVIEW QUESTION #002
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Snowflake (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Data Warehouse / ETL Validation
-- Estimated Time  : 30-40 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

Last night's ETL pipeline loaded customer orders from the OLTP database into
the Data Warehouse.

This morning, the Finance team reported that the warehouse revenue is lower
than the production system.

As a Data Engineer, your first task is to identify the records that failed
to load into the warehouse.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : source_orders, warehouse_orders

Approx. Rows     : 10 (Sample Dataset)

Primary Key      : order_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS warehouse_orders;
DROP TABLE IF EXISTS source_orders;

CREATE TABLE source_orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE warehouse_orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO source_orders
(order_id, customer_id, order_date, amount)
VALUES
    (101,1,'2024-01-01',500.00),
    (102,2,'2024-01-02',700.00),
    (103,3,'2024-01-03',900.00),
    (104,4,'2024-01-04',400.00),
    (105,5,'2024-01-05',650.00),
    (106,6,'2024-01-06',800.00),
    (107,7,'2024-01-07',350.00),
    (108,8,'2024-01-08',900.00),
    (109,9,'2024-01-09',1000.00),
    (110,10,'2024-01-10',1200.00);

INSERT INTO warehouse_orders
(order_id, customer_id, order_date, amount)
VALUES
    (101,1,'2024-01-01',500.00),
    (102,2,'2024-01-02',700.00),
    (104,4,'2024-01-04',400.00),
    (105,5,'2024-01-05',650.00),
    (107,7,'2024-01-07',350.00),
    (108,8,'2024-01-08',900.00),
    (110,10,'2024-01-10',1200.00);


/*
==============================================================================
INPUT DATA
==============================================================================

source_orders

+----------+-------------+------------+---------+
| order_id | customer_id | order_date | amount  |
+----------+-------------+------------+---------+
| 101      | 1           | 2024-01-01 | 500.00  |
| 102      | 2           | 2024-01-02 | 700.00  |
| 103      | 3           | 2024-01-03 | 900.00  |
| 104      | 4           | 2024-01-04 | 400.00  |
| 105      | 5           | 2024-01-05 | 650.00  |
| 106      | 6           | 2024-01-06 | 800.00  |
| 107      | 7           | 2024-01-07 | 350.00  |
| 108      | 8           | 2024-01-08 | 900.00  |
| 109      | 9           | 2024-01-09 |1000.00  |
| 110      |10           | 2024-01-10 |1200.00  |
+----------+-------------+------------+---------+


warehouse_orders

+----------+-------------+------------+---------+
| order_id | customer_id | order_date | amount  |
+----------+-------------+------------+---------+
| 101      | 1           | 2024-01-01 | 500.00  |
| 102      | 2           | 2024-01-02 | 700.00  |
| 104      | 4           | 2024-01-04 | 400.00  |
| 105      | 5           | 2024-01-05 | 650.00  |
| 107      | 7           | 2024-01-07 | 350.00  |
| 108      | 8           | 2024-01-08 | 900.00  |
| 110      |10           | 2024-01-10 |1200.00  |
+----------+-------------+------------+---------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify every order that exists in **source_orders** but is missing from
**warehouse_orders**.

Return all columns from **source_orders**.

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

Return only those orders that failed to load into the warehouse.

The result should be ordered by `order_id`.

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Assume `order_id` uniquely identifies an order.

2. The warehouse contains millions of rows in production.

3. Write production-quality SQL.

4. Do not modify any data.

5. Return only missing records.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */

SELECT
    s.order_id,
    s.customer_id,
    s.order_date,
    s.amount
FROM source_orders s
         LEFT JOIN warehouse_orders w
                   ON s.order_id = w.order_id
WHERE w.order_id IS NULL
ORDER BY s.order_id;