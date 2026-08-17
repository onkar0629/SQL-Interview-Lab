-- SQL Interview Lab - Question #012
-- Topic: Incremental ETL Reconciliation
-- Difficulty: Hard
-- SQL Dialect: MySQL 8.0+

CREATE TABLE source_customer_batch (
    customer_id INT,
    batch_date DATE,
    customer_name VARCHAR(100),
    email VARCHAR(150),
    updated_at DATETIME
);

CREATE TABLE warehouse_customer (
    customer_id INT,
    batch_date DATE,
    customer_name VARCHAR(100),
    email VARCHAR(150),
    loaded_at DATETIME
);

INSERT INTO source_customer_batch
(customer_id, batch_date, customer_name, email, updated_at)
VALUES
(101, '2025-08-17', 'Aarav Sharma', 'aarav@example.com', '2025-08-17 08:15:00'),
(102, '2025-08-17', 'Priya Patil', 'priya@example.com', '2025-08-17 08:20:00'),
(103, '2025-08-17', 'Rahul Mehta', 'rahul@example.com', '2025-08-17 08:25:00');

INSERT INTO warehouse_customer
(customer_id, batch_date, customer_name, email, loaded_at)
VALUES
(101, '2025-08-17', 'Aarav Sharma', 'aarav@example.com', '2025-08-17 08:40:00'),
(102, '2025-08-17', 'Priya Patil', 'priya@example.com', '2025-08-17 08:42:00'),
(104, '2025-08-16', 'Neha Joshi', 'neha@example.com', '2025-08-16 08:35:00');

/* INTERVIEW QUESTION
Find all customer records that exist in the source batch for
2025-08-17 but are missing from the warehouse for that same batch date.

Return: customer_id, batch_date, customer_name, email, updated_at

Requirements:
1. Compare using both customer_id and batch_date.
2. Other batch dates must not count as a match.
3. Return only source records missing from the warehouse.
4. Sort by customer_id.
5. Write production-quality SQL.

Expected result: customer 103 only.
*/

-- Candidate solution area
-- TODO: Write your SQL solution here.
