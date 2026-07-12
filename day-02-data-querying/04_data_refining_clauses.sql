-- =====================================================
-- Topic: Data Refining Clauses
-- Description:
-- These clauses help filter, sort, limit, skip,
-- and group the data fetched from a table.
--
-- ┌─────────────┬──────────────────────────────────────────┐
-- │   Clause    │ Description                              │
-- ├─────────────┼──────────────────────────────────────────┤
-- │ WHERE       │ Filter rows based on condition           │
-- │ AND         │ Both conditions must be true             │
-- │ OR          │ At least one condition must be true      │
-- │ NOT         │ Reverse/negate a condition               │
-- │ ORDER BY    │ Sort results ASC or DESC                 │
-- │ LIMIT       │ Return only N number of rows             │
-- │ OFFSET      │ Skip N rows before returning             │
-- │ BETWEEN     │ Filter values in a range (inclusive)     │
-- │ NOT BETWEEN │ Filter values outside a range            │
-- │ IN          │ Match values from a list                 │
-- │ NOT IN      │ Exclude values from a list               │
-- │ LIKE        │ Pattern matching (case-sensitive)        │
-- │ ILIKE       │ Pattern matching (case-insensitive)      │
-- │ NOT LIKE    │ Exclude pattern matches                  │
-- │ IS NULL     │ Check if value is NULL                   │
-- │ IS NOT NULL │ Check if value is NOT NULL               │
-- │ GROUP BY    │ Group rows with same values              │
-- │ HAVING      │ Filter groups after GROUP BY             │
-- └─────────────┴──────────────────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. WHERE → Filter rows based on a condition
-- -------------------------------------------------------
SELECT name, department, salary
FROM employee
WHERE department = 'Engineering';

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┬──────────┐
-- │     name      │ department  │  salary  │
-- ├───────────────┼─────────────┼──────────┤
-- │ Alice Johnson │ Engineering │ 85000.00 │
-- │ Charlie Brown │ Engineering │ 90000.00 │
-- │ Fiona Green   │ Engineering │ 95000.00 │
-- │ Ivan Black    │ Engineering │ 88000.00 │
-- └───────────────┴─────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. AND → Both conditions must be TRUE
-- -------------------------------------------------------
SELECT name, department, status
FROM employee
WHERE department = 'Engineering'
AND status = 'active';

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┬────────┐
-- │     name      │ department  │ status │
-- ├───────────────┼─────────────┼────────┤
-- │ Alice Johnson │ Engineering │ active │
-- │ Charlie Brown │ Engineering │ active │
-- │ Fiona Green   │ Engineering │ active │
-- │ Ivan Black    │ Engineering │ active │
-- └───────────────┴─────────────┴────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. OR → At least one condition must be TRUE
-- -------------------------------------------------------
SELECT name, department
FROM employee
WHERE department = 'HR'
OR department = 'Marketing';

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┐
-- │     name      │ department │
-- ├───────────────┼────────────┤
-- │ Bob Smith     │ Marketing  │
-- │ Diana Prince  │ HR         │
-- │ Edward King   │ Marketing  │
-- │ George White  │ HR         │
-- │ Helen Troy    │ Marketing  │
-- │ Julia Roberts │ HR         │
-- └───────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. NOT → Negate / reverse a condition
-- -------------------------------------------------------
SELECT name, department
FROM employee
WHERE NOT department = 'Engineering';

-- =====================================================
-- Output: (everyone except Engineering)
-- ┌───────────────┬────────────┐
-- │     name      │ department │
-- ├───────────────┼────────────┤
-- │ Bob Smith     │ Marketing  │
-- │ Diana Prince  │ HR         │
-- │ Edward King   │ Marketing  │
-- │ George White  │ HR         │
-- │ Helen Troy    │ Marketing  │
-- │ Julia Roberts │ HR         │
-- └───────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. ORDER BY → Sort results
--    ASC  = Ascending  (low to high, A to Z)  ← Default
--    DESC = Descending (high to low, Z to A)
-- -------------------------------------------------------

