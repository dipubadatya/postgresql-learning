-- =====================================================
-- Topic: Common Table Expressions (CTE)
-- Description:
-- A CTE (WITH clause) is a temporary named result set
-- that exists only during the execution of one query.
-- It is defined before the main SELECT statement.
--
-- Think of it like creating a temporary view
-- that lives only for one query.
--
-- Why use CTE?
-- → Break complex queries into readable steps
-- → Avoid deeply nested subqueries
-- → Reuse the same subquery multiple times
-- → Write recursive queries (hierarchy trees)
--
-- Syntax:
-- WITH cte_name AS (
--     SELECT ...
-- )
-- SELECT * FROM cte_name;
-- =====================================================


-- =====================================================
-- PART 1: Basic CTE
-- =====================================================


-- -------------------------------------------------------
-- 1. Simple CTE: Get employees above average salary
-- -------------------------------------------------------
WITH avg_salary AS (
    -- Step 1: Calculate the company average salary
    SELECT ROUND(AVG(salary), 2) AS company_avg
    FROM employees
)
-- Step 2: Use the CTE in the main query
SELECT
    e.name,
    e.salary,
    a.company_avg,
    e.salary - a.company_avg AS above_avg_by
FROM employees e
CROSS JOIN avg_salary a
WHERE e.salary > a.company_avg
ORDER BY e.salary DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────┬─────────────┬─────────────┐
-- │     name      │  salary   │ company_avg │ above_avg_by│
-- ├───────────────┼───────────┼─────────────┼─────────────┤
-- │ Alice Johnson │ 120000.00 │   82466.67  │  37533.33   │
-- │ Fiona Green   │ 110000.00 │   82466.67  │  27533.33   │
-- │ Helen Troy    │  98000.00 │   82466.67  │  15533.33   │
-- │ Charlie Brown │  95000.00 │   82466.67  │  12533.33   │
-- │ Oscar Wilde   │  92000.00 │   82466.67  │   9533.33   │
-- │ Ivan Black    │  88000.00 │   82466.67  │   5533.33   │
-- │ Bob Smith     │  85000.00 │   82466.67  │   2533.33   │
-- │ Kevin Hart    │  82000.00 │   82466.67  │    -466.67  │
-- └───────────────┴───────────┴─────────────┴─────────────┘
-- =====================================================


-- =====================================================
-- PART 2: Multiple CTEs
-- Chain multiple CTEs together in one query
-- =====================================================


-- -------------------------------------------------------
-- 2. Multiple CTEs: Department analysis report
-- -------------------------------------------------------
WITH
-- CTE 1: Calculate department summary
dept_summary AS (
    SELECT
        department_id,
        COUNT(*)                    AS headcount,
        ROUND(AVG(salary), 2)       AS avg_salary,
        SUM(salary)                 AS total_payroll,
        MAX(salary)                 AS top_salary
    FROM employees
    GROUP BY department_id
),
-- CTE 2: Find top earner per department
top_earners AS (
    SELECT DISTINCT ON (department_id)
        department_id,
        name  AS top_earner_name,
        salary AS top_earner_salary
    FROM employees
    ORDER BY department_id, salary DESC
)
-- Main query: join CTEs with departments table
SELECT
    d.name              AS department,
    ds.headcount,
    ds.avg_salary,
    ds.total_payroll,
    te.top_earner_name,
    te.top_earner_salary
FROM departments d
INNER JOIN dept_summary ds  ON d.id = ds.department_id
INNER JOIN top_earners  te  ON d.id = te.department_id
ORDER BY ds.total_payroll DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────┬────────────┬───────────────┬─────────────────┬──────────────────┐
-- │ department  │ headcount │ avg_salary │ total_payroll │ top_earner_name │ top_earner_salary │
-- ├─────────────┼───────────┼────────────┼───────────────┼─────────────────┼──────────────────┤
-- │ Engineering │     5     │ 101000.00  │  505000.00    │  Alice Johnson  │    120000.00      │
-- │ Finance     │     2     │  87000.00  │  174000.00    │  Helen Troy     │     98000.00      │
-- │ Marketing   │     3     │  78333.33  │  235000.00    │  Bob Smith      │     85000.00      │
-- │ Sales       │     3     │  71666.67  │  215000.00    │  Kevin Hart     │     82000.00      │
-- │ HR          │     2     │  64000.00  │  128000.00    │  Diana Prince   │     70000.00      │
-- └─────────────┴───────────┴────────────┴───────────────┴─────────────────┴──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. CTE with Window Function: salary rank inside CTE
-- -------------------------------------------------------
WITH ranked_employees AS (
    SELECT
        name,
        department_id,
        salary,
        job_title,
        RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)
