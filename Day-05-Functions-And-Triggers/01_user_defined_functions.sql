-- =====================================================
-- Topic: User Defined Functions (UDF)
-- Description:
-- A function is a reusable block of SQL or PL/pgSQL
-- code saved with a name in the database.
-- You pass inputs (parameters), it processes them,
-- and returns a result.
--
-- Think of it like a calculator:
-- You give inputs → it gives output.
--
-- Two types of functions in PostgreSQL:
-- 1. SQL Function   → Simple, just runs SQL statements
-- 2. PL/pgSQL Function → Procedural, has IF, LOOP, DECLARE
--
-- Key difference from Stored Procedures:
-- ┌──────────────────┬────────────────┬─────────────────┐
-- │ Feature          │ Function       │ Procedure       │
-- ├──────────────────┼────────────────┼─────────────────┤
-- │ Returns value    │ YES (required) │ Optional        │
-- │ Call with        │ SELECT         │ CALL            │
-- │ Use in query     │ YES            │ NO              │
-- │ Transaction ctrl │ NO             │ YES             │
-- └──────────────────┴────────────────┴─────────────────┘
-- =====================================================


-- =====================================================
-- PART 1: SQL FUNCTIONS
-- Simple functions written in plain SQL.
-- Best for straightforward calculations.
-- =====================================================


-- -------------------------------------------------------
-- 1. Basic SQL Function: calculate annual salary
--    Takes monthly salary → returns annual salary
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION get_annual_salary(
    p_monthly_salary NUMERIC
)
RETURNS NUMERIC
LANGUAGE sql
AS $$
    SELECT p_monthly_salary * 12;
$$;

-- Call the function
SELECT get_annual_salary(10000);

-- =====================================================
-- Output:
-- ┌────────────────────┐
-- │ get_annual_salary  │
-- ├────────────────────┤
-- │       120000       │
-- └────────────────────┘
-- =====================================================

-- Use it in a real query
SELECT
    name,
    salary          AS monthly_salary,
    get_annual_salary(salary) AS annual_salary
FROM employees
LIMIT 5;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────────┬───────────────┐
-- │     name      │ monthly_salary │ annual_salary │
-- ├───────────────┼────────────────┼───────────────┤
-- │ Alice Johnson │   120000.00    │  1440000.00   │
-- │ Bob Smith     │    85000.00    │   1020000.00  │
-- │ Charlie Brown │    95000.00    │   1140000.00  │
-- │ Diana Prince  │    70000.00    │    840000.00  │
-- │ Edward King   │    72000.00    │    864000.00  │
-- └───────────────┴────────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. SQL Function: get employee full info as text
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION get_employee_info(
    p_employee_id INT
)
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT CONCAT(name, ' | ', job_title, ' | Salary: ', salary)
    FROM employees
    WHERE id = p_employee_id;
$$;

SELECT get_employee_info(1);

-- =====================================================
-- Output:
-- ┌─────────────────────────────────────────────────────────┐
-- │                   get_employee_info                     │
-- ├─────────────────────────────────────────────────────────┤
-- │ Alice Johnson | Engineering Manager | Salary: 120000.00 │
-- └─────────────────────────────────────────────────────────┘
-- =====================================================


-- =====================================================
-- PART 2: PL/pgSQL FUNCTIONS
-- Procedural functions with DECLARE, IF, LOOP, etc.
-- Best for complex logic with conditions.
-- =====================================================


