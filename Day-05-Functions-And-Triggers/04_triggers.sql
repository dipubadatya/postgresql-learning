-- =====================================================
-- Topic: Triggers
-- Description:
-- A Trigger is a function that automatically runs
-- when a specific event happens on a table.
-- You do not call it manually — it fires on its own.
--
-- Events that fire a trigger:
-- INSERT, UPDATE, DELETE
--
-- Timing of trigger:
-- BEFORE → runs before the operation
-- AFTER  → runs after the operation
--
-- Row-level vs Statement-level:
-- FOR EACH ROW       → fires once per affected row
-- FOR EACH STATEMENT → fires once per SQL statement
--
-- Special variables inside trigger functions:
-- NEW → the new row being inserted or updated
-- OLD → the old row before update or delete
--
-- How to create a trigger (two steps):
-- Step 1: Create the TRIGGER FUNCTION
-- Step 2: Attach it to a table using CREATE TRIGGER
--
-- Syntax:
-- CREATE OR REPLACE FUNCTION trigger_fn()
-- RETURNS TRIGGER LANGUAGE plpgsql AS $$
-- BEGIN
--     -- use NEW and OLD here
--     RETURN NEW;  ← for BEFORE triggers (required)
-- END; $$;
--
-- CREATE TRIGGER trigger_name
-- BEFORE/AFTER INSERT/UPDATE/DELETE
-- ON table_name
-- FOR EACH ROW
-- EXECUTE FUNCTION trigger_fn();
-- =====================================================


-- =====================================================
-- TRIGGER 1: Auto-update updated_at timestamp
-- Fires BEFORE UPDATE on employees table
-- Sets updated_at to current time automatically
-- =====================================================

-- Step 1: Create the trigger function
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- NEW refers to the row being updated
    -- We just update the updated_at field automatically
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
    -- RETURN NEW is required for BEFORE triggers
    -- It passes the (possibly modified) row forward
END;
$$;

-- Step 2: Attach trigger to employees table
CREATE TRIGGER trg_employee_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- Test: Update an employee salary
UPDATE employees
SET salary = 125000.00
WHERE id = 1;

SELECT id, name, salary, updated_at FROM employees WHERE id = 1;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬───────────┬─────────────────────┐
-- │ id │     name      │  salary   │      updated_at      │
-- ├────┼───────────────┼───────────┼─────────────────────┤
-- │  1 │ Alice Johnson │ 125000.00 │ 2024-01-15 14:32:11 │
-- └────┴───────────────┴───────────┴─────────────────────┘
-- updated_at is automatically set — we did not set it
-- =====================================================


-- =====================================================
-- TRIGGER 2: Salary history log
-- Fires AFTER UPDATE on salary column
-- Records every salary change into salary_history table
-- =====================================================

CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Only log if the salary actually changed
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_history (employee_id, old_salary, new_salary)
        VALUES (OLD.id, OLD.salary, NEW.salary);
        -- OLD.salary = salary before the update
        -- NEW.salary = salary after the update
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_salary_change
AFTER UPDATE OF salary ON employees
-- OF salary → only fires when salary column changes
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();

-- Test: Give a raise to Bob Smith
UPDATE employees SET salary = 90000.00 WHERE id = 2;

-- Check salary history
SELECT
    sh.id,
    e.name         AS employee_name,
    sh.old_salary,
    sh.new_salary,
    sh.new_salary - sh.old_salary AS raise_amount,
    sh.changed_at,
    sh.changed_by
FROM salary_history sh
INNER JOIN employees e ON sh.employee_id = e.id;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬────────────┬────────────┬─────────────┬─────────────────────┬─────────────┐
-- │ id │ employee_name │ old_salary │ new_salary │ raise_amount│     changed_at      │  changed_by │
-- ├────┼───────────────┼────────────┼────────────┼─────────────┼─────────────────────┼─────────────┤
-- │  1 │ Alice Johnson │ 120000.00  │ 125000.00  │   5000.00   │ 2024-01-15 14:32:11 │  postgres   │
-- │  2 │ Bob Smith     │  85000.00  │  90000.00  │   5000.00   │ 2024-01-15 14:33:05 │  postgres   │
-- └────┴───────────────┴────────────┴────────────┴─────────────┴─────────────────────┴─────────────┘
-- =====================================================


-- =====================================================
-- TRIGGER 3: Audit log — track all INSERT operations
-- Fires AFTER INSERT on employees
-- Saves new record data into audit_log table
-- =====================================================