SELECT
    r.name,
    d.name     AS department,
    r.salary,
    r.job_title,
    r.salary_rank
FROM ranked_employees r
INNER JOIN departments d ON r.department_id = d.id
WHERE r.salary_rank <= 2    -- top 2 earners per department
ORDER BY d.name, r.salary_rank;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┬───────────┬─────────────────────┬─────────────┐
-- │     name      │ department  │  salary   │      job_title      │ salary_rank │
-- ├───────────────┼─────────────┼───────────┼─────────────────────┼─────────────┤
-- │ Alice Johnson │ Engineering │ 120000.00 │ Engineering Manager │      1      │
-- │ Fiona Green   │ Engineering │ 110000.00 │ Lead Engineer       │      2      │
-- │ Helen Troy    │ Finance     │  98000.00 │ Finance Manager     │      1      │
-- │ Julia Roberts │ Finance     │  76000.00 │ Financial Analyst   │      2      │
-- │ Diana Prince  │ HR          │  70000.00 │ HR Manager          │      1      │
-- │ George White  │ HR          │  58000.00 │ HR Analyst          │      2      │
-- │ Bob Smith     │ Marketing   │  85000.00 │ Marketing Manager   │      1      │
-- │ Nina Simone   │ Marketing   │  78000.00 │ Senior Marketer     │      2      │
-- │ Kevin Hart    │ Sales       │  82000.00 │ Sales Manager       │      1      │
-- │ Mike Jordan   │ Sales       │  68000.00 │ Sales Rep           │      2      │
-- └───────────────┴─────────────┴───────────┴─────────────────────┴─────────────┘
-- =====================================================


-- =====================================================
-- PART 3: Recursive CTE
-- A CTE that references itself to traverse hierarchies
-- like org charts, folder trees, or category trees.
--
-- Syntax:
-- WITH RECURSIVE cte_name AS (
--     -- Base case: starting point (anchor)
--     SELECT ... (non-recursive part)
--
--     UNION ALL
--
--     -- Recursive case: join CTE with itself
--     SELECT ... FROM table JOIN cte_name ON ...
-- )
-- SELECT * FROM cte_name;
-- =====================================================


