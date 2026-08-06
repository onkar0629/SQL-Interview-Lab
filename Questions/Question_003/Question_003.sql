-- ============================================================================
-- SQL INTERVIEW QUESTION #003
-- ============================================================================
-- Difficulty      : Medium
-- Company         : Uber (Inspired)
-- SQL Dialect     : MySQL 8.0
-- Business Domain : Ride Sharing
-- Estimated Time  : 25-35 Minutes
-- ============================================================================

/*
==============================================================================
BUSINESS CONTEXT
==============================================================================

The Growth Analytics team wants to identify inactive users.

A rider is considered **inactive** if they have **never booked a ride**.

The Marketing team will use this list to launch a re-engagement campaign.

As a Data Engineer, your task is to generate the list of inactive riders.

==============================================================================
DATA VOLUME
==============================================================================

Table Name       : riders, rides

Approx. Rows     : 15 (Sample Dataset)

Primary Key      : rider_id, ride_id

Foreign Keys     : rides.rider_id → riders.rider_id

NULL Values      : No

Duplicate Rows   : No

==============================================================================
SETUP
==============================================================================
*/

DROP TABLE IF EXISTS rides;
DROP TABLE IF EXISTS riders;

CREATE TABLE riders
(
    rider_id INT PRIMARY KEY,
    rider_name VARCHAR(50) NOT NULL,
    city VARCHAR(30) NOT NULL
);

CREATE TABLE rides
(
    ride_id INT PRIMARY KEY,
    rider_id INT NOT NULL,
    ride_date DATE NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

INSERT INTO riders
(rider_id, rider_name, city)
VALUES
    (1,'Amit','Pune'),
    (2,'Neha','Mumbai'),
    (3,'Rohan','Delhi'),
    (4,'Priya','Bangalore'),
    (5,'Karan','Hyderabad'),
    (6,'Sneha','Chennai'),
    (7,'Rahul','Pune'),
    (8,'Megha','Mumbai');

INSERT INTO rides
(ride_id, rider_id, ride_date, fare)
VALUES
    (101,1,'2024-01-01',220),
    (102,1,'2024-01-10',350),
    (103,2,'2024-01-05',180),
    (104,4,'2024-01-08',420),
    (105,5,'2024-01-15',300),
    (106,5,'2024-01-20',250),
    (107,7,'2024-01-18',190);


/*
==============================================================================
INPUT DATA
==============================================================================

riders

+----------+------------+-----------+
| rider_id | rider_name | city      |
+----------+------------+-----------+
| 1        | Amit       | Pune      |
| 2        | Neha       | Mumbai    |
| 3        | Rohan      | Delhi     |
| 4        | Priya      | Bangalore |
| 5        | Karan      | Hyderabad |
| 6        | Sneha      | Chennai   |
| 7        | Rahul      | Pune      |
| 8        | Megha      | Mumbai    |
+----------+------------+-----------+

rides

+---------+----------+------------+--------+
| ride_id | rider_id | ride_date  | fare   |
+---------+----------+------------+--------+
| 101     | 1        | 2024-01-01 | 220.00 |
| 102     | 1        | 2024-01-10 | 350.00 |
| 103     | 2        | 2024-01-05 | 180.00 |
| 104     | 4        | 2024-01-08 | 420.00 |
| 105     | 5        | 2024-01-15 | 300.00 |
| 106     | 5        | 2024-01-20 | 250.00 |
| 107     | 7        | 2024-01-18 | 190.00 |
+---------+----------+------------+--------+

==============================================================================
PROBLEM STATEMENT
==============================================================================

Identify riders who have **never booked a ride**.

Return:

- rider_id
- rider_name
- city

==============================================================================
EXPECTED OUTPUT DESCRIPTION
==============================================================================

Return only riders who do not have a matching record in the `rides` table.

Sort the result by `rider_id`.

==============================================================================
IMPORTANT CONSTRAINTS
==============================================================================

1. Every rider may have zero, one, or many rides.

2. Do not return riders who have booked at least one ride.

3. Write production-quality SQL.

4. The production `rides` table contains more than 500 million records.

==============================================================================
WRITE YOUR SQL BELOW
==============================================================================

 */

SELECT
    riders.rider_id,
    riders.rider_name,
    riders.city
FROM riders
WHERE rider_id NOT IN
      (
          SELECT rider_id
          FROM rides
          GROUP BY rider_id
      );