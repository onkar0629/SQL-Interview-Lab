# SQL Interview Question #001

![Difficulty](https://img.shields.io/badge/Difficulty-Medium-yellow?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Amazon-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)

---

> [!NOTE]
>
> ## Business Context
>
> The Product Analytics team wants to measure customer retention by identifying customers whose **second order was placed within 30 days of their first order**.
>
> The complete question, schema and sample data are available in **Question_001.sql**.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL:
>
> * Rank every customer's orders chronologically.
> * Identify the first and second order.
> * Calculate the number of days between them.
> * Return only customers whose second order occurred within 30 days.

---

# My Solution

```sql
-- Step 1: Rank every customer's orders based on order date
WITH ranked_orders AS
(
    SELECT

        customer_id,

        order_date,

        -- Assign the sequence number for every order
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS rn

    FROM orders
),

-- Step 2: Extract the first and second order dates
first_second_orders AS
(
    SELECT

        customer_id,

        -- Retrieve the first order date
        MAX(CASE WHEN rn = 1 THEN order_date END)
        AS first_order_date,

        -- Retrieve the second order date
        MAX(CASE WHEN rn = 2 THEN order_date END)
        AS second_order_date

    FROM ranked_orders

    -- Only the first two orders are required
    WHERE rn IN (1,2)

    GROUP BY customer_id
)

-- Step 3: Calculate the number of days between the first and second order
SELECT

    customer_id,

    first_order_date,

    second_order_date,

    DATEDIFF(second_order_date, first_order_date)
    AS days_between_orders

FROM first_second_orders

-- Step 4: Keep only customers whose second order
-- was placed within 30 days
WHERE second_order_date IS NOT NULL
AND DATEDIFF(second_order_date, first_order_date) <= 30

ORDER BY customer_id;
```

---

# Expected Output

| customer_id | first_order_date | second_order_date | days_between_orders |
| ----------: | ---------------- | ----------------- | ------------------: |
|           1 | 2024-01-01       | 2024-01-20        |                  19 |
|           4 | 2024-02-01       | 2024-02-25        |                  24 |
|           5 | 2024-03-10       | 2024-03-30        |                  20 |

---

# Most Optimal Solution

```sql
-- Step 1: Fetch the customer's next order using LEAD()
WITH customer_orders AS
(
    SELECT

        customer_id,

        order_date AS first_order_date,

        -- Retrieve the next order date
        LEAD(order_date) OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS second_order_date,

        -- Rank the orders to identify the first purchase
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS rn

    FROM orders
)

-- Step 2: Keep only the first order for every customer
SELECT

    customer_id,

    first_order_date,

    second_order_date,

    -- Calculate the days between first and second order
    DATEDIFF(second_order_date, first_order_date)
    AS days_between_orders

FROM customer_orders

WHERE rn = 1
AND second_order_date IS NOT NULL
AND DATEDIFF(second_order_date, first_order_date) <= 30

ORDER BY customer_id;
```

---

# Alternative Approach 1 — ROW_NUMBER() + Self Join

```sql
-- Step 1: Rank every customer's orders
WITH ranked_orders AS
(
    SELECT

        customer_id,

        order_date,

        -- Assign a sequence number to each order
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS rn

    FROM orders
)

-- Step 2: Join the first order with the second order
SELECT

    first.customer_id,

    first.order_date AS first_order_date,

    second.order_date AS second_order_date,

    -- Calculate the difference in days
    DATEDIFF(second.order_date, first.order_date)
    AS days_between_orders

FROM ranked_orders first

JOIN ranked_orders second
ON first.customer_id = second.customer_id

-- Keep only the first and second orders
WHERE first.rn = 1
AND second.rn = 2

-- Return customers whose second order
-- occurred within 30 days
AND DATEDIFF(second.order_date, first.order_date) <= 30

ORDER BY first.customer_id;
```

---

# Alternative Approach 2 — Conditional Aggregation

```sql
-- Step 1: Rank every customer's orders
WITH ranked_orders AS
(
    SELECT

        customer_id,

        order_date,

        -- Assign the order sequence
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS rn

    FROM orders
),

-- Step 2: Convert rows into first and second order columns
first_second_orders AS
(
    SELECT

        customer_id,

        -- Capture the first order date
        MAX(CASE WHEN rn = 1 THEN order_date END)
        AS first_order_date,

        -- Capture the second order date
        MAX(CASE WHEN rn = 2 THEN order_date END)
        AS second_order_date

    FROM ranked_orders

    WHERE rn IN (1,2)

    GROUP BY customer_id
)

-- Step 3: Calculate the days between orders
SELECT

    customer_id,

    first_order_date,

    second_order_date,

    DATEDIFF(second_order_date, first_order_date)
    AS days_between_orders

FROM first_second_orders

-- Step 4: Return only qualifying customers
WHERE second_order_date IS NOT NULL
AND DATEDIFF(second_order_date, first_order_date) <= 30

ORDER BY customer_id;
```

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_orders_customer_date
> ON orders(customer_id, order_date, order_id);
> ```
>
> **Why?**
>
> * Supports `PARTITION BY customer_id`.
> * Supports `ORDER BY order_date, order_id`.
> * Improves window function performance on large datasets.
>
> **Time Complexity**
>
> `O(N log N)`
>
> **Space Complexity**
>
> `O(N)`
>
> **Production Notes**
>
> * Always use deterministic ordering (`order_date, order_id`).
> * Prefer window functions over correlated subqueries for this pattern.
> * Ensure table statistics and indexes are maintained in production.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Comparing the first and last order instead of the first and second.
> * Forgetting customers with only one order.
> * Ignoring the **exactly 30 days** requirement.
> * Using only `ORDER BY order_date`, which may produce non-deterministic results.
> * Returning columns that were not requested.

---

> [!TIP]
>
> ## Follow-up Variations
>
> 1. Find customers whose **third order** occurred within **60 days** of the second order.
> 2. Find customers whose **first three orders** occurred within **90 days**.
> 3. Find customers whose **second order amount** is greater than the first order amount.
> 4. Calculate the average number of days between the **first** and **second** order for each month.

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This problem evaluates your ability to work with **window functions**, identify sequential events, and write SQL that is scalable and suitable for real-world Data Engineering scenarios.
