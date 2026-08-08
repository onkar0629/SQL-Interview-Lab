# SQL Interview Question #008

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Microsoft-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Human%20Resources-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The HR Analytics team wants to identify employees who have received salary increments over time.
>
> An employee is considered to have received a salary increment if their current salary is greater than their **immediately previous recorded salary**.
>
> This report is used to verify payroll updates and analyze employee salary growth.
>
> ### Problem Statement
>
> Identify every salary increment event.
>
> Return the following columns:
>
> * `employee_id`
> * `previous_salary`
> * `current_salary`
> * `effective_date`
>
> ### Expected Output
>
> * Compare each salary with the employee's **immediately previous salary**.
> * Return only salary increment events.
> * Ignore the employee's first salary record.
> * Exclude salary decreases.
> * Exclude equal salaries.
> * Sort the result by:
>
>   * `employee_id`
    >   * `effective_date`
>
> ### Constraints
>
> * Every employee can have multiple salary records.
> * Compare only consecutive salary records.
> * Equal salaries are **not** increments.
> * Write production-quality SQL.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Use `LAG()` to retrieve each employee's immediately previous salary.
> * Ignore the first salary record where no previous salary exists.
> * Keep only rows where the current salary is greater than the previous salary.
> * Return the final result ordered by employee and effective date.

---

# My Solution

```sql
-- Step 1: Get the previous salary for each employee
WITH salary_history AS
(
    SELECT

        employee_id,

        LAG(salary) OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date
        ) AS previous_salary,

        salary AS current_salary,

        effective_date

    FROM employee_salary
)

-- Step 2: Return only salary increment events
SELECT

    employee_id,

    previous_salary,

    current_salary,

    effective_date

FROM salary_history

WHERE previous_salary IS NOT NULL
  AND current_salary > previous_salary

-- Step 3: Sort the final result
ORDER BY

    employee_id,

    effective_date;
```

> [!TIP]
> **Interview Note**
>
> The phrase:
>
> > **"Compare each salary with the employee's immediately previous salary."**
>
> immediately indicates that a **window function** is required.
>
> `LAG()` is the most appropriate choice because it retrieves the previous row within each employee's salary history without requiring self-joins.

---

# Expected Output

| employee_id | previous_salary | current_salary | effective_date |
| ----------: | --------------: | -------------: | -------------- |
|           1 |           50000 |          55000 | 2024-04-01     |
|           1 |           55000 |          60000 | 2024-07-01     |
|           4 |           80000 |          82000 | 2024-03-01     |
|           5 |           60000 |          65000 | 2024-02-15     |
|           5 |           63000 |          70000 | 2024-05-15     |

---# Most Optimal Solution

```sql
-- Step 1: Retrieve the previous salary for each employee
WITH salary_history AS
(
    SELECT

        employee_id,

        LAG(salary) OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date
        ) AS previous_salary,

        salary AS current_salary,

        effective_date

    FROM employee_salary
)

-- Step 2: Return only salary increment events
SELECT

    employee_id,

    previous_salary,

    current_salary,

    effective_date

FROM salary_history

WHERE previous_salary IS NOT NULL
  AND current_salary > previous_salary

-- Step 3: Sort the final result
ORDER BY

    employee_id,

    effective_date;
```

---

# Alternative Approach — Self Join (Without Window Functions)

> [!NOTE]
> This approach is useful for SQL databases that do not support window functions. However, it is generally more complex and less efficient than using `LAG()`.

```sql
-- Step 1: Find the immediately previous salary record
SELECT

    e1.employee_id,

    e2.salary AS previous_salary,

    e1.salary AS current_salary,

    e1.effective_date

FROM employee_salary e1

JOIN employee_salary e2
    ON e1.employee_id = e2.employee_id
   AND e2.effective_date =
   (
       SELECT MAX(e3.effective_date)

       FROM employee_salary e3

       WHERE e3.employee_id = e1.employee_id
         AND e3.effective_date < e1.effective_date
   )

-- Step 2: Return only salary increments
WHERE e1.salary > e2.salary

ORDER BY

    e1.employee_id,

    e1.effective_date;
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
> * Directly matches the business requirement.
> * Uses `LAG()` to compare consecutive salary records.
> * Easy to read and maintain.
>
> ---
>
> ### Most Optimal Solution
>
> **Strengths**
>
> * Uses a single window function.
> * Eliminates the need for complex self-joins.
> * Scales well on large datasets.
>
> ---
>
> ### Alternative Approach
>
> **Self Join**
>
> * Useful when window functions are unavailable.
> * Requires additional joins and correlated subqueries.
> * More difficult to understand and maintain.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_employee_salary
> ON employee_salary(employee_id, effective_date);
> ```
>
> **Why?**
>
> * Optimizes partitioning by `employee_id`.
> * Supports ordering by `effective_date`.
> * Improves the performance of window functions.
> * Benefits self-join solutions as well.
>
> **Time Complexity**
>
> * Approximately **O(N)** using `LAG()` with appropriate indexing.
>
> **Production Notes**
>
> * Window functions are generally preferred over self-joins for sequential comparisons.
> * Always ensure the `ORDER BY` column accurately represents the chronological sequence.
> * Review execution plans (`EXPLAIN`) when processing large salary history tables.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `MAX(salary)` or `MIN(salary)` instead of comparing with the immediately previous salary.
> * Forgetting to partition by `employee_id`.
> * Ordering the window function incorrectly.
> * Returning salary decreases or equal salaries.
> * Trying to filter a window function directly in the same query without using a CTE or subquery.

