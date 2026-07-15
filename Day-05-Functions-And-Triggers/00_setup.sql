-- =====================================================
-- Day 05 - Setup: Sample Database & Tables
-- Description:
-- We use a company database with employees,
-- departments, salaries, and audit logs.
-- All Day 05 topics will use these tables.
-- =====================================================

-- -------------------------------------------------------
-- Table 1: departments
-- -------------------------------------------------------
CREATE TABLE departments (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    location   VARCHAR(100),
    budget     NUMERIC(12, 2)
);

-- -------------------------------------------------------
-- Table 2: employees
-- -------------------------------------------------------
CREATE TABLE employees (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    department_id INT REFERENCES departments(id),
    salary        NUMERIC(10, 2) NOT NULL CHECK (salary > 0),
    hire_date     DATE NOT NULL DEFAULT CURRENT_DATE,
    job_title     VARCHAR(100),
    manager_id    INT REFERENCES employees(id),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- Table 3: salary_history
-- -------------------------------------------------------
CREATE TABLE salary_history (
    id           SERIAL PRIMARY KEY,
    employee_id  INT REFERENCES employees(id),
    old_salary   NUMERIC(10, 2),
    new_salary   NUMERIC(10, 2),
    changed_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by   VARCHAR(100) DEFAULT CURRENT_USER
);

-- -------------------------------------------------------
-- Table 4: audit_log (used for Triggers)
-- -------------------------------------------------------
CREATE TABLE audit_log (
    id           SERIAL PRIMARY KEY,
    table_name   VARCHAR(100),
    operation    VARCHAR(20),
    old_data     TEXT,
    new_data     TEXT,
    performed_by VARCHAR(100) DEFAULT CURRENT_USER,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- Insert Departments
-- -------------------------------------------------------
INSERT INTO departments (name, location, budget)
VALUES
    ('Engineering',  'New York',    5000000.00),
    ('Marketing',    'Los Angeles', 2000000.00),
    ('HR',           'Chicago',     1000000.00),
    ('Finance',      'Houston',     3000000.00),
    ('Sales',        'Phoenix',     2500000.00);

-- -------------------------------------------------------
-- Insert Employees
-- -------------------------------------------------------
INSERT INTO employees (name, email, department_id, salary, hire_date, job_title, manager_id)
VALUES
    ('Alice Johnson',  'alice@company.com',   1, 120000.00, '2019-03-15', 'Engineering Manager', NULL),
    ('Bob Smith',      'bob@company.com',     2, 85000.00,  '2020-06-01', 'Marketing Manager',   NULL),
    ('Charlie Brown',  'charlie@company.com', 1, 95000.00,  '2020-01-10', 'Senior Engineer',     1),
    ('Diana Prince',   'diana@company.com',   3, 70000.00,  '2021-02-20', 'HR Manager',          NULL),
    ('Edward King',    'edward@company.com',  2, 72000.00,  '2021-09-05', 'Marketing Analyst',   2),
    ('Fiona Green',    'fiona@company.com',   1, 110000.00, '2019-11-30', 'Lead Engineer',       1),
    ('George White',   'george@company.com',  3, 58000.00,  '2022-07-18', 'HR Analyst',          4),
    ('Helen Troy',     'helen@company.com',   4, 98000.00,  '2020-04-25', 'Finance Manager',     NULL),
    ('Ivan Black',     'ivan@company.com',    1, 88000.00,  '2021-12-01', 'Engineer',            1),
    ('Julia Roberts',  'julia@company.com',   4, 76000.00,  '2020-08-14', 'Financial Analyst',   8),
    ('Kevin Hart',     'kevin@company.com',   5, 82000.00,  '2021-03-22', 'Sales Manager',       NULL),
    ('Laura Palmer',   'laura@company.com',   5, 65000.00,  '2022-01-10', 'Sales Rep',           11),
    ('Mike Jordan',    'mike@company.com',    5, 68000.00,  '2022-05-15', 'Sales Rep',           11),
    ('Nina Simone',    'nina@company.com',    2, 78000.00,  '2020-11-08', 'Senior Marketer',     2),
    ('Oscar Wilde',    'oscar@company.com',   1, 92000.00,  '2021-07-19', 'Senior Engineer',     1);

-- =====================================================
-- Output:
-- CREATE TABLE  (departments)
-- CREATE TABLE  (employees)
-- CREATE TABLE  (salary_history)
-- CREATE TABLE  (audit_log)
-- INSERT 0 5    (departments)
-- INSERT 0 15   (employees)
-- =====================================================

SELECT * FROM departments;
-- =====================================================
-- Output:
-- ┌────┬─────────────┬─────────────┬─────────────┐
-- │ id │    name     │  location   │   budget    │
-- ├────┼─────────────┼─────────────┼─────────────┤
-- │  1 │ Engineering │ New York    │ 5000000.00  │
-- │  2 │ Marketing   │ Los Angeles │ 2000000.00  │
-- │  3 │ HR          │ Chicago     │ 1000000.00  │
-- │  4 │ Finance     │ Houston     │ 3000000.00  │
-- │  5 │ Sales       │ Phoenix     │ 2500000.00  │
-- └────┴─────────────┴─────────────┴─────────────┘
-- =====================================================

SELECT * FROM employees;
-- =====================================================
-- Output:
-- ┌────┬───────────────┬───────────────────────┬───────────────┬───────────┬────────────┬──────────────────────┬────────────┐
-- │ id │     name      │         email         │ department_id │  salary   │ hire_date  │      job_title       │ manager_id │
-- ├────┼───────────────┼───────────────────────┼───────────────┼───────────┼────────────┼──────────────────────┼────────────┤
-- │  1 │ Alice Johnson │ alice@company.com     │       1       │ 120000.00 │ 2019-03-15 │ Engineering Manager  │    NULL    │
-- │  2 │ Bob Smith     │ bob@company.com       │       2       │  85000.00 │ 2020-06-01 │ Marketing Manager    │    NULL    │
-- │  3 │ Charlie Brown │ charlie@company.com   │       1       │  95000.00 │ 2020-01-10 │ Senior Engineer      │      1     │
-- │  4 │ Diana Prince  │ diana@company.com     │       3       │  70000.00 │ 2021-02-20 │ HR Manager           │    NULL    │
-- │  5 │ Edward King   │ edward@company.com    │       2       │  72000.00 │ 2021-09-05 │ Marketing Analyst    │      2     │
-- │  6 │ Fiona Green   │ fiona@company.com     │       1       │ 110000.00 │ 2019-11-30 │ Lead Engineer        │      1     │
-- │  7 │ George White  │ george@company.com    │       3       │  58000.00 │ 2022-07-18 │ HR Analyst           │      4     │
-- │  8 │ Helen Troy    │ helen@company.com     │       4       │  98000.00 │ 2020-04-25 │ Finance Manager      │    NULL    │
-- │  9 │ Ivan Black    │ ivan@company.com      │       1       │  88000.00 │ 2021-12-01 │ Engineer             │      1     │
-- │ 10 │ Julia Roberts │ julia@company.com     │       4       │  76000.00 │ 2020-08-14 │ Financial Analyst    │      8     │
-- │ 11 │ Kevin Hart    │ kevin@company.com     │       5       │  82000.00 │ 2021-03-22 │ Sales Manager        │    NULL    │
-- │ 12 │ Laura Palmer  │ laura@company.com     │       5       │  65000.00 │ 2022-01-10 │ Sales Rep            │     11     │
-- │ 13 │ Mike Jordan   │ mike@company.com      │       5       │  68000.00 │ 2022-05-15 │ Sales Rep            │     11     │
-- │ 14 │ Nina Simone   │ nina@company.com      │       2       │  78000.00 │ 2020-11-08 │ Senior Marketer      │      2     │
-- │ 15 │ Oscar Wilde   │ oscar@company.com     │       1       │  92000.00 │ 2021-07-19 │ Senior Engineer      │      1     │
-- └────┴───────────────┴───────────────────────┴───────────────┴───────────┴────────────┴──────────────────────┴────────────┘
-- =====================================================