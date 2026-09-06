# Q15 — DELETE vs TRUNCATE vs DROP

## Problem

Explain the difference between `DELETE`, `TRUNCATE`, and `DROP`, and identify which command removes all rows while keeping the table structure.

## Answer

### DELETE

`DELETE` removes rows from a table and can use a `WHERE` condition to target specific rows. It can also remove all rows when used without `WHERE`.

```sql
DELETE FROM employees
WHERE department_id = 10;
```

### TRUNCATE

`TRUNCATE` removes all rows from a table while keeping the table structure. It does not use a normal `WHERE` clause.

```sql
TRUNCATE TABLE employees;
```

### DROP

`DROP` removes the table itself, including its data and structure.

```sql
DROP TABLE employees;
```

## Scenario Answer

If the requirement is to remove all records but keep the table structure, use:

```sql
TRUNCATE TABLE employees;
```

## Comparison

| Command | Removes Data | Removes Structure | WHERE |
|---|---|---|---|
| DELETE | Yes | No | Yes |
| TRUNCATE | All rows | No | No |
| DROP | Yes | Yes | No |

## Score

**9/10 — correct understanding; minor nuance: DELETE can also remove all rows without a WHERE clause.**