# SQL Interview Lab

> [!NOTE]
>
> ## About This Repository
>
> **SQL Interview Lab** is a collection of real-world SQL interview questions designed for **Data Engineering** interview preparation.
>
> Every problem is inspired by actual interview patterns and production scenarios from leading technology and consulting companies. The focus is not only on writing correct SQL but also on understanding business requirements, choosing optimal approaches, discussing performance considerations, and thinking like a Data Engineer.
>
> Each completed question includes:
>
> * Production-quality SQL solution
> * Multiple optimized approaches
> * Performance considerations
> * Common interview mistakes
> * Interview follow-up discussions
> * Professional documentation

---

# Repository Structure

```text
SQL-Interview-Lab/
│
├── README.md
│
├── Question_001.sql
├── Question_001.md
│
├── Question_002.sql
├── Question_002.md
│
├── Question_003.sql
├── Question_003.md
│
├── Question_004.sql
├── Question_004.md
│
├── Question_005.sql
├── Question_005.md
│
└── ...
```

---

> [!IMPORTANT]
>
> ## Repository Workflow
>
> Every question in this repository follows the same workflow:
>
> ```text
> Question_XXX.sql
>        │
>        ▼
> Solve the Problem
>        │
>        ▼
> Interview Review
>        │
>        ▼
> Follow-up Questions
>        │
>        ▼
> Most Optimal Solution
>        │
>        ▼
> Alternative Approaches
>        │
>        ▼
> Question_XXX.md
> ```
>
> This workflow mirrors a real technical interview while documenting production-ready SQL solutions.

---

# Completed Questions

|   # | Question                          | Difficulty | Company Inspired | Business Domain | Interview Focus            | Concepts                                                          |
| --: | --------------------------------- | :--------: | ---------------- | --------------- | -------------------------- | ----------------------------------------------------------------- |
| 001 | Second Order Within 30 Days       |  🟡 Medium | Amazon           | E-Commerce      | Customer Retention         | `ROW_NUMBER()`, `LEAD()`, Conditional Aggregation, Date Functions |
| 002 | Missing Warehouse Records         |   🔴 Hard  | Snowflake        | Data Warehouse  | ETL Validation             | `NOT EXISTS`, `LEFT JOIN`, Anti Join, Data Reconciliation         |
| 003 | Inactive Riders                   |  🟡 Medium | Uber             | Ride Sharing    | Customer Activity Analysis | `NOT EXISTS`, `NOT IN`, NULL Handling, Anti Join                  |
| 004 | Multiple Same-Day Transactions    |   🔴 Hard  | Microsoft        | Banking         | Fraud Detection            | `GROUP BY`, `HAVING`, `COUNT(*)`, Aggregation                     |
| 005 | Best-Selling Product per Category |   🔴 Hard  | Amazon           | E-Commerce      | Sales Analytics            | `SUM()`, `DENSE_RANK()`, Window Functions, Ranking                |


---

# Difficulty Distribution

| Difficulty | Questions Solved |
| :--------- | ---------------: |
| 🟢 Easy    |                0 |
| 🟡 Medium  |                2 |
| 🔴 Hard    |                3 |
| **Total**  |            **5** |

---

# Interview Topics Covered

| Business Scenario          | Status |
| -------------------------- | :----: |
| Customer Retention         |    ✅   |
| ETL Validation             |    ✅   |
| Data Reconciliation        |    ✅   |
| Customer Activity Analysis |    ✅   |
| Fraud Detection            |    ✅   |
| Sales Analytics            |    ✅   |
| Top-N Analysis             |    ✅   |
| Ranking Problems           |    ✅   |
| Window Function Scenarios  |    ✅   |

---

# Concept Coverage

| Category                        | Topics Covered                                                   |
| ------------------------------- | ---------------------------------------------------------------- |
| SQL Fundamentals                | `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `CASE WHEN` |
| Joins                           | `INNER JOIN`, `LEFT JOIN`, Anti Join                             |
| Aggregations                    | `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`                    |
| Window Functions                | `ROW_NUMBER()`, `DENSE_RANK()`, `LEAD()`                         |
| Common Table Expressions (CTEs) | Basic CTE                                                        |
| Ranking Problems                | Top-N, Ranking Within Groups, Handling Ties                      |
| Date Functions                  | `DATEDIFF()`                                                     |
| Data Validation                 | Missing Records, Data Reconciliation                             |
| ETL Validation                  | Source vs Target Validation                                      |
| Analytical SQL                  | Customer Retention, Sales Analytics, Fraud Detection             |
| Production SQL                  | Performance Considerations, Indexing, Query Optimization         |

---

> [!IMPORTANT]
> **Repository Philosophy**
>
> This repository focuses on solving **real interview problems**, not textbook exercises.
>
> Every solution is written with the goal of demonstrating:
>
> * Clean and readable SQL
> * Production-ready query design
> * Multiple solution approaches
> * Performance awareness
> * Interview-ready problem-solving skills
>
> The repository will continue to grow with increasingly diverse interview questions covering SQL, ETL, Data Warehousing, Analytics, and Production Data Engineering scenarios.
