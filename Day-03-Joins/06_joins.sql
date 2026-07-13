-- =====================================================
-- Topic: JOINs and Their Types
-- Description:
-- JOIN combines rows from two or more tables
-- based on a related column between them.
--
-- Think of it like merging two Excel sheets
-- using a common column (like employee id).
--
-- Types of JOINs:
-- ┌─────────────────┬──────────────────────────────────────────────┐
-- │ JOIN Type       │ What it returns                              │
-- ├─────────────────┼──────────────────────────────────────────────┤
-- │ INNER JOIN      │ Only rows that match in BOTH tables          │
-- │ LEFT JOIN       │ All rows from LEFT + matching from RIGHT     │
-- │                 │ Non-matching right side shows NULL           │
-- │ RIGHT JOIN      │ All rows from RIGHT + matching from LEFT     │
-- │                 │ Non-matching left side shows NULL            │
-- │ FULL OUTER JOIN │ All rows from BOTH tables                    │
-- │                 │ Non-matching sides show NULL                 │
-- │ CROSS JOIN      │ Every row of left combined with every row    │
-- │                 │ of right (cartesian product)                 │
-- │ SELF JOIN       │ A table joined with itself                   │
-- └─────────────────┴──────────────────────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- Setup: Create tables for all JOIN examples
-- -------------------------------------------------------
CREATE TABLE department (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    salary        NUMERIC(10,2),
    department_id INT,
    manager_id    INT,
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Insert departments
INSERT INTO department (name)
VALUES
    ('Engineering'),
    ('Marketing'),
    ('HR'),
    ('Finance');   -- Finance has NO employees (for LEFT/RIGHT JOIN demo)

-- Insert employees
-- Note: employee_id 5 has NULL department_id (no department assigned)
INSERT INTO employee (name, salary, department_id, manager_id)
VALUES
    ('Alice Johnson',  95000.00, 1, NULL),  -- Engineering, no manager (she IS manager)
    ('Bob Smith',      60000.00, 2, NULL),  -- Marketing, no manager
    ('Charlie Brown',  75000.00, 1,    1),  -- Engineering, manager is Alice (id=1)
    ('Diana Prince',   55000.00, 3,  NULL), -- HR, no manager
    ('Edward King',    70000.00, 1,    1),  -- Engineering, manager is Alice (id=1)
    ('Fiona Green',    48000.00, 2,    2),  -- Marketing, manager is Bob (id=2)
    ('George White',   NULL,     NULL, NULL); -- No department, no salary

SELECT * FROM department;
-- =====================================================
-- Output:
-- ┌────┬─────────────┐
-- │ id │    name     │
-- ├────┼─────────────┤
-- │  1 │ Engineering │
-- │  2 │ Marketing   │
-- │  3 │ HR          │
-- │  4 │ Finance     │
-- └────┴─────────────┘
-- =====================================================

SELECT * FROM employee;
-- =====================================================
-- Output:
-- ┌────┬───────────────┬───────────┬───────────────┬────────────┐
-- │ id │     name      │  salary   │ department_id │ manager_id │
-- ├────┼───────────────┼───────────┼───────────────┼────────────┤
-- │  1 │ Alice Johnson │  95000.00 │       1       │    NULL    │
-- │  2 │ Bob Smith     │  60000.00 │       2       │    NULL    │
-- │  3 │ Charlie Brown │  75000.00 │       1       │      1     │
-- │  4 │ Diana Prince  │  55000.00 │       3       │    NULL    │
-- │  5 │ Edward King   │  70000.00 │       1       │      1     │
-- │  6 │ Fiona Green   │  48000.00 │       2       │      2     │
-- │  7 │ George White  │   NULL    │     NULL      │    NULL    │
-- └────┴───────────────┴───────────┴───────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. INNER JOIN → Returns only rows that have a MATCH
--                 in BOTH tables
--                 Non-matching rows are excluded
-- -------------------------------------------------------
--
--  employee                  department
-- ┌────┬───────┬──────────┐  ┌────┬─────────────┐
-- │ id │ name  │ dept_id  │  │ id │    name     │
-- ├────┼───────┼──────────┤  ├────┼─────────────┤
-- │  1 │ Alice │    1     │◄─│  1 │ Engineering │ ✓ match
-- │  2 │ Bob   │    2     │◄─│  2 │ Marketing   │ ✓ match
-- │  7 │George │   NULL   │  │  4 │ Finance     │ ✗ no match
-- └────┴───────┴──────────┘  └────┴─────────────┘
-- George and Finance are excluded (no match)

SELECT
    e.id          AS employee_id,
    e.name        AS employee_name,
    e.salary,
    d.name        AS department_name
FROM employee e
INNER JOIN department d
    ON e.department_id = d.id;

-- e is alias for employee table
-- d is alias for department table
-- ON defines which columns to match

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┬───────────┬─────────────────┐
-- │ employee_id │ employee_name │  salary   │ department_name │
-- ├─────────────┼───────────────┼───────────┼─────────────────┤
-- │      1      │ Alice Johnson │  95000.00 │ Engineering     │
-- │      3      │ Charlie Brown │  75000.00 │ Engineering     │
-- │      5      │ Edward King   │  70000.00 │ Engineering     │
-- │      2      │ Bob Smith     │  60000.00 │ Marketing       │
-- │      6      │ Fiona Green   │  48000.00 │ Marketing       │
-- │      4      │ Diana Prince  │  55000.00 │ HR              │
-- └─────────────┴───────────────┴───────────┴─────────────────┘
-- George White (NULL dept) and Finance dept are excluded
-- =====================================================


-- -------------------------------------------------------
-- 2. LEFT JOIN (LEFT OUTER JOIN)
--    Returns ALL rows from LEFT table (employee)
--    + matching rows from RIGHT table (department)
--    Non-matching right side shows NULL
-- -------------------------------------------------------
--
--  employee (LEFT)           department (RIGHT)
-- ┌────┬───────┬──────────┐  ┌────┬─────────────┐
-- │  1 │ Alice │    1     │◄─│  1 │ Engineering │ ✓ match
-- │  2 │ Bob   │    2     │◄─│  2 │ Marketing   │ ✓ match
-- │  7 │George │   NULL   │  │  4 │ Finance     │ no employee
-- └────┴───────┴──────────┘  └────┴─────────────┘
-- George is included with NULL department
-- Finance is NOT included (no employee has it)

SELECT
    e.id          AS employee_id,
    e.name        AS employee_name,
    d.name        AS department_name
FROM employee e
LEFT JOIN department d
    ON e.department_id = d.id;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┬─────────────────┐
-- │ employee_id │ employee_name │ department_name │
-- ├─────────────┼───────────────┼─────────────────┤
-- │      1      │ Alice Johnson │ Engineering     │
-- │      3      │ Charlie Brown │ Engineering     │
-- │      5      │ Edward King   │ Engineering     │
-- │      2      │ Bob Smith     │ Marketing       │
-- │      6      │ Fiona Green   │ Marketing       │
-- │      4      │ Diana Prince  │ HR              │
-- │      7      │ George White  │ NULL            │ ← no department
-- └─────────────┴───────────────┴─────────────────┘
-- All 7 employees shown. George has NULL department.
-- Finance not shown (no employee linked to it)
-- =====================================================

-- Find employees with NO department assigned
SELECT e.name AS employee_without_department
FROM employee e
LEFT JOIN department d
    ON e.department_id = d.id
WHERE d.id IS NULL;

-- =====================================================
-- Output:
-- ┌─────────────────────────────┐
-- │ employee_without_department │
-- ├─────────────────────────────┤
-- │ George White                │
-- └─────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
--    Returns ALL rows from RIGHT table (department)
--    + matching rows from LEFT table (employee)
--    Non-matching left side shows NULL
-- -------------------------------------------------------
--
--  employee (LEFT)           department (RIGHT)
-- ┌────┬───────┬──────────┐  ┌────┬─────────────┐
-- │  1 │ Alice │    1     │◄─│  1 │ Engineering │ ✓ match
-- │  2 │ Bob   │    2     │◄─│  2 │ Marketing   │ ✓ match
-- │  7 │George │   NULL   │  │  3 │ HR          │ ✓ match
--                             │  4 │ Finance     │ ✗ no employee
-- George excluded. Finance included with NULL employee.

SELECT
    e.name        AS employee_name,
    d.name        AS department_name
FROM employee e
RIGHT JOIN department d
    ON e.department_id = d.id;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────────┐
-- │ employee_name │ department_name │
-- ├───────────────┼─────────────────┤
-- │ Alice Johnson │ Engineering     │
-- │ Charlie Brown │ Engineering     │
-- │ Edward King   │ Engineering     │
-- │ Bob Smith     │ Marketing       │
-- │ Fiona Green   │ Marketing       │
-- │ Diana Prince  │ HR              │
-- │ NULL          │ Finance         │ ← no employee in Finance
-- └───────────────┴─────────────────┘
-- All 4 departments shown. Finance has NULL employee.
-- George White not shown (no department linked)
-- =====================================================

-- Find departments with NO employees
SELECT d.name AS empty_department
FROM employee e
RIGHT JOIN department d
    ON e.department_id = d.id
WHERE e.id IS NULL;

-- =====================================================
-- Output:
-- ┌──────────────────┐
-- │ empty_department │
-- ├──────────────────┤
-- │ Finance          │
-- └──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. FULL OUTER JOIN
--    Returns ALL rows from BOTH tables
--    Non-matching sides show NULL on both ends
-- -------------------------------------------------------

SELECT
    e.name        AS employee_name,
    d.name        AS department_name
FROM employee e
FULL OUTER JOIN department d
    ON e.department_id = d.id;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────────┐
-- │ employee_name │ department_name │
-- ├───────────────┼─────────────────┤
-- │ Alice Johnson │ Engineering     │
-- │ Charlie Brown │ Engineering     │
-- │ Edward King   │ Engineering     │
-- │ Bob Smith     │ Marketing       │
-- │ Fiona Green   │ Marketing       │
-- │ Diana Prince  │ HR              │
-- │ George White  │ NULL            │ ← employee without dept
-- │ NULL          │ Finance         │ ← dept without employee
-- └───────────────┴─────────────────┘
-- Everyone from both sides is included
-- =====================================================


-- -------------------------------------------------------
-- 5. CROSS JOIN
--    Combines EVERY row from left with EVERY row from right
--    Total rows = rows in table A × rows in table B
--    No ON condition needed
-- -------------------------------------------------------
SELECT
    e.name        AS employee_name,
    d.name        AS department_name
FROM employee e
CROSS JOIN department d
LIMIT 12;

-- 7 employees × 4 departments = 28 total combinations
-- =====================================================
-- Output (first 12 rows):
-- ┌───────────────┬─────────────────┐
-- │ employee_name │ department_name │
-- ├───────────────┼─────────────────┤
-- │ Alice Johnson │ Engineering     │
-- │ Alice Johnson │ Marketing       │
-- │ Alice Johnson │ HR              │
-- │ Alice Johnson │ Finance         │
-- │ Bob Smith     │ Engineering     │
-- │ Bob Smith     │ Marketing       │
-- │ Bob Smith     │ HR              │
-- │ Bob Smith     │ Finance         │
-- │ Charlie Brown │ Engineering     │
-- │ Charlie Brown │ Marketing       │
-- │ Charlie Brown │ HR              │
-- │ Charlie Brown │ Finance         │
-- └───────────────┴─────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. SELF JOIN
--    A table joined with ITSELF
--    Used when rows inside the same table are related
--    to each other (like employees and their managers)
--
--    manager_id in employee references id in same table
-- -------------------------------------------------------
SELECT
    e.name  AS employee_name,
    m.name  AS manager_name
FROM employee e
LEFT JOIN employee m
    ON e.manager_id = m.id;

-- e = the employee
-- m = the manager (same table, different alias)
-- e.manager_id links to m.id (same table)

-- =====================================================
-- Output:
-- ┌───────────────┬───────────────┐
-- │ employee_name │ manager_name  │
-- ├───────────────┼───────────────┤
-- │ Alice Johnson │ NULL          │ ← Alice has no manager
-- │ Bob Smith     │ NULL          │ ← Bob has no manager
-- │ Charlie Brown │ Alice Johnson │ ← Charlie's manager is Alice
-- │ Diana Prince  │ NULL          │ ← Diana has no manager
-- │ Edward King   │ Alice Johnson │ ← Edward's manager is Alice
-- │ Fiona Green   │ Bob Smith     │ ← Fiona's manager is Bob
-- │ George White  │ NULL          │ ← George has no manager
-- └───────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 7. JOIN with WHERE, ORDER BY, GROUP BY
--    Combining JOINs with other clauses
-- -------------------------------------------------------

-- Count employees per department (sorted)
SELECT
    d.name           AS department,
    COUNT(e.id)      AS total_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM department d
LEFT JOIN employee e
    ON d.id = e.department_id
GROUP BY d.name
ORDER BY total_employees DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬─────────────────┬────────────┐
-- │ department  │ total_employees │ avg_salary │
-- ├─────────────┼─────────────────┼────────────┤
-- │ Engineering │        3        │  80000.00  │
-- │ Marketing   │        2        │  54000.00  │
-- │ HR          │        1        │  55000.00  │
-- │ Finance     │        0        │   NULL     │
-- └─────────────┴─────────────────┴────────────┘
-- =====================================================

DROP TABLE employee;
DROP TABLE department;