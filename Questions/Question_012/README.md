# SQL Interview Question #012

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Snowflake-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Data%20Warehouse-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> A daily ETL pipeline loads customer records from an operational source system into a data warehouse.
>
> The Data Quality team needs to validate whether every record received in a source batch was successfully loaded into the warehouse.
>
> ### Problem Statement
>
> For batch date **`2025-08-17`**, identify all customer records that exist in `source_customer_batch` but are missing from `warehouse_customer`.
>
> Return:
>
> * `customer_id`
> * `batch_date`
> * `customer_name`
> * `email`
> * `updated_at`
>
> ### Matching Rule
>
> A warehouse record is considered a match only when **both** `customer_id` and `batch_date` are equal to the source record.
>
> ### Expected Output
>
> | customer_id | batch_date | customer_name | email | updated_at |
> |---:|---|---|---|---|
> | 103 | 2025-08-17 | Rahul Mehta | rahul@example.com | 2025-08-17 08:25:00 |
>
> ### Constraints
>
> * Records from another batch date must not satisfy the match.
> * Return only source records missing from the target.
> * Sort by `customer_id`.
> * Write production-quality SQL.

---

# My Solution

```sql
SELECT
    s.customer_id,
    s.batch_date,
    s.customer_name,
    s.email,
    s.updated_at
FROM source_customer_batch AS s
LEFT JOIN warehouse_customer AS w
    ON  w.customer_id = s.customer_id
    AND w.batch_date = s.batch_date
WHERE s.batch_date = '2025-08-17'
  AND w.customer_id IS NULL
ORDER BY s.customer_id;
```

> [!TIP]
>
> ## Interview Note
>
> This is an **anti-join** pattern.
>
> The source table is the driving table because the requirement is to find rows that should have been loaded. The `LEFT JOIN` preserves every source row, and `w.customer_id IS NULL` keeps only source records for which no matching warehouse row exists.
>
> The `batch_date` condition belongs in the join key as well as the source filter. Otherwise, a customer loaded on a different day could incorrectly appear as successfully reconciled.

---

# Most Optimal Solution

```sql
SELECT
    s.customer_id,
    s.batch_date,
    s.customer_name,
    s.email,
    s.updated_at
FROM source_customer_batch AS s
WHERE s.batch_date = '2025-08-17'
  AND NOT EXISTS (
      SELECT 1
      FROM warehouse_customer AS w
      WHERE w.customer_id = s.customer_id
        AND w.batch_date = s.batch_date
  )
ORDER BY s.customer_id;
```

> [!IMPORTANT]
>
> ## Why `NOT EXISTS`?
>
> `NOT EXISTS` expresses the business requirement directly: return the source row when no corresponding target row exists.
>
> It is also safer than `NOT IN` when nullable columns are involved, because `NOT IN` can produce unexpected results when its subquery contains `NULL`.
>
> For a source-to-target reconciliation check, `NOT EXISTS` is a strong production-quality choice.

---

# Alternative Approach

```sql
SELECT
    s.customer_id,
    s.batch_date,
    s.customer_name,
    s.email,
    s.updated_at
FROM source_customer_batch AS s
WHERE s.batch_date = '2025-08-17'
  AND (s.customer_id, s.batch_date) NOT IN (
      SELECT w.customer_id, w.batch_date
      FROM warehouse_customer AS w
  )
ORDER BY s.customer_id;
```

Use this only when the compared columns are guaranteed to be non-null. `NOT EXISTS` is generally the safer interview answer.

---

# Performance Considerations

For a large warehouse table, an index on the reconciliation key is important:

```sql
CREATE INDEX idx_warehouse_customer_batch
ON warehouse_customer(customer_id, batch_date);
```

For the source batch table, filtering by batch date can also benefit from an index:

```sql
CREATE INDEX idx_source_customer_batch_date
ON source_customer_batch(batch_date);
```

If the source table is very large, a composite index beginning with `batch_date` can be useful when the workload consistently filters by batch and then checks the customer key.

---

# Common Interview Mistakes

1. Joining only on `customer_id` and ignoring `batch_date`.
2. Using `INNER JOIN`, which removes the missing records the question is asking for.
3. Putting the target-side filter incorrectly in the `WHERE` clause and accidentally converting a `LEFT JOIN` into an inner join.
4. Using `NOT IN` without considering `NULL` semantics.
5. Comparing only customer attributes such as `email` instead of the source-to-target business key.

---

# Follow-up Interview Questions

### 1. How would you find records loaded into the warehouse but missing from the source?

Reverse the anti-join: use the warehouse as the driving table and search for missing source records.

### 2. How would you calculate the reconciliation percentage?

```sql
SELECT
    COUNT(*) AS source_count,
    SUM(
        CASE WHEN EXISTS (
            SELECT 1
            FROM warehouse_customer w
            WHERE w.customer_id = s.customer_id
              AND w.batch_date = s.batch_date
        ) THEN 1 ELSE 0 END
    ) AS loaded_count
FROM source_customer_batch s
WHERE s.batch_date = '2025-08-17';
```

### 3. What would you do if duplicate source rows existed for the same customer and batch?

First define the business key and expected grain. Then use deduplication logic such as `ROW_NUMBER()` based on `updated_at`, keeping the latest valid source record before reconciliation.

### 4. What if the warehouse record exists but the email has changed?

That becomes a different data-quality rule: distinguish **missing-record validation** from **attribute-level validation**. Compare the expected attributes after confirming the row exists.

### 5. Where would this query fit in a Data Engineering pipeline?

It can run as a post-load data-quality check after ingestion. The result can feed an alerting, retry, quarantine, or reconciliation workflow.
