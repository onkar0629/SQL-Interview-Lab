# SQL Interview Question #006

![Difficulty](https://img.shields.io/badge/Difficulty-Hard-red?style=flat-square)
![Company](https://img.shields.io/badge/Inspired-Netflix-orange?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Streaming-success?style=flat-square)

---

> [!NOTE]
>
> ## Question
>
> ### Business Context
>
> The Content Analytics team wants to identify **binge-watching sessions**.
>
> A user is considered a binge watcher if they watch **3 or more different movies on the same day**.
>
> This report is used to measure user engagement and recommend premium subscription plans.
>
> ### Problem Statement
>
> Identify users who watched **3 or more distinct movies on the same day**.
>
> Return the following columns:
>
> * `user_id`
> * `watch_date`
> * `total_movies`
>
> ### Expected Output
>
> * Count only **distinct** movies watched on the same day.
> * Ignore repeated watches of the same movie.
> * Return users having **3 or more distinct movies**.
> * Sort the result by:
>
>   * `user_id`
    >   * `watch_date`
>
> ### Constraints
>
> * A user may watch the same movie multiple times in one day.
> * Count only unique (`DISTINCT`) movies.
> * Write production-quality SQL.
> * The production table contains billions of watch events.

---

> [!TIP]
>
> ## Approach
>
> Before writing SQL, I broke the problem into four logical steps:
>
> * Group records by user and watch date.
> * Count the number of **distinct movies** watched.
> * Keep only users with three or more distinct movies.
> * Return the final result in sorted order.

---

# My Solution

```sql
-- Step 1: Group watch history by user and date
SELECT

    user_id,

    watch_date,

    -- Count only distinct movies watched
    COUNT(DISTINCT movie_id) AS total_movies

FROM watch_history

GROUP BY

    user_id,

    watch_date

-- Step 2: Keep only binge-watching sessions
HAVING COUNT(DISTINCT movie_id) >= 3

-- Step 3: Return the final result
ORDER BY

    user_id,

    watch_date;
```

> [!TIP]
> **Interview Note**
>
> The key requirement in this problem was **"different movies"**.
>
> Using `COUNT(*)` or `COUNT(movie_id)` would incorrectly count repeated watches of the same movie.
>
> The correct solution uses `COUNT(DISTINCT movie_id)` to count only unique movies watched by each user on the same day.

---

# Expected Output

| user_id | watch_date | total_movies |
| ------: | ---------- | -----------: |
|       1 | 2024-01-01 |            3 |
|       4 | 2024-01-04 |            4 |

---


# Most Optimal Solution

```sql id="fwv2da"
-- Step 1: Group watch history by user and watch date
SELECT

    user_id,

    watch_date,

    -- Count only unique movies watched
    COUNT(DISTINCT movie_id) AS total_movies

FROM watch_history

GROUP BY

    user_id,

    watch_date

-- Step 2: Return only binge-watching sessions
HAVING COUNT(DISTINCT movie_id) >= 3

-- Step 3: Sort the final result
ORDER BY

    user_id,

    watch_date;
```

---

# Alternative Approach 1 — Common Table Expression (CTE)

```sql id="m2k7qt"
-- Step 1: Calculate the number of distinct movies
-- watched by each user per day
WITH binge_sessions AS
(
    SELECT

        user_id,

        watch_date,

        COUNT(DISTINCT movie_id) AS total_movies

    FROM watch_history

    GROUP BY

        user_id,

        watch_date
)

-- Step 2: Return only qualifying sessions
SELECT

    user_id,

    watch_date,

    total_movies

FROM binge_sessions

WHERE total_movies >= 3

ORDER BY

    user_id,

    watch_date;
```

---

# Alternative Approach 2 — Aggregate First, Then Join Back

```sql id="c3f8nd"
-- Step 1: Identify binge-watching sessions
WITH binge_sessions AS
(
    SELECT

        user_id,

        watch_date

    FROM watch_history

    GROUP BY

        user_id,

        watch_date

    HAVING COUNT(DISTINCT movie_id) >= 3
)

-- Step 2: Return all watch records
-- belonging to those sessions
SELECT

    wh.watch_id,

    wh.user_id,

    wh.movie_id,

    wh.watch_date,

    wh.watch_time

FROM watch_history wh

JOIN binge_sessions bs
    ON wh.user_id = bs.user_id
   AND wh.watch_date = bs.watch_date

ORDER BY

    wh.user_id,

    wh.watch_date,

    wh.watch_time;
```

> [!TIP]
> This approach is useful when the business requires **all watch history records** instead of only aggregated results.

---

> [!IMPORTANT]
>
> ## Why This Approach?
>
> ### My Solution
>
> **Strengths**
>
> * Simple and easy to understand.
> * Correctly counts only distinct movies.
> * Efficient for reporting and dashboard queries.
>
> ---
>
> ### Most Optimal Solution
>
> **Strengths**
>
> * Minimal execution plan.
> * Easy to maintain.
> * Performs well on very large datasets with proper indexing.
>
> ---
>
> ### Alternative Approaches
>
> **CTE**
>
> * Improves readability.
> * Useful for multi-step ETL pipelines.
>
> **Aggregate + Join**
>
> * Best when detailed watch history records are required after identifying qualifying sessions.

---

> [!IMPORTANT]
>
> ## Performance Considerations
>
> ### Recommended Index
>
> ```sql
> CREATE INDEX idx_watch_history_user_date_movie
> ON watch_history(user_id, watch_date, movie_id);
> ```
>
> **Why?**
>
> * Optimizes grouping by `user_id` and `watch_date`.
> * Improves performance of `COUNT(DISTINCT movie_id)`.
> * Reduces scanning on very large watch history tables.
>
> **Time Complexity**
>
> Approximately **O(N)** with appropriate indexing.
>
> **Production Notes**
>
> * Use `COUNT(DISTINCT column)` only when the business requirement explicitly requires unique values.
> * Review execution plans (`EXPLAIN`) for large production datasets.
> * Consider table partitioning by `watch_date` for massive event tables.

---

> [!WARNING]
>
> ## Common Interview Mistakes
>
> * Using `COUNT(*)` instead of `COUNT(DISTINCT movie_id)`.
> * Ignoring repeated watches of the same movie.
> * Forgetting to group by both `user_id` and `watch_date`.
> * Returning users with exactly two distinct movies.
> * Missing the `ORDER BY` requirement.

---

> [!TIP]
>
> ## Follow-up Variations
>
> 1. Return all watch history records for binge-watching sessions.
> 2. Find users who watched **5 or more distinct movies** on the same day.
> 3. Identify users who watched **3 consecutive movies within 6 hours**.
> 4. Find the day on which each user watched the maximum number of distinct movies.
> 5. Calculate the average number of distinct movies watched per day for each user.

---

> [!NOTE]
>
> ## Interview Takeaway
>
> This question reinforces an important SQL interview skill: **translating business language into the correct aggregation logic**. The phrase **"different movies"** directly maps to `COUNT(DISTINCT movie_id)`, making it essential to understand the requirement before choosing the aggregation function. It also demonstrates that simple aggregation is often the most appropriate solution when sequence analysis is not required.
