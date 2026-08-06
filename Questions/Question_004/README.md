# SQL Interview Question #004

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Microsoft-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Banking-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Fraud Detection team monitors customer transactions to identify suspicious activity.
>
> One common fraud indicator is multiple transactions performed by the same customer on the same day.
>
> As a Data Engineer, your task is to identify customers who made **two or more transactions on the same calendar day**.
>
> ### Problem Statement
>
> Return the following columns:
>
> * `customer_id`
> * `transaction_date`
> * `total_transactions`
>
> ### Expected Output
>
> Return one row for every customer and transaction date where the customer made **2 or more transactions**.
>
> Sort the result by:
>
> * `customer_id`
> * `transaction_date`
>
> ### Constraints
>
> * Count only transactions made on the same calendar date.
> * Ignore customers with only one transaction on a given day.
> * Write production-quality SQL.
> * The production table contains billions of records.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Group transactions by customer and transaction date.
> * Count the number of transactions in each group.
> * Keep only groups having at least two transactions.
> * Return the final result in sorted order.

---

# My Solution

```sql
-- Step 1: Group transactions by customer and transaction date
SELECT

    customer_id,

    transaction_date,

    -- Count the number of transactions made on the same day
    COUNT(*) AS total_transactions

FROM transactions

GROUP BY

    customer_id,

    transaction_date

-- Step 2: Keep only customers with two or more transactions
HAVING COUNT(*) >= 2

-- Step 3: Return the result in sorted order
ORDER BY

    customer_id,

    transaction_date;
```

> [!TIP]
> **Interview Note**
>
> The initial solution used `HAVING COUNT(transaction_date) > 2`.
>
> During the interview review, this was corrected to `HAVING COUNT(*) >= 2` because:
>
> * The requirement is **two or more** transactions.
> * `COUNT(*)` is generally preferred when counting rows.
> * `transaction_date` is defined as `NOT NULL`, so both produce the same result for this dataset.

---

# Expected Output

| customer_id | transaction_date | total_transactions |
| ----------: | ---------------- | -----------------: |
|           1 | 2024-01-01       |                  2 |
|           3 | 2024-01-03       |                  3 |
|           6 | 2024-01-07       |                  2 |

---

# Most Optimal Solution

```sql id="d6m9qv"
-- Step 1: Group transactions by customer and transaction date
SELECT

    customer_id,

    transaction_date,

    -- Count all transactions within each group
    COUNT(*) AS total_transactions

FROM transactions

GROUP BY

    customer_id,

    transaction_date

-- Step 2: Keep only groups having two or more transactions
HAVING COUNT(*) >= 2

-- Step 3: Return the final result
ORDER BY

    customer_id,

    transaction_date;
```

---

# Alternative Approach 1 — Common Table Expression (CTE)

```sql id="hzg42m"
-- Step 1: Calculate the number of transactions
-- for each customer on each day
WITH daily_transactions AS
(
    SELECT

        customer_id,

        transaction_date,

        COUNT(*) AS total_transactions

    FROM transactions

    GROUP BY

        customer_id,

        transaction_date
)

-- Step 2: Return only customers having
-- two or more transactions
SELECT

    customer_id,

    transaction_date,

    total_transactions

FROM daily_transactions

WHERE total_transactions >= 2

ORDER BY

    customer_id,

    transaction_date;
```

---

# Alternative Approach 2 — Window Function

```sql id="f84xrn"
-- Step 1: Count transactions for every customer
-- on each transaction date
WITH transaction_counts AS
(
    SELECT

        customer_id,

        transaction_date,

        COUNT(*) OVER
        (
            PARTITION BY customer_id, transaction_date
        ) AS total_transactions

    FROM transactions
)

-- Step 2: Return one row per customer/date
SELECT DISTINCT

    customer_id,

    transaction_date,

    total_transactions

FROM transaction_counts

-- Step 3: Keep only qualifying groups
WHERE total_transactions >= 2

ORDER BY

    customer_id,

    transaction_date;
```

---

> [!IMPORTANT]
>
> ## Why This Approach?
>
> ### My Solution
>
> **Strengths**
>
> * Simple and easy to understand.
> * Uses standard SQL aggregation.
> * Efficient for grouped summary reports.
>
> **Best suited when**
>
> * You only need aggregated results.
>
> ---
>
> ### Most Optimal Solution
>
> **Strengths**
>
> * Uses the simplest execution plan.
> * Easy to maintain.
> * Highly optimized by database engines.
>
> **Best suited when**
>
> * Producing grouped reports.
> * Fraud detection summaries.
> * Daily analytics dashboards.
>
> ---
>
> ### Alternative Approaches
>
> **CTE**
>
> * Improves readability.
> * Useful for multi-step ETL pipelines.
>
> **Window Function**
>
> * Best when detailed transaction rows are also required.
> * Avoids regrouping later in the query.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_transactions_customer_date
> ON transactions(customer_id, transaction_date);
> ```
>
> **Why?**
>
> * Optimizes grouping operations.
> * Reduces sorting overhead.
> * Improves aggregation performance on very large tables.
>
> **Time Complexity**
>
> Approximately **O(N)** with appropriate indexing.
>
> **Space Complexity**
>
> Depends on the aggregation strategy used by the query engine.
>
> **Production Notes**
>
> * Use `COUNT(*)` when counting rows.
> * If transaction timestamps exist instead of dates, truncate them to the required granularity before grouping.
> * Always verify execution plans (`EXPLAIN`) on large production tables.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `>` instead of `>=`.
> * Forgetting to group by both `customer_id` and `transaction_date`.
> * Using `COUNT(column)` without understanding `NULL` behavior.
> * Returning unnecessary columns.
> * Choosing a window function when a simple aggregation is sufficient.

---

> [!TIP]
>
> ## Follow-up Variations
>
> 1. Return **all transaction details** for customers with two or more transactions on the same day.
> 2. Find customers who made transactions on **three consecutive days**.
> 3. Calculate the **total amount** spent by customers with multiple same-day transactions.
> 4. Identify customers with the **highest number of same-day transactions**.
> 5. Detect customers whose same-day transaction count increased compared to the previous day.

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This problem reinforces one of the most common SQL interview patterns: **aggregation with `GROUP BY` and `HAVING`**. It also introduces an important design decision—knowing when simple aggregation is sufficient and when a **window function** is more appropriate because detailed row-level output is required.
