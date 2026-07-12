-- =====================================================
-- Topic: Insert Data into Employee Table
-- Description:
-- Adding 10 employee records to practice all topics.
-- =====================================================

INSERT INTO employee (name, email, department, salary, age, status, joined_date)
VALUES
    ('Alice Johnson',  'alice@company.com',   'Engineering', 85000.00, 30, 'active',   '2021-03-15'),
    ('Bob Smith',      'bob@company.com',     'Marketing',   60000.00, 28, 'active',   '2022-06-01'),
    ('Charlie Brown',  'charlie@company.com', 'Engineering', 90000.00, 35, 'active',   '2020-01-10'),
    ('Diana Prince',   'diana@company.com',   'HR',          55000.00, 26, 'inactive', '2023-02-20'),
    ('Edward King',    'edward@company.com',  'Marketing',   70000.00, 32, 'active',   '2021-09-05'),
    ('Fiona Green',    'fiona@company.com',   'Engineering', 95000.00, 29, 'active',   '2019-11-30'),
    ('George White',   'george@company.com',  'HR',          52000.00, 24, 'inactive', '2023-07-18'),
    ('Helen Troy',     'helen@company.com',   'Marketing',   67000.00, 31, 'active',   '2022-04-25'),
    ('Ivan Black',     'ivan@company.com',    'Engineering', 88000.00, 27, 'active',   '2021-12-01'),
    ('Julia Roberts',  'julia@company.com',   'HR',          58000.00, 33, 'active',   '2020-08-14');

-- =====================================================
-- Output:
-- INSERT 0 10
-- =====================================================

-- View all inserted records
SELECT * FROM employee;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬───────────────────────┬─────────────┬───────────┬─────┬──────────┬─────────────┐
-- │ id │     name      │         email         │ department  │  salary   │ age │  status  │ joined_date │
-- ├────┼───────────────┼───────────────────────┼─────────────┼───────────┼─────┼──────────┼─────────────┤
-- │  1 │ Alice Johnson │ alice@company.com     │ Engineering │ 85000.00  │  30 │ active   │ 2021-03-15  │
-- │  2 │ Bob Smith     │ bob@company.com       │ Marketing   │ 60000.00  │  28 │ active   │ 2022-06-01  │
-- │  3 │ Charlie Brown │ charlie@company.com   │ Engineering │ 90000.00  │  35 │ active   │ 2020-01-10  │
-- │  4 │ Diana Prince  │ diana@company.com     │ HR          │ 55000.00  │  26 │ inactive │ 2023-02-20  │
-- │  5 │ Edward King   │ edward@company.com    │ Marketing   │ 70000.00  │  32 │ active   │ 2021-09-05  │
-- │  6 │ Fiona Green   │ fiona@company.com     │ Engineering │ 95000.00  │  29 │ active   │ 2019-11-30  │
-- │  7 │ George White  │ george@company.com    │ HR          │ 52000.00  │  24 │ inactive │ 2023-07-18  │
-- │  8 │ Helen Troy    │ helen@company.com     │ Marketing   │ 67000.00  │  31 │ active   │ 2022-04-25  │
-- │  9 │ Ivan Black    │ ivan@company.com      │ Engineering │ 88000.00  │  27 │ active   │ 2021-12-01  │
-- │ 10 │ Julia Roberts │ julia@company.com     │ HR          │ 58000.00  │  33 │ active   │ 2020-08-14  │
-- └────┴───────────────┴───────────────────────┴─────────────┴───────────┴─────┴──────────┴─────────────┘
-- =====================================================