-- Sort by salary highest to lowest
SELECT name, salary
FROM employee
ORDER BY salary DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Fiona Green   │ 95000.00 │
-- │ Charlie Brown │ 90000.00 │
-- │ Ivan Black    │ 88000.00 │
-- │ Alice Johnson │ 85000.00 │
-- │ Edward King   │ 70000.00 │
-- │ Helen Troy    │ 67000.00 │
-- │ Bob Smith     │ 60000.00 │
-- │ Julia Roberts │ 58000.00 │
-- │ Diana Prince  │ 55000.00 │
-- │ George White  │ 52000.00 │
-- └───────────────┴──────────┘
-- =====================================================

-- Sort by department A-Z, then salary high to low
SELECT name, department, salary
FROM employee
ORDER BY department ASC, salary DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┬──────────┐
-- │     name      │ department  │  salary  │
-- ├───────────────┼─────────────┼──────────┤
-- │ Fiona Green   │ Engineering │ 95000.00 │
-- │ Charlie Brown │ Engineering │ 90000.00 │
-- │ Ivan Black    │ Engineering │ 88000.00 │
-- │ Alice Johnson │ Engineering │ 85000.00 │
-- │ Julia Roberts │ HR          │ 58000.00 │
-- │ Diana Prince  │ HR          │ 55000.00 │
-- │ George White  │ HR          │ 52000.00 │
-- │ Edward King   │ Marketing   │ 70000.00 │
-- │ Helen Troy    │ Marketing   │ 67000.00 │
-- │ Bob Smith     │ Marketing   │ 60000.00 │
-- └───────────────┴─────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. LIMIT → Return only specific number of rows
-- -------------------------------------------------------
SELECT name, salary
FROM employee
ORDER BY salary DESC
LIMIT 3;

-- =====================================================
-- Output: (Top 3 highest paid employees)
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Fiona Green   │ 95000.00 │
-- │ Charlie Brown │ 90000.00 │
-- │ Ivan Black    │ 88000.00 │
-- └───────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 7. OFFSET → Skip N rows before returning results
--    LIMIT + OFFSET together = Pagination
--    Page 1 → LIMIT 3 OFFSET 0  (rows 1,2,3)
--    Page 2 → LIMIT 3 OFFSET 3  (rows 4,5,6)
--    Page 3 → LIMIT 3 OFFSET 6  (rows 7,8,9)
-- -------------------------------------------------------
SELECT name, salary
FROM employee
ORDER BY salary DESC
LIMIT 3 OFFSET 3;

-- =====================================================
-- Output: (Skipped top 3, shows next 3)
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Alice Johnson │ 85000.00 │
-- │ Edward King   │ 70000.00 │
-- │ Helen Troy    │ 67000.00 │
-- └───────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 8. BETWEEN → Filter values within a range (INCLUSIVE)
--    Includes both the start and end values
--    Works on numbers, dates, text
-- -------------------------------------------------------
SELECT name, salary
FROM employee
WHERE salary BETWEEN 60000 AND 90000;

-- =====================================================
-- Output: (salary >= 60000 AND salary <= 90000)
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Alice Johnson │ 85000.00 │
-- │ Bob Smith     │ 60000.00 │
-- │ Charlie Brown │ 90000.00 │
-- │ Edward King   │ 70000.00 │
-- │ Helen Troy    │ 67000.00 │
-- │ Ivan Black    │ 88000.00 │
-- └───────────────┴──────────┘
-- =====================================================

-- BETWEEN with DATE
SELECT name, joined_date
FROM employee
WHERE joined_date BETWEEN '2021-01-01' AND '2022-12-31';

-- =====================================================
-- Output: (employees who joined in 2021 or 2022)
-- ┌───────────────┬─────────────┐
-- │     name      │ joined_date │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │ 2021-03-15  │
-- │ Bob Smith     │ 2022-06-01  │
-- │ Edward King   │ 2021-09-05  │
-- │ Helen Troy    │ 2022-04-25  │
-- │ Ivan Black    │ 2021-12-01  │
-- └───────────────┴─────────────┘
-- =====================================================

-- BETWEEN with AGE
SELECT name, age
FROM employee
WHERE age BETWEEN 25 AND 30;

-- =====================================================
-- Output:
-- ┌───────────────┬─────┐
-- │     name      │ age │
-- ├───────────────┼─────┤
-- │ Alice Johnson │  30 │
-- │ Bob Smith     │  28 │
-- │ Diana Prince  │  26 │
-- │ Fiona Green   │  29 │
-- │ Ivan Black    │  27 │
-- └───────────────┴─────┘
-- =====================================================