-- -------------------------------------------------------
-- 4. Recursive CTE: Employee hierarchy (org chart)
--    Start from top-level employees (manager_id IS NULL)
--    Then find their reports, then those reports, etc.
-- -------------------------------------------------------
WITH RECURSIVE org_chart AS (

    -- BASE CASE: Top level employees (no manager)
    SELECT
        id,
        name,
        job_title,
        manager_id,
        salary,
        0 AS level,
        -- level 0 = CEO / top management
        name::TEXT AS hierarchy_path
        -- hierarchy_path shows the chain like:
        -- Alice Johnson > Charlie Brown
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- RECURSIVE CASE: Find direct reports
    SELECT
        e.id,
        e.name,
        e.job_title,
        e.manager_id,
        e.salary,
        oc.level + 1,
        -- each level goes deeper in the org chart
        oc.hierarchy_path || ' > ' || e.name
        -- builds path like: Alice > Charlie > NewPerson
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT
    REPEAT('  ', level) || name AS org_structure,
    -- REPEAT('  ', level) adds indentation per level
    job_title,
    salary,
    level,
    hierarchy_path
FROM org_chart
ORDER BY hierarchy_path;

-- =====================================================
-- Output:
-- ┌────────────────────────────┬─────────────────────┬───────────┬───────┬───────────────────────────────────────┐
-- │        org_structure       │      job_title      │  salary   │ level │           hierarchy_path              │
-- ├────────────────────────────┼─────────────────────┼───────────┼───────┼───────────────────────────────────────┤
-- │ Alice Johnson              │ Engineering Manager │ 120000.00 │   0   │ Alice Johnson                         │
-- │   Charlie Brown            │ Senior Engineer     │  95000.00 │   1   │ Alice Johnson > Charlie Brown         │
-- │   Fiona Green              │ Lead Engineer       │ 110000.00 │   1   │ Alice Johnson > Fiona Green           │
-- │   Ivan Black               │ Engineer            │  88000.00 │   1   │ Alice Johnson > Ivan Black            │
-- │   Oscar Wilde              │ Senior Engineer     │  92000.00 │   1   │ Alice Johnson > Oscar Wilde           │
-- │ Bob Smith                  │ Marketing Manager   │  85000.00 │   0   │ Bob Smith                             │
-- │   Edward King              │ Marketing Analyst   │  72000.00 │   1   │ Bob Smith > Edward King               │
-- │   Nina Simone              │ Senior Marketer     │  78000.00 │   1   │ Bob Smith > Nina Simone               │
-- │ Diana Prince               │ HR Manager          │  70000.00 │   0   │ Diana Prince                          │
-- │   George White             │ HR Analyst          │  58000.00 │   1   │ Diana Prince > George White           │
-- │ Helen Troy                 │ Finance Manager     │  98000.00 │   0   │ Helen Troy                            │
-- │   Julia Roberts            │ Financial Analyst   │  76000.00 │   1   │ Helen Troy > Julia Roberts            │
-- │ Kevin Hart                 │ Sales Manager       │  82000.00 │   0   │ Kevin Hart                            │
-- │   Laura Palmer             │ Sales Rep           │  65000.00 │   1   │ Kevin Hart > Laura Palmer             │
-- │   Mike Jordan              │ Sales Rep           │  68000.00 │   1   │ Kevin Hart > Mike Jordan              │
-- └────────────────────────────┴─────────────────────┴───────────┴───────┴───────────────────────────────────────┘
-- Indentation visually shows the org structure
-- =====================================================


-- -------------------------------------------------------
-- 5. Recursive CTE: Find all reports under Alice (id=1)
-- -------------------------------------------------------
WITH RECURSIVE alice_team AS (

    -- Base: start with Alice
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE id = 1

    UNION ALL

    -- Recursive: find everyone who reports (directly or indirectly)
    SELECT e.id, e.name, e.manager_id, at.level + 1
    FROM employees e
    INNER JOIN alice_team at ON e.manager_id = at.id
)
SELECT
    REPEAT('-- ', level) || name AS team_member,
    level AS org_depth
FROM alice_team
ORDER BY level, name;

-- =====================================================
-- Output:
-- ┌─────────────────────────────┬───────────┐
-- │         team_member         │ org_depth │
-- ├─────────────────────────────┼───────────┤
-- │ Alice Johnson               │     0     │  ← herself
-- │ -- Charlie Brown            │     1     │  ← direct reports
-- │ -- Fiona Green              │     1     │
-- │ -- Ivan Black               │     1     │
-- │ -- Oscar Wilde              │     1     │
-- └─────────────────────────────┴───────────┘
-- =====================================================


-- =====================================================
-- ADVANTAGES of CTEs:
-- → Makes complex queries readable and modular
-- → Can reference the same CTE multiple times
-- → Recursive CTEs handle tree structures elegantly
-- → Easier to debug step by step
--
-- LIMITATIONS:
-- → Not stored — lives only for one query
-- → Recursive CTEs need careful design to avoid
--   infinite loops (use LIMIT or depth check)
-- → In older PostgreSQL, CTEs were always materialized
--   (since PG12 optimizer can inline them)
--
-- INTERVIEW QUESTIONS:
-- Q: What is a CTE?
-- A: A named temporary result set defined with WITH,
--    used within a single SQL statement.
--
-- Q: CTE vs Subquery?
-- A: CTE is readable, reusable within the query,
--    and supports recursion. Subquery is inline
--    and harder to read when nested deeply.
--
-- Q: What is a Recursive CTE?
-- A: A CTE that references itself. Has a base case
--    and recursive case joined by UNION ALL.
--    Used for hierarchy data like org charts.
-- =====================================================