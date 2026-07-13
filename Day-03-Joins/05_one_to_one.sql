-- =====================================================
-- Topic: One to One Relationship
-- Description:
-- One record in Table A is linked to exactly
-- one record in Table B.
--
-- We use:
-- FOREIGN KEY → to create the link between tables
-- UNIQUE      → to enforce only one match (makes it 1:1)
--               Without UNIQUE it would be 1:Many
--
-- Real Example today:
-- One employee → has one passport
-- One passport → belongs to one employee
-- =====================================================


-- -------------------------------------------------------
-- Step 1: Create the PARENT table (employee)
--         This table stands alone, no dependency
-- -------------------------------------------------------
CREATE TABLE employee (
    id     SERIAL PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    email  VARCHAR(150) UNIQUE NOT NULL
);


-- -------------------------------------------------------
-- Step 2: Create the CHILD table (passport)
--         This table depends on employee
-- -------------------------------------------------------
CREATE TABLE passport (
    id            SERIAL PRIMARY KEY,
    passport_number VARCHAR(20) UNIQUE NOT NULL,
    issued_date   DATE NOT NULL,
    expiry_date   DATE NOT NULL,

    -- Foreign Key links passport to employee
    -- UNIQUE makes this a One to One relationship
    employee_id   INT UNIQUE NOT NULL,
    CONSTRAINT fk_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(id)
        ON DELETE CASCADE
        -- If employee is deleted → passport is also deleted
);


-- -------------------------------------------------------
-- Step 3: Insert employees (parent records first)
-- -------------------------------------------------------
INSERT INTO employee (name, email)
VALUES
    ('Alice Johnson', 'alice@mail.com'),
    ('Bob Smith',     'bob@mail.com'),
    ('Charlie Brown', 'charlie@mail.com');

SELECT * FROM employee;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬──────────────────┐
-- │ id │     name      │      email       │
-- ├────┼───────────────┼──────────────────┤
-- │  1 │ Alice Johnson │ alice@mail.com   │
-- │  2 │ Bob Smith     │ bob@mail.com     │
-- │  3 │ Charlie Brown │ charlie@mail.com │
-- └────┴───────────────┴──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- Step 4: Insert passports (child records after parent)
-- -------------------------------------------------------
INSERT INTO passport (passport_number, issued_date, expiry_date, employee_id)
VALUES
    ('PA-100001', '2020-01-15', '2030-01-15', 1),
    ('PA-100002', '2019-06-20', '2029-06-20', 2),
    ('PA-100003', '2021-09-10', '2031-09-10', 3);

SELECT * FROM passport;

-- =====================================================
-- Output:
-- ┌────┬────────────────┬─────────────┬─────────────┬─────────────┐
-- │ id │passport_number │ issued_date │ expiry_date │ employee_id │
-- ├────┼────────────────┼─────────────┼─────────────┼─────────────┤
-- │  1 │ PA-100001      │ 2020-01-15  │ 2030-01-15  │      1      │
-- │  2 │ PA-100002      │ 2019-06-20  │ 2029-06-20  │      2      │
-- │  3 │ PA-100003      │ 2021-09-10  │ 2031-09-10  │      3      │
-- └────┴────────────────┴─────────────┴─────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- Step 5: Try to give one employee TWO passports
--         This will FAIL because employee_id is UNIQUE
-- -------------------------------------------------------
INSERT INTO passport (passport_number, issued_date, expiry_date, employee_id)
VALUES ('PA-999999', '2023-01-01', '2033-01-01', 1);

-- =====================================================
-- Output:
-- ERROR: duplicate key value violates unique constraint
-- "passport_employee_id_key"
-- ← UNIQUE ensures one employee can have only one passport
-- =====================================================


-- -------------------------------------------------------
-- Step 6: Try to add passport for non-existing employee
--         This will FAIL because of FOREIGN KEY constraint
-- -------------------------------------------------------
INSERT INTO passport (passport_number, issued_date, expiry_date, employee_id)
VALUES ('PA-777777', '2023-01-01', '2033-01-01', 99);

-- =====================================================
-- Output:
-- ERROR: insert or update on table "passport" violates
-- foreign key constraint "fk_employee"
-- DETAIL: Key (employee_id)=(99) is not present in table "employee"
-- ← employee id 99 does not exist
-- =====================================================


-- -------------------------------------------------------
-- Step 7: Test ON DELETE CASCADE
--         Delete employee → passport should auto delete
-- -------------------------------------------------------
DELETE FROM employee WHERE id = 1;

SELECT * FROM employee;
-- =====================================================
-- Output:
-- ┌────┬───────────────┬──────────────────┐
-- │ id │     name      │      email       │
-- ├────┼───────────────┼──────────────────┤
-- │  2 │ Bob Smith     │ bob@mail.com     │
-- │  3 │ Charlie Brown │ charlie@mail.com │
-- └────┴───────────────┴──────────────────┘
-- =====================================================

SELECT * FROM passport;
-- =====================================================
-- Output: (Alice's passport is also deleted automatically)
-- ┌────┬────────────────┬─────────────┬─────────────┬─────────────┐
-- │ id │passport_number │ issued_date │ expiry_date │ employee_id │
-- ├────┼────────────────┼─────────────┼─────────────┼─────────────┤
-- │  2 │ PA-100002      │ 2019-06-20  │ 2029-06-20  │      2      │
-- │  3 │ PA-100003      │ 2021-09-10  │ 2031-09-10  │      3      │
-- └────┴────────────────┴─────────────┴─────────────┴─────────────┘
-- ← PA-100001 (Alice's passport) is gone automatically
-- =====================================================

DROP TABLE passport;
DROP TABLE employee;