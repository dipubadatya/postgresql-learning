-- =====================================================
-- PostgreSQL Practice Set 2
-- Topic:
-- Aggregate Functions
-- GROUP BY
-- HAVING
-- =====================================================



---------------------------------------------------------
-- Question 1
-- Find total number of employees.
---------------------------------------------------------

SELECT COUNT(*)
FROM employees;



---------------------------------------------------------
-- Question 2
-- Find total number of employees in each department.
---------------------------------------------------------

SELECT department,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department;



---------------------------------------------------------
-- Question 3
-- Find employee(s) with lowest salary.
---------------------------------------------------------

SELECT *
FROM employees
WHERE salary=(
SELECT MIN(salary)
FROM employees
);



---------------------------------------------------------
-- Question 4
-- Find employee(s) with highest salary.
---------------------------------------------------------

SELECT *
FROM employees
WHERE salary=(
SELECT MAX(salary)
FROM employees
);



---------------------------------------------------------
-- Question 5
-- Find total salary paid in Loan department.
---------------------------------------------------------

SELECT SUM(salary)
FROM employees
WHERE department='Loan';



---------------------------------------------------------
-- Question 6
-- Find average salary in Loan department.
---------------------------------------------------------

SELECT AVG(salary)
FROM employees
WHERE department='Loan';



---------------------------------------------------------
-- Question 7
-- Find total salary paid in every department.
---------------------------------------------------------

SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department;



---------------------------------------------------------
-- Question 8
-- Find average salary in every department.
---------------------------------------------------------

SELECT department,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department;



---------------------------------------------------------
-- Question 9
-- Find highest salary in each department.
---------------------------------------------------------

SELECT department,
       MAX(salary) AS highest_salary
FROM employees
GROUP BY department;



---------------------------------------------------------
-- Question 10
-- Find lowest salary in each department.
---------------------------------------------------------

SELECT department,
       MIN(salary) AS lowest_salary
FROM employees
GROUP BY department;



---------------------------------------------------------
-- Question 11
-- Find departments having more than 3 employees.
---------------------------------------------------------

SELECT department,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 3;



---------------------------------------------------------
-- Question 12
-- Display departments ordered by highest total salary.
---------------------------------------------------------

SELECT department,
       SUM(salary) AS total_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC;