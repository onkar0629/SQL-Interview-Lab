# SQL Interview Question #010

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Google-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-E--Commerce-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Sales Analytics team wants to identify the **highest-value order** placed by each customer.
>
> This report is used to identify high-value customers and personalize customer engagement strategies.
>
> ### Problem Statement
>
> Identify the highest-value order for each customer.
>
> Return the following columns:
>
> * `customer_id`
> * `order_id`
> * `order_date`
> * `amount`
>
> ### Expected Output
>
> * Find the maximum order amount for each customer.
> * Return the order record(s) having that maximum amount.
> * If multiple orders have the same maximum amount, return **all tied orders**.
> * Sort the result by:
>
>   * `customer_id`
    >   * `order_id`
>
> ### Constraints
>
> * A customer may have multiple orders.
> * Multiple orders can have the same maximum amount.
> * All tied highest-value orders must be returned.
> * Lower-value orders must not be returned.
> * Write production-quality SQL.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into three logical steps:
>
> * Partition orders by `customer_id`.
> * Rank orders from highest amount to lowest amount.
> * Use `DENSE_RANK()` so orders with the same highest amount receive the same rank.
> * Return only rows where the rank is `1`.

---

# My Solution

```sql
-- Step 1: Rank orders for each customer
WITH cte AS
(
    SELECT

        customer_id,
        order_id,
        order_date,
        amount,

        -- Highest-value orders receive rank 1.
        -- DENSE_RANK() gives tied amounts the same rank.
        DENSE_RANK() OVER
        (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn

    FROM customer_orders
)

-- Step 2: Return all highest-value orders
SELECT

    customer_id,
    order_id,
    order_date,
    amount

FROM cte

WHERE rn = 1

ORDER BY
    customer_id,
    order_id;
```

> [!TIP]
>
> ## Interview Note
>
> The key requirement is:
>
> > **If multiple orders have the same maximum amount, return all tied orders.**
>
> `ROW_NUMBER()` would return only one row from the tie.
>
> `DENSE_RANK()` assigns the same rank to orders with the same amount, allowing all highest-value orders to be returned using:
>
> ```sql
> WHERE rn = 1
> ```
>
> This is a common **Top-N-per-group with ties** interview pattern.

---

# Expected Output

| customer_id | order_id | order_date |  amount |
| ----------: | -------: | ---------- | ------: |
|           1 |      102 | 2024-02-10 |  900.00 |
|           2 |      104 | 2024-01-10 | 1200.00 |
|           2 |      105 | 2024-02-20 | 1200.00 |
|           3 |      106 | 2024-01-12 |  450.00 |
|           4 |      108 | 2024-02-15 | 1500.00 |
|           5 |      111 | 2024-02-18 |  950.00 |
|           5 |      112 | 2024-03-25 |  950.00 |
|           6 |      113 | 2024-01-15 | 2000.00 |
|           6 |      115 | 2024-03-15 | 2000.00 |

---
# Most Optimal Solution

```sql
-- Step 1: Rank orders by amount for each customer
WITH ranked_orders AS
(
    SELECT

        customer_id,
        order_id,
        order_date,
        amount,

        -- Highest-value orders receive rank 1.
        -- Tied amounts receive the same rank.
        DENSE_RANK() OVER
        (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn

    FROM customer_orders
)

-- Step 2: Return all highest-value orders
SELECT

    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn = 1

ORDER BY
    customer_id,
    order_id;
```

---

> [!IMPORTANT]
>
> ## Why This Approach?
>
> `DENSE_RANK()` is the best fit because the requirement explicitly says:
>
> > **Return all tied highest-value orders.**
>
> For example, customer `2` has two orders worth `1200`:
>
> ```text
> order_id 104 → 1200 → rank 1
> order_id 105 → 1200 → rank 1
> ```
>
> Both rows are therefore returned.
>
> `ROW_NUMBER()` would assign different numbers to tied rows and return only one of them when filtering with `rn = 1`.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_customer_orders_customer_amount
> ON customer_orders(customer_id, amount);
> ```
>
> **Why?**
>
> * Supports partitioning by `customer_id`.
> * Supports ordering by `amount`.
> * Can reduce the amount of work required when processing large datasets.
>
> **Production Notes**
>
> * Always verify the actual execution plan with `EXPLAIN`.
> * Index effectiveness depends on table size, data distribution, and the database optimizer.
> * Avoid adding indexes blindly because indexes also increase storage and write overhead.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `ROW_NUMBER()` when all ties must be returned.
> * Using `ORDER BY amount` instead of `ORDER BY amount DESC`.
> * Forgetting `PARTITION BY customer_id`.
> * Using `MAX(amount)` and expecting it to return the complete order row.
> * Filtering the aggregate/window result incorrectly.
> * Returning only one order when multiple orders share the maximum amount.

---

> [!TIP]
>
> ## Important Pattern
>
> When an interviewer says:
>
> **"Return the highest value for each group and include all ties."**
>
> Think:
>
> ```text
> DENSE_RANK()
>       ↓
> ORDER BY value DESC
>       ↓
> WHERE rank = 1
> ```
>
> When they instead say:
>
> **"Return exactly one highest-value row per group."**
>
> Think:
>
> ```text
> ROW_NUMBER()
>       ↓
> ORDER BY value DESC
>       ↓
> WHERE rn = 1
> ```
>
> The difference between these two requirements is a very common SQL interview test.

---
> [!QUESTION]
>
> ## Interview Follow-up Questions

### Q1. What is the difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` in this problem?

