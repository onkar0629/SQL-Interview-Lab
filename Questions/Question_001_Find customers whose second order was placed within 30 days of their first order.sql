-- ============================================================================
-- SQL INTERVIEW QUESTION #001
-- ============================================================================
-- Difficulty      : Medium
-- Company         : Amazon (Inspired)
-- Business Domain : E-Commerce
-- Estimated Time  : 20-30 Minutes
-- ============================================================================

/*
BUSINESS CONTEXT

Your company's Product team has launched a dashboard to measure customer
engagement.

During a weekly business review, the Product Manager asks:

"How many customers placed their SECOND order within 30 days of their FIRST
order?"

This KPI is used to measure customer retention and evaluate how quickly new
customers return to place another order.

As a Data Engineer, your task is to generate this report for the Analytics team.

------------------------------------------------------------------------------
TABLE
------------------------------------------------------------------------------

orders

+--------------+---------------+
| Column Name  | Data Type     |
+--------------+---------------+
| order_id     | INT           |
| customer_id  | INT           |
| order_date   | DATE          |
| amount       | DECIMAL(10,2) |
+--------------+---------------+

------------------------------------------------------------------------------
SAMPLE DATA
------------------------------------------------------------------------------

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

------------------------------------------------------------------------------
PROBLEM STATEMENT
------------------------------------------------------------------------------

Identify customers whose SECOND order was placed within 30 days of
their FIRST order.

Return:

- customer_id
- first_order_date
- second_order_date
- days_between_orders

------------------------------------------------------------------------------
EXPECTED OUTPUT
------------------------------------------------------------------------------

Return one row for each qualifying customer.

Only compare the customer's FIRST and SECOND orders.

Ignore the third, fourth, or later orders.

------------------------------------------------------------------------------
IMPORTANT CONSTRAINTS
------------------------------------------------------------------------------

1. Each customer can place multiple orders.

2. Some customers may have only one order.

3. Compare ONLY the first two orders for each customer.

4. Include customers whose second order is exactly 30 days after
   the first order.

5. Return the result ordered by customer_id.
------------------------------------------------------------------------------
 */

