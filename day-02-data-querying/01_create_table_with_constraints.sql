-- =====================================================
-- Topic: Create Employee Table with Constraints
-- Description:
-- Constraints are RULES applied on columns to ensure
-- correct and valid data is stored in the table.
--
-- Constraints Covered:
-- ┌─────────────┬──────────────────────────────────────┐
-- │ Constraint  │ Description                          │
-- ├─────────────┼──────────────────────────────────────┤
-- │ PRIMARY KEY │ Unique + Not Null for each row       │
-- │ NOT NULL    │ Column cannot be empty               │
-- │ UNIQUE      │ No duplicate values allowed          │
-- │ CHECK       │ Value must pass a condition          │
-- │ DEFAULT     │ Auto fills value if none is provided │
-- └─────────────┴──────────────────────────────────────┘
-- =====================================================

CREATE TABLE employee (

    id          SERIAL PRIMARY KEY,
    -- SERIAL      → Auto increments (1, 2, 3 ...)
    -- PRIMARY KEY → Unique identifier, cannot be NULL

    name        VARCHAR(100) NOT NULL,
    -- NOT NULL → Name field cannot be left empty

    email       VARCHAR(150) UNIQUE NOT NULL,
    -- UNIQUE   → No two employees can have same email
    -- NOT NULL → Email must be provided

    department  VARCHAR(50) NOT NULL,
    -- Department name is required

    salary      NUMERIC(10, 2) CHECK (salary > 0),
    -- NUMERIC(10,2) → Max 10 digits, 2 decimal places
    -- CHECK         → Salary must be greater than 0

    age         INT CHECK (age >= 18),
    -- CHECK → Employee must be at least 18 years old

    status      VARCHAR(20) DEFAULT 'active',
    -- DEFAULT → If not given, status is set to 'active'

    joined_date DATE DEFAULT CURRENT_DATE
    -- DEFAULT CURRENT_DATE → Uses today's date if not given

);

-- =====================================================
-- Output after CREATE TABLE:
-- CREATE TABLE
-- =====================================================