-- =====================================================
-- PostgreSQL Practice Set 1
-- Topic:
-- Basic Queries
-- Filtering
-- Sorting
-- Aggregate Functions
-- =====================================================


---------------------------------------------------------
-- Question 1
-- Find all different departments.
---------------------------------------------------------

SELECT DISTINCT department
FROM employees;



---------------------------------------------------------
-- Question 2
-- Display employees from highest salary to lowest salary.
---------------------------------------------------------

SELECT *
FROM employees
ORDER BY salary DESC;



---------------------------------------------------------
-- Question 3
-- Display employees from lowest salary to highest salary.
---------------------------------------------------------

SELECT *
FROM employees
ORDER BY salary ASC;



---------------------------------------------------------
-- Question 4
-- Display only first 3 records.
---------------------------------------------------------

SELECT *
FROM employees
LIMIT 3;



---------------------------------------------------------
-- Question 5
-- Display employees whose name starts with A.
---------------------------------------------------------

SELECT *
FROM employees
WHERE name LIKE 'A%';



---------------------------------------------------------
-- Question 6
-- Display employees whose name ends with A.
---------------------------------------------------------

SELECT *
FROM employees
WHERE name LIKE '%A';



---------------------------------------------------------
-- Question 7
-- Display employees whose name contains "an".
---------------------------------------------------------

SELECT *
FROM employees
WHERE name ILIKE '%an%';



---------------------------------------------------------
-- Question 8
-- Display employees whose name has exactly 4 characters.
---------------------------------------------------------

SELECT *
FROM employees
WHERE LENGTH(name)=4;



---------------------------------------------------------
-- Question 9
-- Display employees whose salary is greater than 50000.
---------------------------------------------------------

SELECT *
FROM employees
WHERE salary > 50000;



---------------------------------------------------------
-- Question 10
-- Display employees whose salary is between
-- 30000 and 60000.
---------------------------------------------------------

SELECT *
FROM employees
WHERE salary BETWEEN 30000 AND 60000;