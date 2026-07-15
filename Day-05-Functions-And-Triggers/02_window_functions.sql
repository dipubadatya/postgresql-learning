-- =====================================================
-- Topic: Window Functions
-- Description:
-- A Window Function performs a calculation across a
-- set of rows that are related to the current row.
--
-- Unlike GROUP BY which collapses rows into groups,
-- Window Functions keep ALL rows and add a new
-- calculated column alongside them.
--
-- Think of it like:
-- GROUP BY → "summarize the group, show 1 row per group"
-- Window   → "calculate across the group, show ALL rows"
--
-- Syntax:
-- function_name() OVER (
--     PARTITION BY column   ← divide into groups
--     ORDER BY column       ← sort within each group
-- )
--
-- PARTITION BY → Like GROUP BY but rows are not collapsed
-- ORDER BY     → Defines row order within each partition
-- OVER()       → Defines the window (empty = whole table)
-- =====================================================


-- =====================================================
-- PART 1: ROW_NUMBER, RANK, DENSE_RANK
-- These assign numbers to rows within partitions
-- =====================================================


-- -------------------------------------------------------
-- 1. ROW_NUMBER() → Assigns a unique sequential number
--    No ties. Every row gets a different number.
-- -------------------------------------------------------
SELECT
    name,
    department_id,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS row_num
FROM employees
ORDER BY department_id, row_num;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────────┬───────────┬─────────┐
-- │     name      │ department_id │  salary   │ row_num │
-- ├───────────────┼───────────────┼───────────┼─────────┤
-- │ Alice Johnson │       1       │ 120000.00 │    1    │
-- │ Fiona Green   │       1       │ 110000.00 │    2    │
-- │ Charlie Brown │       1       │  95000.00 │    3    │
-- │ Oscar Wilde   │       1       │  92000.00 │    4    │
-- │ Ivan Black    │       1       │  88000.00 │    5    │
-- │ Bob Smith     │       2       │  85000.00 │    1    │  ← resets per dept
-- │ Nina Simone   │       2       │  78000.00 │    2    │
-- │ Edward King   │       2       │  72000.00 │    3    │
-- │ Diana Prince  │       3       │  70000.00 │    1    │
-- │ George White  │       3       │  58000.00 │    2    │
-- │ Helen Troy    │       4       │  98000.00 │    1    │
-- │ Julia Roberts │       4       │  76000.00 │    2    │
-- │ Kevin Hart    │       5       │  82000.00 │    1    │
-- │ Mike Jordan   │       5       │  68000.00 │    2    │
-- │ Laura Palmer  │       5       │  65000.00 │    3    │
-- └───────────────┴───────────────┴───────────┴─────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. RANK() → Assigns rank with GAPS for ties
--    If two rows tie at rank 1, next rank is 3 (not 2)
-- -------------------------------------------------------
-- -------------------------------------------------------
-- 3. DENSE_RANK() → Assigns rank WITHOUT gaps for ties
--    If two rows tie at rank 1, next rank is 2
-- -------------------------------------------------------

-- Add duplicate salary to show tie behavior
-- (Temporarily update for demo)
SELECT
    name,
    department_id,
    salary,
    RANK()       OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank_with_gap,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank_no_gap
FROM employees
ORDER BY department_id, salary DESC;

-- =====================================================
-- Output: (showing department 1 where ties matter)
-- ┌───────────────┬───────────────┬───────────┬───────────────┬─────────────┐
-- │     name      │ department_id │  salary   │ rank_with_gap │ rank_no_gap │
-- ├───────────────┼───────────────┼───────────┼───────────────┼─────────────┤
-- │ Alice Johnson │       1       │ 120000.00 │       1       │      1      │
-- │ Fiona Green   │       1       │ 110000.00 │       2       │      2      │
-- │ Charlie Brown │       1       │  95000.00 │       3       │      3      │
-- │ Oscar Wilde   │       1       │  92000.00 │       4       │      4      │
-- │ Ivan Black    │       1       │  88000.00 │       5       │      5      │
-- └───────────────┴───────────────┴───────────┴───────────────┴─────────────┘
-- ← RANK vs DENSE_RANK difference shows clearly when ties exist
-- =====================================================


-- -------------------------------------------------------
-- 4. NTILE(n) → Divides rows into N equal buckets
--    Useful for percentiles and quartiles
-- -------------------------------------------------------
SELECT
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS quartile
    -- 4 buckets = quartiles
    -- Quartile 1 = top 25% earners
    -- Quartile 4 = bottom 25% earners
