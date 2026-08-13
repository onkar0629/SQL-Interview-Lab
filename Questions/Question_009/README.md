# SQL Interview Question #009

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Amazon-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-E--Commerce-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Customer Analytics team wants to identify each customer's **most recent purchase**.
>
> This report is used to power personalized recommendations, customer segmentation, and customer re-engagement campaigns.
>
> ### Problem Statement
>
> Return the **most recent order placed by each customer**.
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
> * Return exactly one row for each customer.
> * The returned row must represent the customer's latest order.
> * Sort the result by `customer_id`.
>
> ### Constraints
>
> * A customer can place multiple orders.
> * The latest order is determined by `order_date`.
> * Assume there are no duplicate order dates for the same customer.
> * Write production-quality SQL.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into three steps:
>
> * Partition orders by `customer_id`.
> * Use `ROW_NUMBER()` to rank the newest order first using `order_date DESC`.
> * Return only the row where `rn = 1`.

---

# My Solution

```sql
-- Step 1: Rank each customer's orders
-- from newest to oldest.
WITH cte AS
(
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,

        -- The latest order receives rn = 1
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn

    FROM orders
)

-- Step 2: Keep only the latest order
-- for each customer.
SELECT
    customer_id,
    order_id,
    order_date,
    amount

FROM cte

WHERE rn = 1

ORDER BY customer_id;
```

> [!TIP]
>
> ## Interview Note
>
> The key requirement is:
>
> > **Return the entire latest order row for each customer.**
>
> `ROW_NUMBER()` is appropriate because it allows us to identify the latest row while retaining all columns from that row.
>
> The important part is:
>
> ```sql
> ORDER BY order_date DESC
> ```
>
> `DESC` places the newest order first, so:
>
> ```sql
> rn = 1
> ```
>
> represents the customer's most recent order.

---

# Expected Output

| customer_id | order_id | order_date |  amount |
| ----------: | -------: | ---------- | ------: |
|           1 |      103 | 2024-04-10 |  800.00 |
|           2 |      105 | 2024-03-18 |  900.00 |
|           3 |      106 | 2024-02-05 |  400.00 |
|           4 |      109 | 2024-05-01 |  950.00 |
|           5 |      111 | 2024-02-14 |  450.00 |
|           6 |      114 | 2024-04-15 | 1500.00 |

---
# Most Optimal Solution

```sql
-- Step 1: Rank each customer's orders
-- from newest to oldest.
WITH ranked_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,

        -- Latest order gets rn = 1
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn

    FROM orders
)

-- Step 2: Keep only the latest order
-- for each customer.
SELECT
    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn = 1

ORDER BY customer_id;
```

---

# Alternative Approach — Correlated Subquery

This alternative makes sense because it solves the same problem using a different SQL technique: finding the maximum order date for each customer and matching it back to the order.

```sql
SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    o.amount

FROM orders o

WHERE o.order_date =
(
    -- Find the latest order date for this customer
    SELECT MAX(o2.order_date)

    FROM orders o2

    WHERE o2.customer_id = o.customer_id
)

ORDER BY
    o.customer_id;
```

> [!IMPORTANT]
>
> ## Why This Approach?
>
> ### Most Optimal Solution — `ROW_NUMBER()`
>
> * Directly identifies the latest row.
> * Returns the complete order record.
> * Easy to extend to Top-N-per-customer problems.
> * Clearly communicates the ranking logic.
>
> ### Alternative — `MAX()` + Correlated Subquery
>
> * Uses `MAX()` to identify the latest date.
> * Useful when the requirement naturally focuses on the maximum date.
> * Can return multiple rows if duplicate latest dates exist.
> * Does not require a window function.
>
> For this problem, `ROW_NUMBER()` is the preferred approach because the requirement is specifically to retrieve the **entire latest order record** for each customer.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_orders_customer_date
> ON orders(customer_id, order_date);
> ```
>
> **Why?**
>
> * Supports partitioning by `customer_id`.
> * Helps with ordering/filtering by `order_date`.
> * Can improve performance when processing a large orders table.
>
> **Production Notes**
>
> * Use `EXPLAIN` to verify the actual execution plan.
> * On very large order tables, indexing strategy should be evaluated against the workload rather than assumed.
> * If `order_date` is not unique for a customer, use a deterministic tie-breaker such as `order_id`.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `ORDER BY order_date ASC`, which returns the earliest order.
> * Forgetting `PARTITION BY customer_id`.
> * Using `RANK()` or `DENSE_RANK()` when exactly one row per customer is required and ties are not expected.
> * Using `MAX(amount)` when the requirement is to find the latest order.
> * Returning only the latest date instead of the complete order record.

---
> [!QUESTION]
>
> ## Interview Follow-up Questions

### Q1. What happens if a customer has two orders with the **same latest `order_date`**?

<details>
<summary><strong>Answer</strong></summary>

With the current `ROW_NUMBER()` solution, only **one** of the tied orders will be returned.

If the requirement is to return **all orders with the latest date**, use `RANK()` or `DENSE_RANK()` instead.

```sql
WITH ranked_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,

        RANK() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn

    FROM orders
)

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

`RANK()` gives the same rank to orders having the same latest date, so all tied orders are returned.

</details>

---

### Q2. What if the business wants the **highest-value order** for each customer instead of the latest order?

<details>
<summary><strong>Answer</strong></summary>

Change the ordering inside the window function from `order_date DESC` to `amount DESC`.

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
            ORDER BY amount DESC
        ) AS rn

    FROM orders
)

SELECT
    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn = 1;
```

The important concept is that `ROW_NUMBER()` itself has not changed. Only the column used for ranking has changed.

</details>

---

### Q3. Return the **latest 3 orders** for each customer.

<details>
<summary><strong>Answer</strong></summary>

Use `ROW_NUMBER()` and keep rows where the ranking is between 1 and 3.

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
            ORDER BY order_date DESC
        ) AS rn

    FROM orders
)

SELECT
    customer_id,
    order_id,
    order_date,
    amount

FROM ranked_orders

WHERE rn <= 3

ORDER BY
    customer_id,
    order_date DESC;
```

This is a common **Top-N-per-group** interview pattern.

</details>

---

### Q4. Why would you use `ROW_NUMBER()` instead of `MAX(order_date)` if you need `order_id` and `amount` too?

<details>
<summary><strong>Answer</strong></summary>

`MAX(order_date)` returns only the maximum date.

It does not automatically return the other columns belonging to that order.

For example:

```sql
SELECT
    customer_id,
    MAX(order_date) AS latest_order_date
FROM orders
GROUP BY customer_id;
```

This gives us the latest date, but not the corresponding `order_id` or `amount`.

`ROW_NUMBER()` allows us to rank the complete rows and then select:

```sql
WHERE rn = 1
```

Therefore, we can return the entire latest order record.

An alternative is to use `MAX(order_date)` and then join the result back to the `orders` table.

</details>

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question reinforces the **Top-N-per-group** pattern.
>
> Key lessons:
>
> * `ROW_NUMBER()` + `PARTITION BY` → identify one specific row per group.
> * `ORDER BY ... DESC` + `rn = 1` → latest/highest row.
> * `ROW_NUMBER()` → exactly one row, even when values tie.
> * `RANK()` / `DENSE_RANK()` → useful when tied rows must all be returned.
> * `MAX()` → returns a value, not the complete corresponding row.
> * The column used inside `ORDER BY` determines **what "top" means**.
