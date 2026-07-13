-- =====================================================
-- Topic: CASE Expression
-- Description:
-- CASE is like an IF-ELSE condition in SQL.
-- It checks conditions one by one and returns
-- a value for the FIRST condition that is TRUE.
-- If no condition matches, it returns the ELSE value.
-- If no ELSE is written, it returns NULL.
--
-- Syntax:
-- CASE
--     WHEN condition1 THEN result1
--     WHEN condition2 THEN result2
--     WHEN condition3 THEN result3
--     ELSE default_result
-- END
-- =====================================================

CREATE TABLE employee (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    department VARCHAR(50),
    salary     NUMERIC(10,2),
    age        INT,
    experience INT
);

INSERT INTO employee (name, department, salary, age, experience)
VALUES
    ('Alice Johnson',  'Engineering', 95000.00, 30, 7),
    ('Bob Smith',      'Marketing',   45000.00, 28, 3),
    ('Charlie Brown',  'Engineering', 75000.00, 35, 10),
    ('Diana Prince',   'HR',          38000.00, 26, 2),
    ('Edward King',    'Marketing',   62000.00, 32, 6),
    ('Fiona Green',    'Engineering', 110000.00, 40, 15),
    ('George White',   'HR',          42000.00, 24, 1),
    ('Helen Troy',     'Finance',     85000.00, 33, 9);

SELECT * FROM employee;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬─────────────┬───────────┬─────┬────────────┐
-- │ id │     name      │ department  │  salary   │ age │ experience │
-- ├────┼───────────────┼─────────────┼───────────┼─────┼────────────┤
-- │  1 │ Alice Johnson │ Engineering │  95000.00 │  30 │     7      │
-- │  2 │ Bob Smith     │ Marketing   │  45000.00 │  28 │     3      │
-- │  3 │ Charlie Brown │ Engineering │  75000.00 │  35 │    10      │
-- │  4 │ Diana Prince  │ HR          │  38000.00 │  26 │     2      │
-- │  5 │ Edward King   │ Marketing   │  62000.00 │  32 │     6      │
-- │  6 │ Fiona Green   │ Engineering │ 110000.00 │  40 │    15      │
-- │  7 │ George White  │ HR          │  42000.00 │  24 │     1      │
-- │  8 │ Helen Troy    │ Finance     │  85000.00 │  33 │     9      │
-- └────┴───────────────┴─────────────┴───────────┴─────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. Basic CASE → Salary Category Label
--    Assign a label based on salary range
-- -------------------------------------------------------
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'High'
        WHEN salary >= 60000  THEN 'Medium'
        ELSE                       'Low'
    END AS salary_category
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────┬─────────────────┐
-- │     name      │  salary   │ salary_category │
-- ├───────────────┼───────────┼─────────────────┤
-- │ Alice Johnson │  95000.00 │ Medium          │
-- │ Bob Smith     │  45000.00 │ Low             │
-- │ Charlie Brown │  75000.00 │ Medium          │
-- │ Diana Prince  │  38000.00 │ Low             │
-- │ Edward King   │  62000.00 │ Medium          │
-- │ Fiona Green   │ 110000.00 │ High            │
-- │ George White  │  42000.00 │ Low             │
-- │ Helen Troy    │  85000.00 │ Medium          │
-- └───────────────┴───────────┴─────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. CASE with Experience → Seniority Level
-- -------------------------------------------------------
SELECT
    name,
    experience,
    CASE
        WHEN experience >= 10 THEN 'Senior'
        WHEN experience >= 5  THEN 'Mid-Level'
        WHEN experience >= 1  THEN 'Junior'
        ELSE                       'Fresher'
    END AS seniority_level
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┬─────────────────┐
-- │     name      │ experience │ seniority_level │
-- ├───────────────┼────────────┼─────────────────┤
-- │ Alice Johnson │     7      │ Mid-Level       │
-- │ Bob Smith     │     3      │ Junior          │
-- │ Charlie Brown │    10      │ Senior          │
-- │ Diana Prince  │     2      │ Junior          │
-- │ Edward King   │     6      │ Mid-Level       │
-- │ Fiona Green   │    15      │ Senior          │
-- │ George White  │     1      │ Junior          │
-- │ Helen Troy    │     9      │ Mid-Level       │
-- └───────────────┴────────────┴─────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. CASE inside ORDER BY → Custom Sort Order
--    Sort departments in a custom priority order
--    Engineering → 1st, Finance → 2nd, rest → 3rd
-- -------------------------------------------------------
SELECT name, department
FROM employee
ORDER BY
    CASE department
        WHEN 'Engineering' THEN 1
        WHEN 'Finance'     THEN 2
        ELSE                    3
    END;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┐
-- │     name      │ department  │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │ Engineering │  ← Priority 1
-- │ Charlie Brown │ Engineering │  ← Priority 1
-- │ Fiona Green   │ Engineering │  ← Priority 1
-- │ Helen Troy    │ Finance     │  ← Priority 2
-- │ Bob Smith     │ Marketing   │  ← Priority 3
-- │ Edward King   │ Marketing   │  ← Priority 3
-- │ Diana Prince  │ HR          │  ← Priority 3
-- │ George White  │ HR          │  ← Priority 3
-- └───────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. CASE with Aggregate → Count by category
-- -------------------------------------------------------
SELECT
    COUNT(CASE WHEN salary >= 100000 THEN 1 END) AS high_salary_count,
    COUNT(CASE WHEN salary >= 60000
               AND salary < 100000  THEN 1 END) AS medium_salary_count,
    COUNT(CASE WHEN salary < 60000  THEN 1 END) AS low_salary_count
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────────┬─────────────────────┬──────────────────┐
-- │ high_salary_count │ medium_salary_count │ low_salary_count │
-- ├───────────────────┼─────────────────────┼──────────────────┤
-- │         1         │          4          │        3         │
-- └───────────────────┴─────────────────────┴──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. CASE with UPDATE → Update values conditionally
--    Give a raise based on experience level
-- -------------------------------------------------------
UPDATE employee
SET salary = CASE
    WHEN experience >= 10 THEN salary * 1.20   -- 20% raise
    WHEN experience >= 5  THEN salary * 1.10   -- 10% raise
    ELSE                       salary * 1.05   -- 5% raise
END;

SELECT name, experience, salary FROM employee;

-- =====================================================
-- Output: (salary updated based on experience)
-- ┌───────────────┬────────────┬───────────┐
-- │     name      │ experience │  salary   │
-- ├───────────────┼────────────┼───────────┤
-- │ Alice Johnson │     7      │ 104500.00 │  ← 10% raise
-- │ Bob Smith     │     3      │  47250.00 │  ←  5% raise
-- │ Charlie Brown │    10      │  90000.00 │  ← 20% raise
-- │ Diana Prince  │     2      │  39900.00 │  ←  5% raise
-- │ Edward King   │     6      │  68200.00 │  ← 10% raise
-- │ Fiona Green   │    15      │ 132000.00 │  ← 20% raise
-- │ George White  │     1      │  44100.00 │  ←  5% raise
-- │ Helen Troy    │     9      │  93500.00 │  ← 10% raise
-- └───────────────┴────────────┴───────────┘
-- =====================================================

DROP TABLE employee;