CREATE OR REPLACE FUNCTION audit_employee_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, new_data)
    VALUES (
        'employees',
        'INSERT',
        CONCAT(
            'id: ', NEW.id,
            ', name: ', NEW.name,
            ', salary: ', NEW.salary,
            ', dept: ', NEW.department_id
        )
    );
    -- NEW contains all values of the inserted row
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_audit_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION audit_employee_insert();

-- Test: Insert a new employee
INSERT INTO employees (name, email, department_id, salary, hire_date, job_title)
VALUES ('Sam Wilson', 'sam@company.com', 1, 78000.00, '2024-01-15', 'Junior Engineer');

-- Check audit log
SELECT * FROM audit_log WHERE operation = 'INSERT';

-- =====================================================
-- Output:
-- ┌────┬────────────┬───────────┬──────────┬──────────────────────────────────────────────────┬─────────────┬─────────────────────┐
-- │ id │ table_name │ operation │ old_data │                     new_data                     │performed_by │    performed_at      │
-- ├────┼────────────┼───────────┼──────────┼──────────────────────────────────────────────────┼─────────────┼─────────────────────┤
-- │  1 │ employees  │  INSERT   │  NULL    │ id: 16, name: Sam Wilson, salary: 78000, dept: 1 │  postgres   │ 2024-01-15 14:35:22 │
-- └────┴────────────┴───────────┴──────────┴──────────────────────────────────────────────────┴─────────────┴─────────────────────┘
-- =====================================================


-- =====================================================
-- TRIGGER 4: Audit log — track DELETE operations
-- Fires AFTER DELETE on employees
-- Saves the deleted row data so we can recover info
-- =====================================================

CREATE OR REPLACE FUNCTION audit_employee_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, old_data)
    VALUES (
        'employees',
        'DELETE',
        CONCAT(
            'id: ', OLD.id,
            ', name: ', OLD.name,
            ', salary: ', OLD.salary,
            ', dept: ', OLD.department_id
        )
    );
    -- OLD contains the row that was just deleted
    -- NEW does not exist for DELETE triggers
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_audit_employee_delete
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION audit_employee_delete();

-- Test: Delete the employee we just added
DELETE FROM employees WHERE email = 'sam@company.com';

-- Check audit log for DELETE
SELECT * FROM audit_log WHERE operation = 'DELETE';

-- =====================================================
-- Output:
-- ┌────┬────────────┬───────────┬──────────────────────────────────────────────────┬──────────┬─────────────┬─────────────────────┐
-- │ id │ table_name │ operation │                     old_data                     │ new_data │performed_by │    performed_at      │
-- ├────┼────────────┼───────────┼──────────────────────────────────────────────────┼──────────┼─────────────┼─────────────────────┤
-- │  2 │ employees  │  DELETE   │ id: 16, name: Sam Wilson, salary: 78000, dept: 1 │   NULL   │  postgres   │ 2024-01-15 14:36:44 │
-- └────┴────────────┴───────────┴──────────────────────────────────────────────────┴──────────┴─────────────┴─────────────────────┘
-- =====================================================


-- =====================================================
-- TRIGGER 5: Prevent invalid salary update
-- BEFORE UPDATE trigger that blocks bad data
-- No one can reduce an employee salary
-- =====================================================

CREATE OR REPLACE FUNCTION prevent_salary_decrease()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check: new salary cannot be less than old salary
    IF NEW.salary < OLD.salary THEN
        RAISE EXCEPTION
            'Salary decrease not allowed. Current: %, Attempted: %',
            OLD.salary, NEW.salary;
        -- RAISE EXCEPTION → cancels the UPDATE and shows error
    END IF;

    RETURN NEW;
    -- RETURN NEW → allow the update to proceed
END;
$$;

CREATE TRIGGER trg_prevent_salary_decrease
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_salary_decrease();

-- Test: Try to reduce Alice's salary
UPDATE employees SET salary = 80000.00 WHERE id = 1;

-- =====================================================
-- Output:
-- ERROR:  Salary decrease not allowed. Current: 125000.00, Attempted: 80000.00
-- ← The trigger blocked the invalid update completely
-- =====================================================

-- Valid update: increase salary
UPDATE employees SET salary = 130000.00 WHERE id = 1;

-- =====================================================
-- Output:
-- UPDATE 1  ← This succeeds because new > old
-- =====================================================


-- =====================================================
-- TRIGGER 6: BEFORE INSERT — enforce email format
-- Block any insert where email does not contain @
-- =====================================================

