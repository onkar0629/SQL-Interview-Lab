# V4C.ai Interview — SQL Question 1

## Problem

Given a `sales` table containing:

- `employee_id`
- `sale_date`
- `sales_amount`

Calculate each employee's **today's sales minus the previous day's sales**.

Return:

- `employee_id`
- `sale_date`
- `sales_amount`
- `previous_sales`
- `sales_difference`

## Concepts Tested

- `LAG()` window function
- `PARTITION BY`
- `ORDER BY` inside a window function
- Comparing the current row with the previous row
- CTEs

## Final Solution

```sql
WITH sales_with_previous AS (
    SELECT
        employee_id,
        sale_date,
        sales_amount,
        LAG(sales_amount) OVER (
            PARTITION BY employee_id
            ORDER BY sale_date
        ) AS previous_sales
    FROM sales
)
SELECT
    employee_id,
    sale_date,
    sales_amount,
    previous_sales,
    sales_amount - previous_sales AS sales_difference
FROM sales_with_previous;
```

## Explanation

`PARTITION BY employee_id` makes the comparison independent for each employee.

`ORDER BY sale_date` establishes the chronological order needed to identify the previous day's record.

`LAG(sales_amount)` returns the previous sales amount for that employee.

Finally, `sales_amount - previous_sales` calculates the change from the previous record.

## Initial Attempt — Correction

The initial attempt correctly used `LAG()` and `PARTITION BY employee_id`, but the second `LAG()` was ordered by `sales_amount`. Since the requirement is based on the previous day, the window must be ordered by `sale_date`.

Also, the calculation should be **current sales minus previous sales**.

## Interview Takeaway

For time-series comparisons, remember this pattern:

```sql
LAG(value_column) OVER (
    PARTITION BY entity_column
    ORDER BY date_or_timestamp_column
)
```

Then compare the current value with the lagged value.
