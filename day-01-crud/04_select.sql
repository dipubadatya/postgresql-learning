-- =====================================================
-- Topic: SELECT
-- Description:
-- SELECT retrieves data from a table.
-- =====================================================

-- Retrieve all columns
SELECT *
FROM person;

-- Retrieve specific columns
SELECT name, age
FROM person;

-- Retrieve records with a condition
SELECT *
FROM person
WHERE age > 23;