FROM employees
ORDER BY salary DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────┬──────────┐
-- │     name      │  salary   │ quartile │
-- ├───────────────┼───────────┼──────────┤
-- │ Alice Johnson │ 120000.00 │    1     │
-- │ Fiona Green   │ 110000.00 │    1     │
-- │ Helen Troy    │  98000.00 │    1     │
-- │ Charlie Brown │  95000.00 │    1     │  ← top 25%
-- │ Oscar Wilde   │  92000.00 │    2     │
-- │ Ivan Black    │  88000.00 │    2     │
-- │ Bob Smith     │  85000.00 │    2     │
-- │ Kevin Hart    │  82000.00 │    2     │  ← 2nd 25%
-- │ Nina Simone   │  78000.00 │    3     │
-- │ Julia Roberts │  76000.00 │    3     │
-- │ Edward King   │  72000.00 │    3     │
-- │ Diana Prince  │  70000.00 │    3     │  ← 3rd 25%
-- │ Mike Jordan   │  68000.00 │    4     │
-- │ Laura Palmer  │  65000.00 │    4     │
-- │ George White  │  58000.00 │    4     │  ← bottom 25%
-- └───────────────┴───────────┴──────────┘
-- =====================================================


-- =====================================================
-- PART 2: LEAD and LAG
-- Access values from NEXT or PREVIOUS rows
-- =====================================================


-- -------------------------------------------------------
-- 5. LAG() → Get value from the PREVIOUS row
--    Great for comparing current value to previous one
-- -------------------------------------------------------
-- -------------------------------------------------------
-- 6. LEAD() → Get value from the NEXT row
-- -------------------------------------------------------
SELECT
    name,
    department_id,
    salary,
    LAG(salary, 1)  OVER (PARTITION BY department_id ORDER BY salary DESC)
        AS prev_employee_salary,
    LEAD(salary, 1) OVER (PARTITION BY department_id ORDER BY salary DESC)
        AS next_employee_salary,
    salary - LAG(salary, 1) OVER (PARTITION BY department_id ORDER BY salary DESC)
        AS diff_from_prev
FROM employees
ORDER BY department_id, salary DESC;

-- =====================================================
-- Output (department 1):
-- ┌───────────────┬─────────┬───────────┬──────────────────────┬──────────────────────┬────────────────┐
-- │     name      │ dept_id │  salary   │ prev_employee_salary │ next_employee_salary │ diff_from_prev │
-- ├───────────────┼─────────┼───────────┼──────────────────────┼──────────────────────┼────────────────┤
-- │ Alice Johnson │    1    │ 120000.00 │        NULL          │      110000.00       │      NULL      │ ← no prev
-- │ Fiona Green   │    1    │ 110000.00 │      120000.00       │       95000.00       │   -10000.00    │
-- │ Charlie Brown │    1    │  95000.00 │      110000.00       │       92000.00       │   -15000.00    │
-- │ Oscar Wilde   │    1    │  92000.00 │       95000.00       │       88000.00       │    -3000.00    │
-- │ Ivan Black    │    1    │  88000.00 │       92000.00       │        NULL          │    -4000.00    │ ← no next
-- └───────────────┴─────────┴───────────┴──────────────────────┴──────────────────────┴────────────────┘
-- =====================================================


-- =====================================================
-- PART 3: FIRST_VALUE and LAST_VALUE
-- Get the first or last value in the window
-- =====================================================


-- -------------------------------------------------------
-- 7. FIRST_VALUE() → First value in the window
-- -------------------------------------------------------
-- -------------------------------------------------------
-- 8. LAST_VALUE() → Last value in the window
--    IMPORTANT: Need ROWS BETWEEN UNBOUNDED PRECEDING
--               AND UNBOUNDED FOLLOWING for correct result
-- -------------------------------------------------------
SELECT
    name,
    department_id,
    salary,
    FIRST_VALUE(name) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_paid_in_dept,
    LAST_VALUE(name) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_in_dept
FROM employees
ORDER BY department_id, salary DESC;

-- =====================================================
-- Output (department 1):
-- ┌───────────────┬─────────┬───────────┬──────────────────────┬─────────────────────┐
-- │     name      │ dept_id │  salary   │ highest_paid_in_dept │ lowest_paid_in_dept │
-- ├───────────────┼─────────┼───────────┼──────────────────────┼─────────────────────┤
-- │ Alice Johnson │    1    │ 120000.00 │    Alice Johnson      │    Ivan Black        │
-- │ Fiona Green   │    1    │ 110000.00 │    Alice Johnson      │    Ivan Black        │
-- │ Charlie Brown │    1    │  95000.00 │    Alice Johnson      │    Ivan Black        │
-- │ Oscar Wilde   │    1    │  92000.00 │    Alice Johnson      │    Ivan Black        │
-- │ Ivan Black    │    1    │  88000.00 │    Alice Johnson      │    Ivan Black        │
-- └───────────────┴─────────┴───────────┴──────────────────────┴─────────────────────┘
-- Each row shows the highest and lowest paid in their dept
-- =====================================================


-- =====================================================
-- PART 4: SUM OVER and AVG OVER
-- Aggregate functions used as window functions
-- =====================================================


