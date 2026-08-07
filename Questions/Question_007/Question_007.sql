-- ============================================================================
-- SQL INTERVIEW QUESTION #007
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Walmart Global Tech (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Inventory Management
-- Estimated Time  : 35-45 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Inventory Operations team wants to identify products that have been
restocked multiple times.

A product is considered frequently restocked if it has been restocked
**3 or more times**.

The report will be used to identify products with high demand and improve
inventory planning.

As a Data Engineer, your task is to generate this report.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : inventory

Approx. Rows     : 15 (Sample Dataset)

Primary Key      : restock_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory
(
    restock_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    restock_date DATE NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO inventory
(restock_id, product_id, warehouse_id, restock_date, quantity)
VALUES
    (101,1,1,'2024-01-01',100),
    (102,1,2,'2024-01-05',120),
    (103,1,1,'2024-01-10',150),

    (104,2,1,'2024-01-03',80),
    (105,2,2,'2024-01-15',90),

    (106,3,1,'2024-01-02',200),
    (107,3,1,'2024-01-08',180),
    (108,3,2,'2024-01-20',250),
    (109,3,2,'2024-01-28',150),

    (110,4,1,'2024-01-07',300),

    (111,5,2,'2024-01-01',70),
    (112,5,2,'2024-01-12',60),
    (113,5,1,'2024-01-18',80),

    (114,6,1,'2024-01-06',500),
    (115,6,1,'2024-01-09',400);


/*
==============================================================================
INPUT DATA
==============================================================================

inventory

+------------+------------+--------------+--------------+----------+
| restock_id | product_id | warehouse_id | restock_date | quantity |
+------------+------------+--------------+--------------+----------+
| 101        | 1          | 1            | 2024-01-01   | 100      |
| 102        | 1          | 2            | 2024-01-05   | 120      |
| 103        | 1          | 1            | 2024-01-10   | 150      |
| 104        | 2          | 1            | 2024-01-03   | 80       |
| 105        | 2          | 2            | 2024-01-15   | 90       |
| 106        | 3          | 1            | 2024-01-02   | 200      |
| 107        | 3          | 1            | 2024-01-08   | 180      |
| 108        | 3          | 2            | 2024-01-20   | 250      |
| 109        | 3          | 2            | 2024-01-28   | 150      |
| 110        | 4          | 1            | 2024-01-07   | 300      |
| 111        | 5          | 2            | 2024-01-01   | 70       |
| 112        | 5          | 2            | 2024-01-12   | 60       |
| 113        | 5          | 1            | 2024-01-18   | 80       |
| 114        | 6          | 1            | 2024-01-06   | 500      |
| 115        | 6          | 1            | 2024-01-09   | 400      |
+------------+------------+--------------+--------------+----------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify products that have been restocked **3 or more times**.

Return the following columns:

- product_id
- total_restocks

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

1. Count all restock events for each product.
2. Return only products with **3 or more** restocks.
3. Sort the result by `product_id`.

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Every row represents one restock event.
2. Count all restocks, regardless of warehouse.
3. Write production-quality SQL.
4. The production table contains billions of inventory records.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================
 */

SELECT
    product_id,
    COUNT(product_id) AS total_restocks
FROM inventory
GROUP BY product_id
HAVING total_restocks >= 3
ORDER BY product_id;