<details>
<summary><strong>Answer</strong></summary>

All three functions rank rows, but they handle ties differently.

Suppose a customer has orders:

```text
2000
2000
1500
1000
```

The results are:

| amount | ROW_NUMBER | RANK | DENSE_RANK |
| -----: | ---------: | ---: | ---------: |
|   2000 |          1 |    1 |          1 |
|   2000 |          2 |    1 |          1 |
|   1500 |          3 |    3 |          2 |
|   1000 |          4 |    4 |          3 |

### `ROW_NUMBER()`

Every row receives a unique number.

Use it when you need **exactly one row**.

### `RANK()`

Tied rows receive the same rank, but gaps are created after ties.

### `DENSE_RANK()`

Tied rows receive the same rank, without gaps.

For this question, both `RANK()` and `DENSE_RANK()` correctly return all highest-value orders when filtering with `rank = 1`.

</details>

---

### Q2. How would you return the **second-highest order amount** for each customer, including ties?

<details>
<summary><strong>Answer</strong></summary>

Use `DENSE_RANK()` and filter for rank `2`.

```sql
WITH ranked_orders AS
(
    SELECT

        customer_id,
        order_id,
        order_date,
        amount,

        DENSE_RANK() OVER
        (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn

    FROM customer_orders
)

SELECT

    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn = 2

ORDER BY
    customer_id,
    order_id;
```

`DENSE_RANK()` is useful here because if multiple orders have the second-highest amount, all of them are returned.

</details>

---

### Q3. What would change if the business wanted **exactly one highest-value order**, even when there are ties?

<details>
<summary><strong>Answer</strong></summary>

Use `ROW_NUMBER()` instead of `DENSE_RANK()`.

```sql
WITH ranked_orders AS
(
    SELECT

        customer_id,
        order_id,
        order_date,
        amount,

        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY amount DESC, order_id
        ) AS rn

    FROM customer_orders
)

SELECT

    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn = 1

ORDER BY
    customer_id;
```

The additional `order_id` makes the choice deterministic when amounts are tied.

</details>

---

### Q4. Can this problem be solved using `MAX()` instead of a window function?

<details>
<summary><strong>Answer</strong></summary>

Yes.

First find the maximum amount for each customer, then join it back to the original table.

```sql
WITH max_orders AS
(
    SELECT

        customer_id,

        MAX(amount) AS max_amount

    FROM customer_orders

    GROUP BY customer_id
)

SELECT

    o.customer_id,
    o.order_id,
    o.order_date,
    o.amount

FROM customer_orders o

JOIN max_orders m
    ON o.customer_id = m.customer_id
   AND o.amount = m.max_amount

ORDER BY
    o.customer_id,
    o.order_id;
```

This approach naturally returns all tied highest-value orders.

For this problem, `DENSE_RANK()` is more concise and directly expresses the ranking requirement, while `MAX()` + `JOIN` is a useful alternative to know for interviews.

</details>

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question reinforces how **tie handling changes the choice of window function**.
>
> * `ROW_NUMBER()` → exactly one row per group.
> * `RANK()` → ties share a rank, with gaps.
> * `DENSE_RANK()` → ties share a rank, without gaps.
> * `MAX()` → returns the maximum value, but requires a join if the complete row is needed.
>
> The most important interview skill is not memorizing these functions individually. It is recognizing the business requirement:
>
> **"One row"** → `ROW_NUMBER()`
>
> **"All rows tied for highest"** → `RANK()` / `DENSE_RANK()`
>
> **"Maximum value only"** → `MAX()`
