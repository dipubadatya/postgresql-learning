-- =====================================================
-- Topic: ALTER TABLE
-- Description:
-- ALTER TABLE is used to modify an existing table.
-- You can add, remove, rename, or change columns
-- without deleting and recreating the table.
--
-- Think of it like editing a form that already exists.
--
-- What ALTER TABLE can do:
-- ┌──────────────────────────┬────────────────────────────────────────┐
-- │ Command                  │ What it does                           │
-- ├──────────────────────────┼────────────────────────────────────────┤
-- │ ADD COLUMN               │ Add a new column to the table          │
-- │ DROP COLUMN              │ Remove a column from the table         │
-- │ RENAME COLUMN            │ Rename an existing column              │
-- │ RENAME TO                │ Rename the entire table                │
-- │ ALTER COLUMN SET DEFAULT │ Set a default value for a column       │
-- │ ALTER COLUMN DROP DEFAULT│ Remove the default value               │
-- │ ALTER COLUMN TYPE        │ Change the data type of a column       │
-- │ SET NOT NULL             │ Make a column required                 │
-- │ DROP NOT NULL            │ Make a column optional                 │
-- │ ADD CONSTRAINT           │ Add a new constraint to a column       │
-- │ DROP CONSTRAINT          │ Remove an existing constraint          │
-- └──────────────────────────┴────────────────────────────────────────┘
-- =====================================================

-- First, let us create a simple table to practice on
CREATE TABLE student (
    id     SERIAL PRIMARY KEY,
    name   VARCHAR(100),
    age    INT
);

-- Insert some data to see changes clearly
INSERT INTO student (name, age)
VALUES
    ('Alice', 20),
    ('Bob',   22),
    ('Charlie', 19);

SELECT * FROM student;

-- =====================================================
-- Output:
-- ┌────┬─────────┬─────┐
-- │ id │  name   │ age │
-- ├────┼─────────┼─────┤
-- │  1 │ Alice   │  20 │
-- │  2 │ Bob     │  22 │
-- │  3 │ Charlie │  19 │
-- └────┴─────────┴─────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. ADD COLUMN → Add a brand new column to the table
-- -------------------------------------------------------
ALTER TABLE student
ADD COLUMN email VARCHAR(150);

SELECT * FROM student;

-- =====================================================
-- Output: (email column added, existing rows show NULL)
-- ┌────┬─────────┬─────┬───────┐
-- │ id │  name   │ age │ email │
-- ├────┼─────────┼─────┼───────┤
-- │  1 │ Alice   │  20 │ NULL  │
-- │  2 │ Bob     │  22 │ NULL  │
-- │  3 │ Charlie │  19 │ NULL  │
-- └────┴─────────┴─────┴───────┘
-- =====================================================

-- Add column with a DEFAULT value
ALTER TABLE student
ADD COLUMN status VARCHAR(20) DEFAULT 'active';

SELECT * FROM student;

-- =====================================================
-- Output: (status column added with default value)
-- ┌────┬─────────┬─────┬───────┬────────┐
-- │ id │  name   │ age │ email │ status │
-- ├────┼─────────┼─────┼───────┼────────┤
-- │  1 │ Alice   │  20 │ NULL  │ active │
-- │  2 │ Bob     │  22 │ NULL  │ active │
-- │  3 │ Charlie │  19 │ NULL  │ active │
-- └────┴─────────┴─────┴───────┴────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. DROP COLUMN → Remove a column from the table
--    WARNING: All data in that column is permanently lost
-- -------------------------------------------------------
ALTER TABLE student
DROP COLUMN status;

SELECT * FROM student;

-- =====================================================
-- Output: (status column is gone)
-- ┌────┬─────────┬─────┬───────┐
-- │ id │  name   │ age │ email │
-- ├────┼─────────┼─────┼───────┤
-- │  1 │ Alice   │  20 │ NULL  │
-- │  2 │ Bob     │  22 │ NULL  │
-- │  3 │ Charlie │  19 │ NULL  │
-- └────┴─────────┴─────┴───────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. RENAME COLUMN → Rename an existing column
-- -------------------------------------------------------
ALTER TABLE student
RENAME COLUMN name TO full_name;