-- -------------------------------------------------------
-- 3. PL/pgSQL Function: salary grade label
--    Returns grade based on salary range
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION get_salary_grade(
    p_salary NUMERIC
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_grade VARCHAR;
    -- DECLARE section → define local variables
BEGIN
    -- IF / ELSIF / ELSE → decision logic
    IF p_salary >= 100000 THEN
        v_grade := 'A - Executive';
    ELSIF p_salary >= 80000 THEN
        v_grade := 'B - Senior';
    ELSIF p_salary >= 60000 THEN
        v_grade := 'C - Mid Level';
    ELSE
        v_grade := 'D - Junior';
    END IF;

    RETURN v_grade;
    -- RETURN → sends the result back to the caller
END;
$$;

-- Use in query
SELECT
    name,
    salary,
    get_salary_grade(salary) AS grade
FROM employees
ORDER BY salary DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────┬───────────────┐
-- │     name      │  salary   │     grade     │
-- ├───────────────┼───────────┼───────────────┤
-- │ Alice Johnson │ 120000.00 │ A - Executive │
-- │ Fiona Green   │ 110000.00 │ A - Executive │
-- │ Helen Troy    │  98000.00 │ B - Senior    │
-- │ Charlie Brown │  95000.00 │ B - Senior    │
-- │ Oscar Wilde   │  92000.00 │ B - Senior    │
-- │ Ivan Black    │  88000.00 │ B - Senior    │
-- │ Bob Smith     │  85000.00 │ B - Senior    │
-- │ Kevin Hart    │  82000.00 │ B - Senior    │
-- │ Nina Simone   │  78000.00 │ C - Mid Level │
-- │ Julia Roberts │  76000.00 │ C - Mid Level │
-- │ Edward King   │  72000.00 │ C - Mid Level │
-- │ Diana Prince  │  70000.00 │ C - Mid Level │
-- │ Mike Jordan   │  68000.00 │ C - Mid Level │
-- │ Laura Palmer  │  65000.00 │ C - Mid Level │
-- │ George White  │  58000.00 │ D - Junior    │
-- └───────────────┴───────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. Function with OUT Parameters
--    OUT parameters let you return multiple values
--    without using RETURNS TABLE
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION get_department_stats(
    p_dept_id    INT,
    OUT total_employees INT,
    OUT avg_salary      NUMERIC,
    OUT max_salary      NUMERIC,
    OUT min_salary      NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT
        COUNT(*),
        ROUND(AVG(salary), 2),
        MAX(salary),
        MIN(salary)
    INTO
        total_employees,
        avg_salary,
        max_salary,
        min_salary
    FROM employees
    WHERE department_id = p_dept_id;
END;
$$;

-- Call function with OUT parameters
SELECT * FROM get_department_stats(1);

-- =====================================================
-- Output:
-- ┌─────────────────┬────────────┬────────────┬────────────┐
-- │ total_employees │ avg_salary │ max_salary │ min_salary │
-- ├─────────────────┼────────────┼────────────┼────────────┤
-- │        5        │  101000.00 │  120000.00 │  88000.00  │
-- └─────────────────┴────────────┴────────────┴────────────┘
-- =====================================================

-- Check all departments
SELECT
    d.name AS department,
    (get_department_stats(d.id)).total_employees,
    (get_department_stats(d.id)).avg_salary,
    (get_department_stats(d.id)).max_salary,
    (get_department_stats(d.id)).min_salary
FROM departments d;

-- =====================================================
-- Output:
-- ┌─────────────┬─────────────────┬────────────┬────────────┬────────────┐
-- │ department  │ total_employees │ avg_salary │ max_salary │ min_salary │
-- ├─────────────┼─────────────────┼────────────┼────────────┼────────────┤
-- │ Engineering │        5        │ 101000.00  │ 120000.00  │  88000.00  │
-- │ Marketing   │        3        │  78333.33  │  85000.00  │  72000.00  │
-- │ HR          │        2        │  64000.00  │  70000.00  │  58000.00  │
-- │ Finance     │        2        │  87000.00  │  98000.00  │  76000.00  │
-- │ Sales       │        3        │  71666.67  │  82000.00  │  65000.00  │
-- └─────────────┴─────────────────┴────────────┴────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. RETURNS TABLE → Return multiple rows from a function
--    Like a mini SELECT query wrapped in a function
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION get_employees_by_department(
    p_dept_name VARCHAR
)
RETURNS TABLE (
    employee_id   INT,
    employee_name VARCHAR,
    job_title     VARCHAR,
    salary        NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            e.id,
            e.name,
            e.job_title,
            e.salary
        FROM employees e
        INNER JOIN departments d ON e.department_id = d.id
        WHERE d.name ILIKE p_dept_name
        ORDER BY e.salary DESC;
        -- RETURN QUERY → sends back a full result set
END;
$$;

SELECT * FROM get_employees_by_department('Engineering');

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┬─────────────────────┬───────────┐
-- │ employee_id │ employee_name │      job_title      │  salary   │
-- ├─────────────┼───────────────┼─────────────────────┼───────────┤
-- │      1      │ Alice Johnson │ Engineering Manager │ 120000.00 │
-- │      6      │ Fiona Green   │ Lead Engineer       │ 110000.00 │
-- │      3      │ Charlie Brown │ Senior Engineer     │  95000.00 │
-- │     15      │ Oscar Wilde   │ Senior Engineer     │  92000.00 │
-- │      9      │ Ivan Black    │ Engineer            │  88000.00 │
-- └─────────────┴───────────────┴─────────────────────┴───────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. Function Overloading
--    Same function name, different parameter types.
--    PostgreSQL picks the right one based on input type.
-- -------------------------------------------------------

-- Version 1: takes employee ID (INT)
CREATE OR REPLACE FUNCTION get_salary(
    p_id INT
)
RETURNS NUMERIC
LANGUAGE sql
AS $$
    SELECT salary FROM employees WHERE id = p_id;
$$;

-- Version 2: takes employee name (VARCHAR)
CREATE OR REPLACE FUNCTION get_salary(
    p_name VARCHAR
)
RETURNS NUMERIC
LANGUAGE sql
AS $$
    SELECT salary FROM employees WHERE name ILIKE p_name;
$$;

-- PostgreSQL figures out which version to use
SELECT get_salary(1);            -- uses INT version
SELECT get_salary('Bob Smith');  -- uses VARCHAR version

-- =====================================================
-- Output (INT version):
-- ┌────────────┐
-- │ get_salary │
-- ├────────────┤
-- │  120000.00 │
-- └────────────┘
--
-- Output (VARCHAR version):
-- ┌────────────┐
-- │ get_salary │
-- ├────────────┤
-- │   85000.00 │
-- └────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 7. Function with a Loop: calculate salary growth
--    Projects salary after N years with annual raises
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION project_salary(
    p_current_salary NUMERIC,
    p_years          INT,
    p_raise_percent  NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC := p_current_salary;
    v_year   INT     := 0;
BEGIN
    -- LOOP → repeats until EXIT condition is met
    LOOP
        EXIT WHEN v_year >= p_years;
        v_salary := v_salary + (v_salary * p_raise_percent / 100);
        v_year   := v_year + 1;
    END LOOP;

    RETURN ROUND(v_salary, 2);
END;
$$;

-- Project Alice's salary after 5 years with 10% annual raise
SELECT
    name,
    salary                            AS current_salary,
    project_salary(salary, 5, 10)     AS salary_after_5_years
FROM employees
WHERE id = 1;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────────┬──────────────────────┐
-- │     name      │ current_salary │ salary_after_5_years │
-- ├───────────────┼────────────────┼──────────────────────┤
-- │ Alice Johnson │   120000.00    │       193261.20      │
-- └───────────────┴────────────────┴──────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 8. Drop Functions
-- -------------------------------------------------------
-- DROP FUNCTION get_annual_salary(NUMERIC);
-- DROP FUNCTION get_employee_info(INT);
-- DROP FUNCTION get_salary_grade(NUMERIC);
-- DROP FUNCTION get_department_stats(INT);
-- DROP FUNCTION get_employees_by_department(VARCHAR);
-- DROP FUNCTION get_salary(INT);
-- DROP FUNCTION get_salary(VARCHAR);
-- DROP FUNCTION project_salary(NUMERIC, INT, NUMERIC);


-- =====================================================
-- ADVANTAGES of UDFs:
-- → Reusable logic across multiple queries
-- → Keeps business logic in the database
-- → Reduces repetition in application code
-- → Can be used inside SELECT like any column
--
-- LIMITATIONS:
-- → Harder to debug than application code
-- → PL/pgSQL has a learning curve
-- → Overuse can make the DB harder to maintain
--
-- INTERVIEW QUESTIONS:
-- Q: Difference between Function and Procedure?
-- A: Functions return a value and can be used in
--    SELECT. Procedures use CALL and can manage
--    transactions.
--
-- Q: What is RETURNS TABLE?
-- A: It lets a function return multiple rows,
--    making it act like a table in FROM clause.
--
-- Q: What is function overloading?
-- A: Same function name with different parameter
--    types. PostgreSQL picks the right version.
-- =====================================================