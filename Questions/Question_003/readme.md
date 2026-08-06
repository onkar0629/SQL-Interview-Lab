# SQL Interview Question #003

![Difficulty](https://img.shields.io/badge/Difficulty-Medium-yellow?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Uber-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Ride%20Sharing-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Growth Analytics team wants to identify **inactive riders** for a re-engagement campaign.
>
> A rider is considered **inactive** if they have **never booked a ride**.
>
> As a Data Engineer, your task is to identify these riders from the operational database.
>
> ### Problem Statement
>
> Identify riders who have **never booked a ride**.
>
> Return the following columns:
>
> * `rider_id`
> * `rider_name`
> * `city`
>
> ### Expected Output
>
> Return only riders who do **not** have a matching record in the `rides` table.
>
> Sort the final result by **rider_id**.
>
> ### Constraints
>
> * Every rider may have zero, one, or many rides.
> * Do not return riders who have booked at least one ride.
> * The production `rides` table contains more than **500 million** records.
> * Write production-quality SQL.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Identify all registered riders.
> * Compare them with the rides table.
> * Find riders who have **no matching ride**.
> * Return only the inactive riders.

---

# My Solution

```sql
-- Step 1: Retrieve all riders
SELECT

    r.rider_id,

    r.rider_name,

    r.city

FROM riders r

-- Step 2: Remove riders who already exist
-- in the rides table
WHERE r.rider_id NOT IN
(
    SELECT rider_id

    FROM rides
)

-- Step 3: Return the inactive riders
ORDER BY r.rider_id;
```

> [!TIP]
> **Interview Note**
>
> The original solution used `GROUP BY rider_id` inside the subquery.
> During the interview review, we concluded that `GROUP BY` (or `DISTINCT`) is unnecessary here because `NOT IN` checks set membership rather than duplicate occurrences.

---

# Expected Output

| rider_id | rider_name | city    |
| -------: | ---------- | ------- |
|        3 | Rohan      | Delhi   |
|        6 | Sneha      | Chennai |
|        8 | Megha      | Mumbai  |

---

# Most Optimal Solution

```sql
-- Step 1: Return all riders from the master table
SELECT

    r.rider_id,

    r.rider_name,

    r.city

FROM riders r

-- Step 2: Keep only riders that do not exist
-- in the rides table
WHERE NOT EXISTS
(
    SELECT 1

    FROM rides rd

    WHERE rd.rider_id = r.rider_id
)

-- Step 3: Sort the final result
ORDER BY r.rider_id;
```

---

# Alternative Approach 1 — LEFT JOIN + IS NULL

```sql
-- Step 1: Retrieve all riders
SELECT

    r.rider_id,

    r.rider_name,

    r.city

FROM riders r

-- Step 2: Try to match every rider
-- with the rides table
LEFT JOIN rides rd
ON r.rider_id = rd.rider_id

-- Step 3: Keep only riders without a match
WHERE rd.rider_id IS NULL

-- Step 4: Return the result
ORDER BY r.rider_id;
```

---

# Alternative Approach 2 — NOT IN

```sql
-- Step 1: Retrieve all riders
SELECT

    r.rider_id,

    r.rider_name,

    r.city

FROM riders r

-- Step 2: Remove riders that exist
-- in the rides table
WHERE r.rider_id NOT IN
(
    SELECT rider_id

    FROM rides
)

-- Step 3: Return inactive riders
ORDER BY r.rider_id;
```

> [!WARNING]
> `NOT IN` is safe **only if the subquery cannot return `NULL` values**.
>
> If `rides.rider_id` contains a `NULL`, this query may return **no rows**, which makes it less suitable for production unless `NULL` values are impossible.

---

> [!IMPORTANT]
>
> ## Why This Approach?
>
> ### My Solution (`NOT IN`)
>
> **Strengths**
>
> * Simple and easy to understand.
> * Short and readable.
> * Suitable when the subquery column is guaranteed to contain no `NULL` values.
>
> **Limitations**
>
> * Can produce incorrect results if the subquery returns `NULL`.
>
> ---
>
> ### Most Optimal Solution (`NOT EXISTS`)
>
> **Strengths**
>
> * Safely handles `NULL` values.
> * Clearly expresses an anti-join.
> * Commonly preferred in ETL pipelines and production SQL.
> * Optimized efficiently by modern database engines.
>
> **Best suited when**
>
> * Working with large datasets.
> * Building production-grade Data Engineering pipelines.
>
> ---
>
> ### Alternative Approach (`LEFT JOIN ... IS NULL`)
>
> **Strengths**
>
> * Very readable.
> * Frequently used for reconciliation and reporting.
> * Easy to explain during interviews.
>
> **Best suited when**
>
> * Comparing two datasets.
> * Detecting unmatched records.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_rides_rider_id
> ON rides(rider_id);
> ```
>
> **Why?**
>
> * Speeds up anti-join lookups.
> * Reduces table scans.
> * Improves performance on very large ride tables.
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
> * If `rider_id` is already the primary key or a foreign key with an index, an additional index may not be necessary.
> * Prefer `NOT EXISTS` over `NOT IN` when `NULL` values are possible.
> * Review execution plans (`EXPLAIN`) on large datasets.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `INNER JOIN`, which returns active riders instead of inactive ones.
> * Forgetting about `NULL` behavior with `NOT IN`.
> * Adding unnecessary `GROUP BY` or `DISTINCT` inside the subquery.
> * Returning extra columns that were not requested.
> * Not ordering the final result when specified.

---

> [!TIP]
>
> ## Follow-up Variations
>
> 1. Find riders who have **not booked a ride in the last 90 days**.
> 2. Find riders who have booked **exactly one ride**.
> 3. Find riders whose **first ride** was in the current month.
> 4. Return the number of inactive riders for each city.
> 5. Identify riders who signed up but never completed a successful ride.

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question tests your understanding of **anti-join patterns**, one of the most common SQL concepts in Data Engineering. A strong candidate should know **when to use `NOT EXISTS`, `LEFT JOIN ... IS NULL`, and `NOT IN`**, understand their behavior with `NULL` values, and choose the most appropriate approach for production workloads.