SELECT * FROM student;

-- =====================================================
-- Output: (name column is now called full_name)
-- ┌────┬───────────┬─────┬───────┐
-- │ id │ full_name │ age │ email │
-- ├────┼───────────┼─────┼───────┤
-- │  1 │ Alice     │  20 │ NULL  │
-- │  2 │ Bob       │  22 │ NULL  │
-- │  3 │ Charlie   │  19 │ NULL  │
-- └────┴───────────┴─────┴───────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. RENAME TO → Rename the entire table
-- -------------------------------------------------------
ALTER TABLE student
RENAME TO learner;

-- =====================================================
-- Output:
-- ALTER TABLE
-- Now the table is named 'learner' instead of 'student'
-- =====================================================

-- Rename it back for rest of the examples
ALTER TABLE learner
RENAME TO student;


-- -------------------------------------------------------
-- 5. ALTER COLUMN TYPE → Change column data type
--    USING keyword tells PostgreSQL how to convert
--    existing data to the new type
-- -------------------------------------------------------
ALTER TABLE student
ALTER COLUMN age TYPE VARCHAR(10)
USING age::VARCHAR;

-- age was INT, now it is VARCHAR(10)
-- USING age::VARCHAR converts existing INT values to text

-- Change it back to INT
ALTER TABLE student
ALTER COLUMN age TYPE INT
USING age::INT;


-- -------------------------------------------------------
-- 6. SET DEFAULT → Set a default value for a column
-- -------------------------------------------------------
ALTER TABLE student
ALTER COLUMN email SET DEFAULT 'not_provided@mail.com';

-- Now any new row without email gets this default value
INSERT INTO student (full_name, age)
VALUES ('Diana', 21);

SELECT * FROM student;

-- =====================================================
-- Output:
-- ┌────┬───────────┬─────┬───────────────────────┐
-- │ id │ full_name │ age │         email          │
-- ├────┼───────────┼─────┼───────────────────────┤
-- │  1 │ Alice     │  20 │ NULL                   │
-- │  2 │ Bob       │  22 │ NULL                   │
-- │  3 │ Charlie   │  19 │ NULL                   │
-- │  4 │ Diana     │  21 │ not_provided@mail.com  │
-- └────┴───────────┴─────┴───────────────────────┘
-- Note: Old rows keep NULL. Default applies to NEW rows.
-- =====================================================


-- -------------------------------------------------------
-- 7. DROP DEFAULT → Remove the default value
-- -------------------------------------------------------
ALTER TABLE student
ALTER COLUMN email DROP DEFAULT;


-- -------------------------------------------------------
-- 8. SET NOT NULL → Make a column required
-- -------------------------------------------------------
-- First update NULLs, then apply NOT NULL
UPDATE student SET email = 'unknown@mail.com' WHERE email IS NULL;

ALTER TABLE student
ALTER COLUMN email SET NOT NULL;

-- Now inserting without email will give an error
-- INSERT INTO student (full_name, age) VALUES ('Eve', 23);
-- ERROR: null value in column "email" violates not-null constraint


-- -------------------------------------------------------
-- 9. DROP NOT NULL → Make a column optional again
-- -------------------------------------------------------
ALTER TABLE student
ALTER COLUMN email DROP NOT NULL;


-- -------------------------------------------------------
-- 10. ADD CONSTRAINT → Add a rule to an existing column
-- -------------------------------------------------------
ALTER TABLE student
ADD CONSTRAINT student_age_check CHECK (age >= 16);

-- Now age must be 16 or above for all new inserts


-- -------------------------------------------------------
-- 11. DROP CONSTRAINT → Remove a constraint
-- -------------------------------------------------------
ALTER TABLE student
DROP CONSTRAINT student_age_check;

-- =====================================================
-- Output for all ALTER commands:
-- ALTER TABLE
-- =====================================================

DROP TABLE student;