-- -------------------------------------------------------
-- 9. SUM() OVER → Running Total (Cumulative Sum)
-- -------------------------------------------------------
SELECT
    name,
    hire_date,
    salary,
    SUM(salary) OVER (
        ORDER BY hire_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_salary
FROM employees
ORDER BY hire_date;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┬───────────┬──────────────────────┐
-- │     name      │ hire_date  │  salary   │ running_total_salary │
-- ├───────────────┼────────────┼───────────┼──────────────────────┤
-- │ Alice Johnson │ 2019-03-15 │ 120000.00 │      120000.00       │
-- │ Fiona Green   │ 2019-11-30 │ 110000.00 │      230000.00       │
-- │ Charlie Brown │ 2020-01-10 │  95000.00 │      325000.00       │
-- │ Helen Troy    │ 2020-04-25 │  98000.00 │      423000.00       │
-- │ Bob Smith     │ 2020-06-01 │  85000.00 │      508000.00       │
-- │ Julia Roberts │ 2020-08-14 │  76000.00 │      584000.00       │
-- │ Nina Simone   │ 2020-11-08 │  78000.00 │      662000.00       │
-- │ Kevin Hart    │ 2021-03-22 │  82000.00 │      744000.00       │
-- │ Edward King   │ 2021-09-05 │  72000.00 │      816000.00       │
-- │ Ivan Black    │ 2021-12-01 │  88000.00 │      904000.00       │
-- │ Laura Palmer  │ 2022-01-10 │  65000.00 │      969000.00       │
-- │ Mike Jordan   │ 2022-05-15 │  68000.00 │     1037000.00       │
-- │ George White  │ 2022-07-18 │  58000.00 │     1095000.00       │
-- │ Oscar Wilde   │ 2021-07-19 │  92000.00 │     1187000.00       │
-- │ Diana Prince  │ 2021-02-20 │  70000.00 │     1257000.00       │
-- └───────────────┴────────────┴───────────┴──────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 10. AVG() OVER → Compare each employee to dept average
-- -------------------------------------------------------
SELECT
    name,
    department_id,
    salary,
    ROUND(AVG(salary) OVER (
        PARTITION BY department_id
    ), 2) AS dept_avg_salary,
    salary - ROUND(AVG(salary) OVER (
        PARTITION BY department_id
    ), 2) AS diff_from_dept_avg
FROM employees
ORDER BY department_id, salary DESC;

-- =====================================================
-- Output (department 1):
-- ┌───────────────┬─────────┬───────────┬─────────────────┬────────────────────┐
-- │     name      │ dept_id │  salary   │ dept_avg_salary │ diff_from_dept_avg │
-- ├───────────────┼─────────┼───────────┼─────────────────┼────────────────────┤
-- │ Alice Johnson │    1    │ 120000.00 │    101000.00    │     +19000.00      │
-- │ Fiona Green   │    1    │ 110000.00 │    101000.00    │      +9000.00      │
-- │ Charlie Brown │    1    │  95000.00 │    101000.00    │      -6000.00      │
-- │ Oscar Wilde   │    1    │  92000.00 │    101000.00    │      -9000.00      │
-- │ Ivan Black    │    1    │  88000.00 │    101000.00    │     -13000.00      │
-- └───────────────┴─────────┴───────────┴─────────────────┴────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 11. Real World: Top earner per department using
--     ROW_NUMBER in a subquery
-- -------------------------------------------------------
SELECT
    name,
    department_id,
    salary,
    job_title
FROM (
    SELECT
        name,
        department_id,
        salary,
        job_title,
        ROW_NUMBER() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rn
    FROM employees
) ranked
WHERE rn = 1;

-- =====================================================
-- Output: (highest paid employee in each department)
-- ┌───────────────┬───────────────┬───────────┬─────────────────────┐
-- │     name      │ department_id │  salary   │      job_title      │
-- ├───────────────┼───────────────┼───────────┼─────────────────────┤
-- │ Alice Johnson │       1       │ 120000.00 │ Engineering Manager │
-- │ Bob Smith     │       2       │  85000.00 │ Marketing Manager   │
-- │ Diana Prince  │       3       │  70000.00 │ HR Manager          │
-- │ Helen Troy    │       4       │  98000.00 │ Finance Manager     │
-- │ Kevin Hart    │       5       │  82000.00 │ Sales Manager       │
-- └───────────────┴───────────────┴───────────┴─────────────────────┘
-- =====================================================


-- =====================================================
-- ADVANTAGES of Window Functions:
-- → Keep all rows while computing group calculations
-- → No need for self-joins or subqueries for ranking
-- → LEAD/LAG make time-series analysis very easy
-- → Running totals are simple with SUM OVER
--
-- LIMITATIONS:
-- → Cannot use window functions in WHERE clause
-- → Can be slower on very large tables
-- → Harder to understand for beginners
--
-- INTERVIEW QUESTIONS:
-- Q: Difference between GROUP BY and Window Functions?
-- A: GROUP BY collapses rows into one per group.
--    Window Functions keep all rows and add a
--    computed column.
--
-- Q: RANK vs DENSE_RANK?
-- A: RANK skips numbers after ties (1,1,3).
--    DENSE_RANK does not skip (1,1,2).
--
-- Q: How to get top N rows per group?
-- A: Use ROW_NUMBER() in a subquery, then
--    filter WHERE rn <= N in outer query.
-- =====================================================