# SQL Interview Question #007

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Walmart%20Global%20Tech-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Inventory%20Management-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Inventory Operations team wants to identify products that require frequent restocking.
>
> A product is considered **frequently restocked** if it has been restocked **3 or more times**.
>
> This report helps the business identify high-demand products and improve inventory planning.
>
> ### Problem Statement
>
> Identify products that have been **restocked 3 or more times**.
>
> Return the following columns:
>
> * `product_id`
> * `total_restocks`
>
> ### Expected Output
>
> * Count every restock event.
> * Ignore the warehouse while counting.
> * Return only products with **3 or more** restock events.
> * Sort the result by `product_id`.
>
> ### Constraints
>
> * Every row represents one restock event.
> * Count all restocks, regardless of warehouse.
> * Write production-quality SQL.
> * The production table contains billions of inventory records.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Group inventory records by `product_id`.
> * Count the total number of restock events.
> * Filter products having **3 or more** restocks.
> * Sort the final result by `product_id`.

---

# My Solution

```sql
-- Step 1: Group inventory records by product
SELECT

    product_id,

    -- Count every restock event
    COUNT(*) AS total_restocks

FROM inventory

GROUP BY

    product_id

-- Step 2: Keep only products
-- having three or more restocks
HAVING COUNT(*) >= 3

-- Step 3: Sort the final result
ORDER BY

    product_id;
```

> [!TIP]
> **Interview Note**
>
> The key business requirement is:
>
> > **Count every restock event, regardless of warehouse.**
>
> Since every row represents one restock event, `COUNT(*)` is the most appropriate aggregation.
>
> Although `COUNT(product_id)` also works because `product_id` is `NOT NULL`, `COUNT(*)` is generally preferred in production because it clearly expresses the intent to count all rows.
>
> Using `COUNT(DISTINCT warehouse_id)` would answer a different business question:
>
> **"In how many different warehouses was the product restocked?"**

---

# Expected Output

| product_id | total_restocks |
| ---------: | -------------: |
|          1 |              3 |
|          3 |              4 |
|          5 |              3 |

---

# Most Optimal Solution

```sql
-- Step 1: Group inventory records by product
SELECT

    product_id,

    -- Count every restock event
    COUNT(*) AS total_restocks

FROM inventory

GROUP BY

    product_id

-- Step 2: Return only frequently restocked products
HAVING COUNT(*) >= 3

-- Step 3: Sort the final result
ORDER BY

    product_id;
```

---

# Alternative Approach 1 — Common Table Expression (CTE)

```sql
-- Step 1: Calculate total restocks for each product
WITH restock_summary AS
(
    SELECT

        product_id,

        COUNT(*) AS total_restocks

    FROM inventory

    GROUP BY

        product_id
)

-- Step 2: Return only qualifying products
SELECT

    product_id,

    total_restocks

FROM restock_summary

WHERE total_restocks >= 3

ORDER BY

    product_id;
```

---

# Alternative Approach 2 — Subquery

```sql
-- Step 1: Calculate total restocks for each product
SELECT

    product_id,

    total_restocks

FROM
(
    SELECT

        product_id,

        COUNT(*) AS total_restocks

    FROM inventory

    GROUP BY

        product_id

) AS restock_summary

-- Step 2: Return only qualifying products
WHERE total_restocks >= 3

ORDER BY

    product_id;
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
> * Very simple and easy to understand.
> * Matches the business requirement exactly.
> * Efficient for reporting queries.
>
> ---
>
> ### Most Optimal Solution
>
> **Strengths**
>
> * Minimal execution plan.
> * Easy to maintain.
> * Scales well on very large datasets with proper indexing.
>
> ---
>
> ### Alternative Approaches
>
> **CTE**
>
> * Improves readability.
> * Useful when additional processing is required after aggregation.
>
> **Subquery**
>
> * A good alternative when CTEs are unavailable.
> * Produces the same result with slightly less readability.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_inventory_product
> ON inventory(product_id);
> ```
>
> **Why?**
>
> * Optimizes grouping by `product_id`.
> * Reduces sorting and full table scans.
> * Improves aggregation performance on very large tables.
>
> **Time Complexity**
>
> * Approximately **O(N)** with appropriate indexing.
>
> **Production Notes**
>
> * Prefer `COUNT(*)` when every row represents a valid event.
> * Use `COUNT(DISTINCT column)` only when the business requires counting unique values.
> * Always validate the execution plan using `EXPLAIN` for large production datasets.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `COUNT(DISTINCT warehouse_id)` instead of counting restock events.
> * Using `SUM(quantity)` when the question asks for the number of restocks.
> * Filtering aggregated values using `WHERE` instead of `HAVING`.
> * Forgetting to sort the final result.
> * Misreading the business requirement and counting warehouses instead of events.

---
> [!QUESTION]
>
> ## Interview Follow-up Questions

### Q1. How would you modify the query to find products that were restocked in **3 or more different warehouses**?

<details>
<summary><strong>Answer</strong></summary>

The business requirement has changed from counting **restock events** to counting **unique warehouses**.

Use `COUNT(DISTINCT warehouse_id)`.

```sql
SELECT

    product_id,

    COUNT(DISTINCT warehouse_id) AS total_warehouses

FROM inventory

GROUP BY

    product_id

HAVING COUNT(DISTINCT warehouse_id) >= 3

ORDER BY

    product_id;
```

</details>

---

### Q2. Return the **total quantity restocked** for each qualifying product.

<details>
<summary><strong>Answer</strong></summary>

Add a `SUM(quantity)` aggregation while keeping the same filtering condition.

```sql
SELECT

    product_id,

    COUNT(*) AS total_restocks,

    SUM(quantity) AS total_quantity

FROM inventory

GROUP BY

    product_id

HAVING COUNT(*) >= 3

ORDER BY

    product_id;
```

</details>

---

### Q3. A product is considered high demand if it has been restocked for **3 consecutive weeks**. Would `GROUP BY` still be enough?

<details>
<summary><strong>Answer</strong></summary>

No.

This is no longer a simple aggregation problem.

Since the requirement involves **consecutive weeks**, you must analyze the sequence of restock events.

Typical SQL techniques include:

* `ROW_NUMBER()`
* `LAG()`
* `LEAD()`
* Week-based date calculations
* Gaps and Islands pattern

`GROUP BY` alone cannot determine whether the restocks occurred in consecutive weeks.

</details>

---

### Q4. The production table contains **8 billion rows**. What index would you recommend and why?

<details>
<summary><strong>Answer</strong></summary>

```sql
CREATE INDEX idx_inventory_product
ON inventory(product_id);
```

**Why?**

* Optimizes grouping by `product_id`.
* Reduces sorting and scanning on large tables.
* Improves aggregation performance for frequency-based reports.

If production queries also frequently filter by date, a composite index can be beneficial:

```sql
CREATE INDEX idx_inventory_product_date
ON inventory(product_id, restock_date);
```

This supports both grouping by product and filtering or ordering by restock date.

</details>

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question reinforces one of the most common SQL interview patterns: **frequency analysis using `GROUP BY` and `HAVING`**.
>
> The most important skill is correctly interpreting the business requirement:
>
> * `COUNT(*)` → Count every event.
> * `COUNT(column)` → Count non-NULL values.
> * `COUNT(DISTINCT column)` → Count unique values.
> * `SUM(column)` → Measure total quantity or value.
>
> Choosing the correct aggregation function is just as important as writing the SQL itself. Strong Data Engineers first understand **what the business wants to measure**, then select the appropriate SQL construct.