-- -------------------------------------------------------
-- 9. NOT BETWEEN → Filter values OUTSIDE a range
--    Opposite of BETWEEN
-- -------------------------------------------------------
SELECT name, salary
FROM employee
WHERE salary NOT BETWEEN 60000 AND 85000;

-- =====================================================
-- Output: (salary < 60000 OR salary > 85000)
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Charlie Brown │ 90000.00 │
-- │ Diana Prince  │ 55000.00 │
-- │ Fiona Green   │ 95000.00 │
-- │ George White  │ 52000.00 │
-- └───────────────┴──────────┘
-- =====================================================

-- NOT BETWEEN with DATE
SELECT name, joined_date
FROM employee
WHERE joined_date NOT BETWEEN '2021-01-01' AND '2022-12-31';

-- =====================================================
-- Output: (employees who did NOT join in 2021 or 2022)
-- ┌───────────────┬─────────────┐
-- │     name      │ joined_date │
-- ├───────────────┼─────────────┤
-- │ Charlie Brown │ 2020-01-10  │
-- │ Diana Prince  │ 2023-02-20  │
-- │ Fiona Green   │ 2019-11-30  │
-- │ George White  │ 2023-07-18  │
-- │ Julia Roberts │ 2020-08-14  │
-- └───────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 10. IN → Match any value from a given list
--     Cleaner alternative to multiple OR conditions
-- -------------------------------------------------------
SELECT name, department
FROM employee
WHERE department IN ('HR', 'Marketing');

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┐
-- │     name      │ department │
-- ├───────────────┼────────────┤
-- │ Bob Smith     │ Marketing  │
-- │ Diana Prince  │ HR         │
-- │ Edward King   │ Marketing  │
-- │ George White  │ HR         │
-- │ Helen Troy    │ Marketing  │
-- │ Julia Roberts │ HR         │
-- └───────────────┴────────────┘
-- =====================================================

-- IN with numbers
SELECT name, age
FROM employee
WHERE age IN (24, 27, 30, 33);

-- =====================================================
-- Output:
-- ┌───────────────┬─────┐
-- │     name      │ age │
-- ├───────────────┼─────┤
-- │ Alice Johnson │  30 │
-- │ George White  │  24 │
-- │ Ivan Black    │  27 │
-- │ Julia Roberts │  33 │
-- └───────────────┴─────┘
-- =====================================================


-- -------------------------------------------------------
-- 11. NOT IN → Exclude values from a given list
--     Opposite of IN
-- -------------------------------------------------------
SELECT name, department
FROM employee
WHERE department NOT IN ('HR', 'Marketing');

-- =====================================================
-- Output: (only Engineering remains)
-- ┌───────────────┬─────────────┐
-- │     name      │ department  │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │ Engineering │
-- │ Charlie Brown │ Engineering │
-- │ Fiona Green   │ Engineering │
-- │ Ivan Black    │ Engineering │
-- └───────────────┴─────────────┘
-- =====================================================

-- NOT IN with numbers
SELECT name, age
FROM employee
WHERE age NOT IN (24, 27, 30, 33);

-- =====================================================
-- Output:
-- ┌───────────────┬─────┐
-- │     name      │ age │
-- ├───────────────┼─────┤
-- │ Bob Smith     │  28 │
-- │ Charlie Brown │  35 │
-- │ Diana Prince  │  26 │
-- │ Edward King   │  32 │
-- │ Fiona Green   │  29 │
-- │ Helen Troy    │  31 │
-- └───────────────┴─────┘
-- =====================================================


-- -------------------------------------------------------
-- 12. LIKE → Pattern matching (case-sensitive)
--     %  → Matches zero or more characters (wildcard)
--     _  → Matches exactly one character
-- -------------------------------------------------------

-- Names starting with 'A'
SELECT name FROM employee WHERE name LIKE 'A%';

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Alice Johnson │
-- └───────────────┘
-- =====================================================

-- Names ending with 'n'
SELECT name FROM employee WHERE name LIKE '%n';

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Alice Johnson │
-- │ Ivan Black    │
-- └───────────────┘
-- =====================================================

-- Names containing 'ro'
SELECT name FROM employee WHERE name LIKE '%ro%';

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Charlie Brown │
-- │ Julia Roberts │
-- └───────────────┘
-- =====================================================

