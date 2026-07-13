-- =====================================================
-- Topic: CHECK Constraint
-- Description:
-- CHECK constraint ensures a column value must
-- satisfy a specific condition before it is saved.
--
-- Think of it as a security guard at the door.
-- Only values that pass the condition get in.
--
-- If a value FAILS the check → PostgreSQL rejects it
-- and throws an error.
-- =====================================================

CREATE TABLE employee (

    id         SERIAL PRIMARY KEY,

    name       VARCHAR(100) NOT NULL,

    age        INT CHECK (age >= 18),
    -- Age must be 18 or above

    salary     NUMERIC(10,2) CHECK (salary > 0),
    -- Salary must be greater than 0

    experience INT CHECK (experience >= 0),
    -- Experience cannot be negative

    rating     NUMERIC(3,1) CHECK (rating >= 1.0 AND rating <= 5.0),
    -- Rating must be between 1.0 and 5.0

    department VARCHAR(50) CHECK (department IN ('Engineering', 'Marketing', 'HR', 'Finance')),
    -- Department must be one of these 4 values

    status     VARCHAR(20) CHECK (status IN ('active', 'inactive', 'on_leave'))
    -- Status must be one of these 3 values

);

-- -------------------------------------------------------
-- Valid INSERT → All values pass the checks
-- -------------------------------------------------------
INSERT INTO employee (name, age, salary, experience, rating, department, status)
VALUES ('Alice', 28, 75000.00, 5, 4.5, 'Engineering', 'active');

-- =====================================================
-- Output:
-- INSERT 0 1   ← Success
-- =====================================================


-- -------------------------------------------------------
-- Invalid INSERT → age is 16 which fails CHECK (age >= 18)
-- -------------------------------------------------------
INSERT INTO employee (name, age, salary, experience, rating, department, status)
VALUES ('Bob', 16, 50000.00, 2, 3.5, 'Marketing', 'active');

-- =====================================================
-- Output:
-- ERROR: new row for relation "employee" violates
-- check constraint "employee_age_check"
-- =====================================================


-- -------------------------------------------------------
-- Invalid INSERT → salary is negative
-- -------------------------------------------------------
INSERT INTO employee (name, age, salary, experience, rating, department, status)
VALUES ('Charlie', 25, -5000.00, 3, 4.0, 'HR', 'active');

-- =====================================================
-- Output:
-- ERROR: new row for relation "employee" violates
-- check constraint "employee_salary_check"
-- =====================================================


-- -------------------------------------------------------
-- Invalid INSERT → department not in allowed list
-- -------------------------------------------------------
INSERT INTO employee (name, age, salary, experience, rating, department, status)
VALUES ('Diana', 30, 60000.00, 6, 3.8, 'Design', 'active');

-- =====================================================
-- Output:
-- ERROR: new row for relation "employee" violates
-- check constraint "employee_department_check"
-- =====================================================


-- -------------------------------------------------------
-- Named CHECK Constraint → Give constraint a clear name
-- Using CONSTRAINT keyword makes error messages readable
-- -------------------------------------------------------
CREATE TABLE product (

    id       SERIAL PRIMARY KEY,

    name     VARCHAR(100) NOT NULL,

    price    NUMERIC(10,2),
    quantity INT,

    -- Named constraints
    CONSTRAINT price_must_be_positive    CHECK (price > 0),
    CONSTRAINT quantity_cannot_be_negative CHECK (quantity >= 0),
    CONSTRAINT valid_price_range         CHECK (price BETWEEN 1 AND 999999)

);

INSERT INTO product (name, price, quantity)
VALUES ('Laptop', 85000.00, 10);

-- =====================================================
-- Output:
-- INSERT 0 1   ← Success
-- =====================================================

INSERT INTO product (name, price, quantity)
VALUES ('Mouse', -500.00, 5);

-- =====================================================
-- Output:
-- ERROR: new row for relation "product" violates
-- check constraint "price_must_be_positive"
-- ← Named constraint makes the error message clear
-- =====================================================

DROP TABLE employee;
DROP TABLE product;