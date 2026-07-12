-- =====================================================
-- Topic: Aggregate Functions
-- Description:
-- Aggregate functions perform a calculation on
-- multiple rows and return ONE single result value.
--
-- ┌─────────┬────────────────────────────────────┐
-- │Function │ Description                        │
-- ├─────────┼────────────────────────────────────┤
-- │ COUNT() │ Count number of rows               │
-- │ SUM()   │ Total sum of column values         │
-- │ AVG()   │ Average of column values           │
-- │ MIN()   │ Smallest value in column           │
-- │ MAX()   │ Largest value in column            │
-- │ ROUND() │ Round decimal to N decimal places  │
-- └─────────┴────────────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. COUNT() → Count number of rows
--    COUNT(*)        → counts ALL rows including NULLs
--    COUNT(column)   → counts only NON-NULL values
-- -------------------------------------------------------

-- Total employees in company
SELECT COUNT(*) AS total_employees
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────────┐
-- │ total_employees │
-- ├─────────────────┤
-- │       10        │
-- └─────────────────┘
-- =====================================================

-- Count employees per department
SELECT department, COUNT(*) AS total
FROM employee
GROUP BY department;

-- =====================================================
-- Output:
-- ┌─────────────┬───────┐
-- │ department  │ total │
-- ├─────────────┼───────┤
-- │ Engineering │   4   │
-- │ Marketing   │   3   │
-- │ HR          │   3   │
-- └─────────────┴───────┘
-- =====================================================

-- Count only active employees
SELECT COUNT(*) AS active_employees
FROM employee
WHERE status = 'active';

-- =====================================================
-- Output:
-- ┌──────────────────┐
-- │ active_employees │
-- ├──────────────────┤
-- │        8         │
-- └──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. SUM() → Add up all values in a column
-- -------------------------------------------------------

-- Total salary of all employees
SELECT SUM(salary) AS total_salary
FROM employee;

-- =====================================================
-- Output:
-- ┌──────────────┐
-- │ total_salary │
-- ├──────────────┤
-- │  720000.00   │
-- └──────────────┘
-- =====================================================

-- Total salary per department
SELECT department, SUM(salary) AS total_salary
FROM employee
GROUP BY department
ORDER BY total_salary DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬──────────────┐
-- │ department  │ total_salary │
-- ├─────────────┼──────────────┤
-- │ Engineering │  358000.00   │
-- │ Marketing   │  197000.00   │
-- │ HR          │  165000.00   │
-- └─────────────┴──────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. AVG() → Calculate average value of a column
--    Use ROUND() to limit decimal places
-- -------------------------------------------------------

-- Average salary of all employees
SELECT ROUND(AVG(salary), 2) AS avg_salary
FROM employee;

-- =====================================================
-- Output:
-- ┌────────────┐
-- │ avg_salary │
-- ├────────────┤
-- │  72000.00  │
-- └────────────┘
-- =====================================================

-- Average salary per department
SELECT department,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employee
GROUP BY department
ORDER BY avg_salary DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬────────────┐
-- │ department  │ avg_salary │
-- ├─────────────┼────────────┤
-- │ Engineering │  89500.00  │
-- │ Marketing   │  65666.67  │
-- │ HR          │  55000.00  │
-- └─────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. MIN() → Find the smallest/lowest value
-- -------------------------------------------------------

-- Lowest salary in company
SELECT MIN(salary) AS lowest_salary
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │ lowest_salary │
-- ├───────────────┤
-- │   52000.00    │
-- └───────────────┘
-- =====================================================

-- Lowest salary per department
SELECT department, MIN(salary) AS lowest_salary
FROM employee
GROUP BY department;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┐
-- │ department  │ lowest_salary │
-- ├─────────────┼───────────────┤
-- │ Engineering │   85000.00    │
-- │ Marketing   │   60000.00    │
-- │ HR          │   52000.00    │
-- └─────────────┴───────────────┘
-- =====================================================

-- Earliest join date (oldest employee)
SELECT MIN(joined_date) AS first_joined
FROM employee;

-- =====================================================
-- Output:
-- ┌──────────────┐
-- │ first_joined │
-- ├──────────────┤
-- │  2019-11-30  │
-- └──────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. MAX() → Find the largest/highest value
-- -------------------------------------------------------

-- Highest salary in company
SELECT MAX(salary) AS highest_salary
FROM employee;

-- =====================================================
-- Output:
-- ┌────────────────┐
-- │ highest_salary │
-- ├────────────────┤
-- │   95000.00     │
-- └────────────────┘
-- =====================================================

-- Highest salary per department
SELECT department, MAX(salary) AS highest_salary
FROM employee
GROUP BY department;

-- =====================================================
-- Output:
-- ┌─────────────┬────────────────┐
-- │ department  │ highest_salary │
-- ├─────────────┼────────────────┤
-- │ Engineering │   95000.00     │
-- │ Marketing   │   70000.00     │
-- │ HR          │   58000.00     │
-- └─────────────┴────────────────┘
-- =====================================================

-- Latest join date (newest employee)
SELECT MAX(joined_date) AS last_joined
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────┐
-- │ last_joined │
-- ├─────────────┤
-- │ 2023-07-18  │
-- └─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. ROUND(value, decimal_places) → Round decimals
-- -------------------------------------------------------
SELECT ROUND(AVG(salary), 0) AS rounded_0_decimals,
       ROUND(AVG(salary), 1) AS rounded_1_decimal,
       ROUND(AVG(salary), 2) AS rounded_2_decimals
FROM employee;

-- =====================================================
-- Output:
-- ┌────────────────────┬───────────────────┬────────────────────┐
-- │ rounded_0_decimals │ rounded_1_decimal │ rounded_2_decimals │
-- ├────────────────────┼───────────────────┼────────────────────┤
-- │       72000        │     72000.0       │     72000.00       │
-- └────────────────────┴───────────────────┴────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 7. Complete Department Summary (All Functions Together)
-- -------------------------------------------------------
SELECT
    department,
    COUNT(*)              AS total_employees,
    SUM(salary)           AS total_salary,
    ROUND(AVG(salary), 2) AS avg_salary,
    MIN(salary)           AS min_salary,
    MAX(salary)           AS max_salary
FROM employee
GROUP BY department
ORDER BY total_employees DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬─────────────────┬──────────────┬────────────┬───────────┬────────────┐
-- │ department  │ total_employees │ total_salary │ avg_salary │ min_salary│ max_salary │
-- ├─────────────┼─────────────────┼──────────────┼────────────┼───────────┼────────────┤
-- │ Engineering │        4        │  358000.00   │  89500.00  │ 85000.00  │  95000.00  │
-- │ Marketing   │        3        │  197000.00   │  65666.67  │ 60000.00  │  70000.00  │
-- │ HR          │        3        │  165000.00   │  55000.00  │ 52000.00  │  58000.00  │
-- └─────────────┴─────────────────┴──────────────┴────────────┴───────────┴────────────┘
-- =====================================================