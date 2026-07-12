-- =====================================================
-- Topic: DISTINCT
-- Description:
-- DISTINCT removes duplicate values from the result.
-- It returns only unique different values.
--
-- Syntax:
-- SELECT DISTINCT column_name FROM table_name;
-- =====================================================


-- -------------------------------------------------------
-- 1. WITHOUT DISTINCT → Shows repeated/duplicate values
-- -------------------------------------------------------
SELECT department
FROM employee;

-- =====================================================
-- Output: (duplicates are visible)
-- ┌─────────────┐
-- │ department  │
-- ├─────────────┤
-- │ Engineering │  ← repeated
-- │ Marketing   │  ← repeated
-- │ Engineering │  ← duplicate
-- │ HR          │  ← repeated
-- │ Marketing   │  ← duplicate
-- │ Engineering │  ← duplicate
-- │ HR          │  ← duplicate
-- │ Marketing   │  ← duplicate
-- │ Engineering │  ← duplicate
-- │ HR          │  ← duplicate
-- └─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. WITH DISTINCT → Shows only unique values
-- -------------------------------------------------------
SELECT DISTINCT department
FROM employee;

-- =====================================================
-- Output: (no duplicates)
-- ┌─────────────┐
-- │ department  │
-- ├─────────────┤
-- │ Engineering │
-- │ Marketing   │
-- │ HR          │
-- └─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. DISTINCT on status column
-- -------------------------------------------------------
SELECT DISTINCT status
FROM employee;

-- =====================================================
-- Output:
-- ┌──────────┐
-- │  status  │
-- ├──────────┤
-- │ active   │
-- │ inactive │
-- └──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. DISTINCT on MULTIPLE columns
--    Returns unique combination of both columns
-- -------------------------------------------------------
SELECT DISTINCT department, status
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────┬──────────┐
-- │ department  │  status  │
-- ├─────────────┼──────────┤
-- │ Engineering │ active   │
-- │ Marketing   │ active   │
-- │ HR          │ active   │
-- │ HR          │ inactive │
-- └─────────────┴──────────┘
-- Note: Engineering+inactive and Marketing+inactive
--       do not appear because no such records exist
-- =====================================================


-- -------------------------------------------------------
-- 5. DISTINCT with ORDER BY
-- -------------------------------------------------------
SELECT DISTINCT department
FROM employee
ORDER BY department ASC;

-- =====================================================
-- Output: (alphabetically sorted)
-- ┌─────────────┐
-- │ department  │
-- ├─────────────┤
-- │ Engineering │
-- │ HR          │
-- │ Marketing   │
-- └─────────────┘
-- =====================================================