-- Names where second character is 'o'
SELECT name FROM employee WHERE name LIKE '_o%';

-- =====================================================
-- Output:
-- ┌──────────────┐
-- │     name     │
-- ├──────────────┤
-- │ Bob Smith    │
-- └──────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 13. ILIKE → Case-insensitive pattern matching
-- -------------------------------------------------------
SELECT name FROM employee WHERE name ILIKE 'alice%';

-- =====================================================
-- Output: (works even though 'alice' is lowercase)
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Alice Johnson │
-- └───────────────┘
-- =====================================================

SELECT name FROM employee WHERE name ILIKE '%BROWN%';

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Charlie Brown │
-- └───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 14. NOT LIKE → Exclude pattern matches
-- -------------------------------------------------------
SELECT name
FROM employee
WHERE name NOT LIKE 'A%';

-- =====================================================
-- Output: (everyone except names starting with A)
-- ┌───────────────┐
-- │     name      │
-- ├───────────────┤
-- │ Bob Smith     │
-- │ Charlie Brown │
-- │ Diana Prince  │
-- │ Edward King   │
-- │ Fiona Green   │
-- │ George White  │
-- │ Helen Troy    │
-- │ Ivan Black    │
-- │ Julia Roberts │
-- └───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 15. IS NULL → Find rows where column has no value
-- -------------------------------------------------------
SELECT name, salary
FROM employee
WHERE salary IS NULL;

-- =====================================================
-- Output: (no nulls in our data, so empty result)
-- ┌──────┬────────┐
-- │ name │ salary │
-- ├──────┼────────┤
-- │ (0 rows)      │
-- └───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 16. IS NOT NULL → Find rows where column has a value
-- -------------------------------------------------------
SELECT name, salary
FROM employee
WHERE salary IS NOT NULL;

-- =====================================================
-- Output: (all employees with salary values)
-- ┌───────────────┬──────────┐
-- │     name      │  salary  │
-- ├───────────────┼──────────┤
-- │ Alice Johnson │ 85000.00 │
-- │ Bob Smith     │ 60000.00 │
-- │ Charlie Brown │ 90000.00 │
-- │ Diana Prince  │ 55000.00 │
-- │ Edward King   │ 70000.00 │
-- │ Fiona Green   │ 95000.00 │
-- │ George White  │ 52000.00 │
-- │ Helen Troy    │ 67000.00 │
-- │ Ivan Black    │ 88000.00 │
-- │ Julia Roberts │ 58000.00 │
-- └───────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 17. GROUP BY → Group rows with same column values
--     Always used with aggregate functions
-- -------------------------------------------------------
SELECT department, COUNT(*) AS total_employees
FROM employee
GROUP BY department;

-- =====================================================
-- Output:
-- ┌─────────────┬─────────────────┐
-- │ department  │ total_employees │
-- ├─────────────┼─────────────────┤
-- │ Engineering │        4        │
-- │ Marketing   │        3        │
-- │ HR          │        3        │
-- └─────────────┴─────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 18. HAVING → Filter AFTER GROUP BY
--     WHERE  → filters rows   (before grouping)
--     HAVING → filters groups (after  grouping)
-- -------------------------------------------------------
SELECT department, COUNT(*) AS total_employees
FROM employee
GROUP BY department
HAVING COUNT(*) >= 4;

-- =====================================================
-- Output: (only departments with 4 or more employees)
-- ┌─────────────┬─────────────────┐
-- │ department  │ total_employees │
-- ├─────────────┼─────────────────┤
-- │ Engineering │        4        │
-- └─────────────┴─────────────────┘
-- =====================================================

-- WHERE vs HAVING Example
-- WHERE filters before GROUP BY
-- HAVING filters after GROUP BY
SELECT department, ROUND(AVG(salary), 2) AS avg_salary
FROM employee
WHERE status = 'active'          -- Step 1: filter only active employees
GROUP BY department              -- Step 2: group them by department
HAVING AVG(salary) > 65000;     -- Step 3: keep groups where avg > 65000

-- =====================================================
-- Output:
-- ┌─────────────┬────────────┐
-- │ department  │ avg_salary │
-- ├─────────────┼────────────┤
-- │ Engineering │  89500.00  │
-- │ Marketing   │  65666.67  │
-- └─────────────┴────────────┘
-- =====================================================