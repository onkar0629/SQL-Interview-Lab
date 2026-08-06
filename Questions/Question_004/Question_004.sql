-- ============================================================================
-- SQL INTERVIEW QUESTION #004
-- ============================================================================
-- Difficulty      : Hard
-- Company         : Microsoft (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Banking
-- Estimated Time  : 30-40 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Fraud Detection team has noticed that some customers perform multiple
transactions within a very short period.

These rapid transactions are flagged for further investigation as they may
indicate suspicious or fraudulent activity.

As a Data Engineer, your task is to identify customers who made two or more
transactions on the **same day**.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : transactions

Approx. Rows     : 12 (Sample Dataset)

Primary Key      : transaction_id

Foreign Keys     : None

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions
(
    transaction_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO transactions
(transaction_id, customer_id, transaction_date, amount)
VALUES
    (101,1,'2024-01-01',500),
    (102,1,'2024-01-01',300),
    (103,1,'2024-01-05',250),

    (104,2,'2024-01-02',800),

    (105,3,'2024-01-03',400),
    (106,3,'2024-01-03',600),
    (107,3,'2024-01-03',200),

    (108,4,'2024-01-04',900),

    (109,5,'2024-01-05',100),
    (110,5,'2024-01-06',150),

    (111,6,'2024-01-07',500),
    (112,6,'2024-01-07',700);


/*
==============================================================================
INPUT DATA
==============================================================================

transactions

+----------------+-------------+------------------+---------+
| transaction_id | customer_id | transaction_date | amount  |
+----------------+-------------+------------------+---------+
| 101            | 1           | 2024-01-01       | 500.00  |
| 102            | 1           | 2024-01-01       | 300.00  |
| 103            | 1           | 2024-01-05       | 250.00  |
| 104            | 2           | 2024-01-02       | 800.00  |
| 105            | 3           | 2024-01-03       | 400.00  |
| 106            | 3           | 2024-01-03       | 600.00  |
| 107            | 3           | 2024-01-03       | 200.00  |
| 108            | 4           | 2024-01-04       | 900.00  |
| 109            | 5           | 2024-01-05       | 100.00  |
| 110            | 5           | 2024-01-06       | 150.00  |
| 111            | 6           | 2024-01-07       | 500.00  |
| 112            | 6           | 2024-01-07       | 700.00  |
+----------------+-------------+------------------+---------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify customers who made **two or more transactions on the same day**.

Return the following columns:

- customer_id
- transaction_date
- total_transactions

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

Return one row for each customer and transaction date where the customer
made at least **2 transactions**.

Sort the result by:

1. customer_id
2. transaction_date

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Count only transactions made on the same calendar date.

2. Ignore customers who made only one transaction on a given day.

3. Write production-quality SQL.

4. The production table contains billions of transactions.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================

 */

SELECT
    customer_id,
    transaction_date,
    COUNT(transaction_date) AS `Total Transactions`
FROM transactions
GROUP BY customer_id, transaction_date
HAVING COUNT(transaction_date) >= 2;