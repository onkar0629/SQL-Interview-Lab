# SQL Interview Lab

> [!NOTE]
>
> ## About This Repository
>
> **SQL Interview Lab** is a collection of real-world SQL interview questions designed for **Data Engineering** interview preparation.
>
> Every problem is inspired by actual interview patterns and production scenarios from leading technology and consulting companies. The focus is not only on writing correct SQL but also on understanding business requirements, choosing the right SQL approach, discussing performance considerations, and thinking like a Data Engineer.
>
> Each completed question includes:
>
> * Production-quality SQL solution
> * Most optimal solution
> * Alternative approaches when they provide meaningful value
> * Performance considerations
> * Common interview mistakes
> * Interview follow-up questions with answers
> * Professional documentation
>
> ---
>
> # Repository Structure
>
> ```text
> SQL-Interview-Lab/
> │
> ├── README.md
> │
> ├── Question_001.sql
> ├── Question_001.md
> │
> ├── Question_002.sql
> ├── Question_002.md
> │
> ├── Question_003.sql
> ├── Question_003.md
> │
> ├── ...
> │
> ├── Question_010.sql
> ├── Question_010.md
> │
> └── ...
> ```
>
> ---
>
> > [!IMPORTANT]
> >
> > ## Repository Workflow
> >
> > Every question in this repository follows the same workflow:
> >
> > ```text
> > Question_XXX.sql
> >        │
> >        ▼
> > Solve the Problem
> >        │
> >        ▼
> > Interview Review
> >        │
> >        ▼
> > Follow-up Questions
> >        │
> >        ▼
> > Most Optimal Solution
> >        │
> >        ▼
> > Alternative Approaches (when useful)
> >        │
> >        ▼
> > Question_XXX.md
> > ```
> >
> > This workflow mirrors a real technical interview while documenting production-ready SQL solutions.
>
> ---
>
> # Completed Questions
>
> | # | Question | Difficulty | Company Inspired | Business Domain | Interview Focus | Concepts |
> |---:|---|:---:|---|---|---|---|
> | 001 | Second Order Within 30 Days | 🟡 Medium | Amazon | E-Commerce | Customer Retention | `ROW_NUMBER()`, `LEAD()`, Conditional Aggregation, Date Functions |
> | 002 | Missing Warehouse Records | 🔴 Hard | Snowflake | Data Warehouse / ETL | ETL Validation | `NOT EXISTS`, `LEFT JOIN`, Anti Join, Data Reconciliation |
> | 003 | Inactive Riders | 🟡 Medium | Uber | Ride Sharing | Customer Activity Analysis | `NOT EXISTS`, `NOT IN`, NULL Handling, Anti Join |
> | 004 | Multiple Same-Day Transactions | 🔴 Hard | Microsoft | Banking | Fraud Detection | `GROUP BY`, `HAVING`, `COUNT(*)`, Aggregation |
> | 005 | Best-Selling Product per Category | 🔴 Hard | Amazon | E-Commerce | Sales Analytics | `SUM()`, `DENSE_RANK()`, Window Functions, Ranking |
> | 006 | Binge-Watching Sessions | 🔴 Hard | Netflix | Streaming | User Engagement | `COUNT(DISTINCT)`, `GROUP BY`, `HAVING` |
> | 007 | Frequently Restocked Products | 🔴 Hard | Walmart Global Tech | Inventory Management | Inventory Analysis | `COUNT(*)`, `GROUP BY`, `HAVING`, Indexing |
> | 008 | Salary Increment Events | 🔴 Hard | Microsoft | Human Resources | Salary History Analysis | `LAG()`, CTEs, Window Functions, Indexing |
> | 009 | Latest Order per Customer | 🔴 Hard | Amazon | E-Commerce | Latest Record per Group | `ROW_NUMBER()`, CTEs, `MAX()`, Top-1 per Group |
> | 010 | Highest-Value Order per Customer | 🔴 Hard | Google | E-Commerce | Top Value per Group | `DENSE_RANK()`, `RANK()`, `ROW_NUMBER()`, Tie Handling |
>
> ---
>
> # Difficulty Distribution
>
> | Difficulty | Questions Solved |
> |:---|---:|
> | 🟢 Easy | 0 |
> | 🟡 Medium | 2 |
> | 🔴 Hard | 8 |
> | **Total** | **10** |
>
> ---
>
> # Interview Topics Covered
>
> | Business Scenario | Status |
> |---|:---:|
> | Customer Retention | ✅ |
> | ETL Validation | ✅ |
> | Data Reconciliation | ✅ |
> | Customer Activity Analysis | ✅ |
> | Fraud Detection | ✅ |
> | Sales Analytics | ✅ |
> | User Engagement | ✅ |
> | Inventory Analysis | ✅ |
> | Salary History Analysis | ✅ |
> | Latest Record Analysis | ✅ |
> | Top-N / Top-Value Analysis | ✅ |
> | Ranking & Tie Handling | ✅ |
>
> ---
>
> # Concept Coverage
>
> | Category | Topics Covered |
> |---|---|
> | SQL Fundamentals | `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `CASE WHEN` |
> | Joins | `INNER JOIN`, `LEFT JOIN`, Anti Join, Self Join |
> | Subqueries | Correlated Subqueries, `EXISTS`, `NOT EXISTS`, `NOT IN` |
> | Aggregations | `COUNT()`, `COUNT(DISTINCT)`, `SUM()`, `AVG()`, `MIN()`, `MAX()` |
> | Window Functions | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LEAD()`, `LAG()` |
> | Common Table Expressions | Basic CTE |
> | Ranking Problems | Top-N, Latest Row per Group, Highest Value per Group, Tie Handling |
> | Date & Time | `DATEDIFF()`, Consecutive Dates, Effective Dates |
> | Data Validation | Missing Records, Source vs Target Validation, Reconciliation |
> | ETL Validation | Missing Loads, Source-to-Warehouse Comparison |
> | Analytical SQL | Customer Retention, Sales Analytics, User Engagement, Salary Change Detection |
> | Production SQL | Indexing, Query Optimization, Deterministic Ordering, Execution Plans |
>
> ---
>
> > [!IMPORTANT]
> > **Repository Philosophy**
> >
> > This repository focuses on solving **real interview problems**, not textbook exercises.
> >
> > Every solution is written with the goal of demonstrating:
> >
> > * Clean and readable SQL
> > * Production-ready query design
> > * Meaningful alternative approaches when applicable
> > * Performance awareness
> > * Strong interview problem-solving skills
> > * Business requirement understanding
> >
> > The repository will continue to grow with increasingly diverse SQL, ETL, Data Warehousing, Analytics, and Production Data Engineering scenarios.