---
> [!QUESTION]
>
> ## Interview Follow-up Questions

### Q1. Return the **salary increment amount** for each salary increase.

<details>
<summary><strong>Answer</strong></summary>

The increment amount is simply the difference between the current salary and the previous salary.

```sql
WITH salary_history AS
(
    SELECT

        employee_id,

        LAG(salary) OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date
        ) AS previous_salary,

        salary AS current_salary,

        effective_date

    FROM employee_salary
)

SELECT

    employee_id,

    previous_salary,

    current_salary,

    current_salary - previous_salary AS increment_amount,

    effective_date

FROM salary_history

WHERE previous_salary IS NOT NULL
  AND current_salary > previous_salary

ORDER BY

    employee_id,

    effective_date;
```

</details>

---

### Q2. Return **only the latest salary increment** for each employee.

<details>
<summary><strong>Answer</strong></summary>

After identifying all salary increment events, rank them by `effective_date` in descending order and return only the latest one for each employee.

```sql
WITH salary_history AS
(
    SELECT

        employee_id,

        LAG(salary) OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date
        ) AS previous_salary,

        salary AS current_salary,

        effective_date

    FROM employee_salary
),

increments AS
(
    SELECT

        *,

        ROW_NUMBER() OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date DESC
        ) AS rn

    FROM salary_history

    WHERE previous_salary IS NOT NULL
      AND current_salary > previous_salary
)

SELECT

    employee_id,

    previous_salary,

    current_salary,

    effective_date

FROM increments

WHERE rn = 1

ORDER BY employee_id;
```

> **Alternative:** A `MAX(effective_date)` + `JOIN` solution is also correct, but `ROW_NUMBER()` is generally cleaner because it returns the entire latest row without an additional join.

</details>

---

### Q3. Identify employees whose salary **decreased** compared to their immediately previous salary.

<details>
<summary><strong>Answer</strong></summary>

The same `LAG()` logic can be reused.

Only the filtering condition changes.

```sql
WITH salary_history AS
(
    SELECT

        employee_id,

        LAG(salary) OVER
        (
            PARTITION BY employee_id
            ORDER BY effective_date
        ) AS previous_salary,

        salary AS current_salary,

        effective_date

    FROM employee_salary
)

SELECT

    employee_id,

    previous_salary,

    current_salary,

    effective_date

FROM salary_history

WHERE previous_salary IS NOT NULL
  AND current_salary < previous_salary

ORDER BY

    employee_id,

    effective_date;
```

</details>

---

### Q4. The production table contains **500 million salary history records**. What index would you recommend?

<details>
<summary><strong>Answer</strong></summary>

```sql
CREATE INDEX idx_employee_salary
ON employee_salary(employee_id, effective_date);
```

**Why?**

* Supports `PARTITION BY employee_id`.
* Supports `ORDER BY effective_date`.
* Improves the efficiency of the `LAG()` window function.
* Benefits self-join solutions that compare consecutive salary records.

</details>

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question introduces one of the most common window-function interview patterns:
>
> **Compare the current row with the immediately previous row.**
>
> Key lessons:
>
> * Use `LAG()` when comparing a row with its previous record.
> * Use `LEAD()` when comparing with the next record.
> * Use `ROW_NUMBER()` when you need the **latest or first entire row**, not just the latest value.
> * `MAX()` returns only a single value (such as the latest date); if you need the entire corresponding row, combine it with a `JOIN` or prefer `ROW_NUMBER()`.
> * Always choose the SQL feature that directly matches the business requirement instead of forcing an aggregation or window function.

