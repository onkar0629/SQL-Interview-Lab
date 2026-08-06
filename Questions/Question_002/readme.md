# SQL Interview Question #002

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Snowflake-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-ETL%20Validation-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> Last night's ETL pipeline loaded customer orders from the OLTP database into the Data Warehouse.
>
> This morning, the Finance team reported that the warehouse revenue is lower than the production system.
>
> As a Data Engineer, your task is to identify the records that failed to load into the warehouse.
>
> ### Problem Statement
>
> Identify every order that exists in **`source_orders`** but is missing from **`warehouse_orders`**.
>
> Return **all columns** from `source_orders`.
>
> ### Expected Output
>
> Return only those orders that failed to load into the warehouse.
>
> The final result should be ordered by **order_id**.
>
> ### Constraints
>
> * `order_id` uniquely identifies an order.
> * The warehouse contains millions of rows in production.
> * Do not modify any data.
> * Write production-quality SQL.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Treat this as an **ETL reconciliation** problem.
> * Compare the source table with the warehouse table.
> * Find records that exist in the source but not in the warehouse.
> * Return only the missing records.

---

# My Solution

```sql
-- Step 1: Retrieve all records from the source table
SELECT

    s.order_id,

    s.customer_id,

    s.order_date,

    s.amount

FROM source_orders s

-- Step 2: Find matching records in the warehouse
LEFT JOIN warehouse_orders w
ON s.order_id = w.order_id

-- Step 3: Keep only orders that are missing
-- from the warehouse
WHERE w.order_id IS NULL

-- Step 4: Return the result in ascending order
ORDER BY s.order_id;
```

---

# Expected Output

| order_id | customer_id | order_date |  amount |
| -------: | ----------: | ---------- | ------: |
|      103 |           3 | 2024-01-03 |  900.00 |
|      106 |           6 | 2024-01-06 |  800.00 |
|      109 |           9 | 2024-01-09 | 1000.00 |

---

# Most Optimal Solution

```sql
-- Step 1: Return records from the source table
SELECT

    s.order_id,

    s.customer_id,

    s.order_date,

    s.amount

FROM source_orders s

-- Step 2: Keep only records that do not exist
-- in the warehouse table
WHERE NOT EXISTS
(
    SELECT 1

    FROM warehouse_orders w

    WHERE w.order_id = s.order_id
)

-- Step 3: Return the result in ascending order
ORDER BY s.order_id;
```

---

# Alternative Approach 1 — LEFT JOIN + IS NULL

```sql
-- Step 1: Read all records from the source table
SELECT

    s.order_id,

    s.customer_id,

    s.order_date,

    s.amount

FROM source_orders s

-- Step 2: Attempt to match every source record
-- with the warehouse table
LEFT JOIN warehouse_orders w
ON s.order_id = w.order_id

-- Step 3: Keep only records that were not matched
WHERE w.order_id IS NULL

-- Step 4: Sort the output
ORDER BY s.order_id;
```

---

# Alternative Approach 2 — NOT IN

```sql
-- Step 1: Read all records from the source table
SELECT

    order_id,

    customer_id,

    order_date,

    amount

FROM source_orders

-- Step 2: Remove records that already exist
-- in the warehouse
WHERE order_id NOT IN
(
    SELECT order_id
    FROM warehouse_orders
)

-- Step 3: Return the result
ORDER BY order_id;
```

> [!WARNING]
> `NOT IN` should only be used when you're certain the subquery cannot return `NULL`. If `NULL` values are possible, `NOT EXISTS` is generally the safer choice.

---

> [!IMPORTANT]
>
> ## Why This Approach?
>
> ### My Solution (LEFT JOIN + IS NULL)
>
> **Strengths**
>
> * Very readable.
> * Easy to explain during interviews.
> * Widely used for ETL reconciliation.
>
> **Best suited when**
>
> * Comparing two datasets.
> * Performing reconciliation between source and target tables.
>
> ---
>
> ### Most Optimal Solution (NOT EXISTS)
>
> **Strengths**
>
> * Clearly expresses an anti-join.
> * Avoids issues associated with `NOT IN` and `NULL` values.
> * Commonly preferred for production code.
>
> **Best suited when**
>
> * Working with large datasets.
> * Validating ETL loads.
> * Writing production-quality SQL.
>
> ---
>
> ### Alternative Approach (NOT IN)
>
> **Strengths**
>
> * Concise and easy to write.
>
> **Limitations**
>
> * Can produce unexpected results if the subquery contains `NULL`.
> * Less commonly recommended for production ETL validation.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_source_orders_order_id
> ON source_orders(order_id);
>
> CREATE INDEX idx_warehouse_orders_order_id
> ON warehouse_orders(order_id);
> ```
>
> **Why?**
>
> * Speeds up join and lookup operations.
> * Reduces the number of scanned rows.
> * Improves ETL reconciliation performance.
>
> **Time Complexity**
>
> Approximately **O(N)** with appropriate indexing.
>
> **Space Complexity**
>
> **O(1)** (excluding execution engine internals).
>
> **Production Notes**
>
> * If `order_id` is already the primary key, an additional index is unnecessary.
> * Ensure uniqueness on business keys to prevent data quality issues.
> * For very large reconciliation jobs, consider processing incrementally rather than scanning the entire dataset.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `INNER JOIN` instead of an anti-join.
> * Returning records from the warehouse instead of the source.
> * Using `NOT IN` without considering `NULL` values.
> * Selecting only `order_id` when the question asks for all columns.
> * Forgetting to order the final result.
> * Ignoring existing indexes or primary keys.

---

> [!TIP]
>
> ## Follow-up Variations
>
> 1. Find records that exist in the warehouse but not in the source.
> 2. Find records where `amount` differs between the two tables.
> 3. Find records where `order_date` differs between the two tables.
> 4. Count the number of missing records instead of returning them.
> 5. Build a reconciliation report showing **Matched**, **Missing in Warehouse**, and **Missing in Source** records.

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question evaluates your understanding of **anti-joins**, a fundamental pattern in Data Engineering for **ETL validation**, **data reconciliation**, and **pipeline quality checks**. Interviewers are often looking not just for the correct SQL, but also for your ability to choose the most appropriate anti-join strategy (`LEFT JOIN ... IS NULL` vs. `NOT EXISTS`) and explain the trade-offs in a production environment.