CREATE OR REPLACE FUNCTION validate_email()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check email contains @ symbol
    IF POSITION('@' IN NEW.email) = 0 THEN
        RAISE EXCEPTION
            'Invalid email: %. Email must contain @', NEW.email;
    END IF;

    -- Auto-lowercase the email before saving
    NEW.email := LOWER(NEW.email);

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_email
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION validate_email();

-- Test: Insert with invalid email
INSERT INTO employees (name, email, department_id, salary, hire_date, job_title)
VALUES ('Test User', 'invalidemail', 1, 60000.00, '2024-01-15', 'Tester');

-- =====================================================
-- Output:
-- ERROR:  Invalid email: invalidemail. Email must contain @
-- =====================================================

-- Test: Insert with UPPERCASE email (gets auto-lowercased)
INSERT INTO employees (name, email, department_id, salary, hire_date, job_title)
VALUES ('Test User', 'TEST@COMPANY.COM', 1, 60000.00, '2024-01-15', 'Tester');

SELECT name, email FROM employees WHERE name = 'Test User';

-- =====================================================
-- Output:
-- ┌───────────┬──────────────────┐
-- │   name    │      email       │
-- ├───────────┼──────────────────┤
-- │ Test User │ test@company.com │  ← auto-lowercased
-- └───────────┴──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- View all triggers created
-- -------------------------------------------------------
SELECT
    trigger_name,
    event_manipulation  AS event,
    event_object_table  AS table_name,
    action_timing       AS timing,
    action_orientation  AS level
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY table_name, timing, event;

-- =====================================================
-- Output:
-- ┌──────────────────────────────────┬────────┬────────────┬────────┬───────┐
-- │          trigger_name            │ event  │ table_name │ timing │ level │
-- ├──────────────────────────────────┼────────┼────────────┼────────┼───────┤
-- │ trg_validate_email               │ INSERT │ employees  │ BEFORE │  ROW  │
-- │ trg_audit_employee_insert        │ INSERT │ employees  │ AFTER  │  ROW  │
-- │ trg_prevent_salary_decrease      │ UPDATE │ employees  │ BEFORE │  ROW  │
-- │ trg_employee_updated_at          │ UPDATE │ employees  │ BEFORE │  ROW  │
-- │ trg_log_salary_change            │ UPDATE │ employees  │ AFTER  │  ROW  │
-- │ trg_audit_employee_delete        │ DELETE │ employees  │ AFTER  │  ROW  │
-- └──────────────────────────────────┴────────┴────────────┴────────┴───────┘
-- =====================================================


-- -------------------------------------------------------
-- Disable and Drop Triggers (cleanup)
-- -------------------------------------------------------
-- Disable a trigger temporarily
-- ALTER TABLE employees DISABLE TRIGGER trg_log_salary_change;

-- Re-enable it
-- ALTER TABLE employees ENABLE TRIGGER trg_log_salary_change;

-- Drop triggers
-- DROP TRIGGER trg_employee_updated_at    ON employees;
-- DROP TRIGGER trg_log_salary_change      ON employees;
-- DROP TRIGGER trg_audit_employee_insert  ON employees;
-- DROP TRIGGER trg_audit_employee_delete  ON employees;
-- DROP TRIGGER trg_prevent_salary_decrease ON employees;
-- DROP TRIGGER trg_validate_email         ON employees;


-- =====================================================
-- ADVANTAGES of Triggers:
-- → Enforce business rules at database level
-- → Audit trails happen automatically
-- → No need to modify application code
-- → Guaranteed to run even with direct DB access
--
-- LIMITATIONS:
-- → Hard to debug (invisible to app developers)
-- → Too many triggers can slow down DML operations
-- → Complex trigger chains are hard to maintain
-- → Business logic split between DB and app is risky
--
-- INTERVIEW QUESTIONS:
-- Q: What is a Trigger?
-- A: A function that automatically fires on INSERT,
--    UPDATE, or DELETE events on a table.
--
-- Q: What are OLD and NEW in a trigger?
-- A: NEW = row after the change (INSERT/UPDATE)
--    OLD = row before the change (UPDATE/DELETE)
--    DELETE has no NEW. INSERT has no OLD.
--
-- Q: BEFORE vs AFTER trigger?
-- A: BEFORE can modify NEW before saving.
--    AFTER runs after data is already committed.
--    Use BEFORE for validation, AFTER for logging.
--
-- Q: Can a trigger call another trigger?
-- A: Yes. This is called cascading triggers and
--    should be used carefully to avoid infinite loops.
-- =====================================================