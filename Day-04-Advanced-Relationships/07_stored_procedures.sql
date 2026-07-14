-- =====================================================
-- Topic: Stored Procedures
-- Description:
-- A Stored Procedure is a set of SQL statements
-- saved in the database with a name.
-- You can call (execute) it whenever you need it
-- without rewriting the same SQL again.
--
-- Think of it like a FUNCTION in programming.
-- You define it once → call it many times.
--
-- Benefits:
-- ┌──────────────────┬────────────────────────────────────────┐
-- │ Benefit          │ Explanation                            │
-- ├──────────────────┼────────────────────────────────────────┤
-- │ Reusability      │ Write once, call many times            │
-- │ Less repetition  │ No need to copy the same SQL           │
-- │ Cleaner code     │ Business logic lives in the database   │
-- │ Performance      │ Pre-compiled, runs faster              │
-- │ Security         │ Hide table details, expose only proc   │
-- └──────────────────┴────────────────────────────────────────┘
--
-- Syntax:
-- CREATE OR REPLACE PROCEDURE procedure_name(
--     param1 datatype,
--     param2 datatype
-- )
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     -- SQL statements here
-- END;
-- $$;
--
-- Call it:
-- CALL procedure_name(value1, value2);
-- =====================================================


-- -------------------------------------------------------
-- 1. Simple Procedure: place_order
--    Places a new order for a customer
--    Parameters: customer id and total amount
-- -------------------------------------------------------
CREATE OR REPLACE PROCEDURE place_order(
    p_customer_id  INT,
    p_total_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO orders (customer_id, total_amount, status)
    VALUES (p_customer_id, p_total_amount, 'pending');

    RAISE NOTICE 'Order placed for customer id: %', p_customer_id;
    -- RAISE NOTICE → prints a message (like console.log)
    -- % → placeholder replaced by the variable value
END;
$$;

-- Call the procedure
CALL place_order(2, 5999.00);

-- =====================================================
-- Output:
-- NOTICE: Order placed for customer id: 2
-- CALL
-- =====================================================

SELECT * FROM orders WHERE customer_id = 2;

-- =====================================================
-- Output:
-- ┌────┬─────────────┬─────────────────────┬─────────┬──────────────┐
-- │ id │ customer_id │     order_date      │ status  │ total_amount │
-- ├────┼─────────────┼─────────────────────┼─────────┼──────────────┤
-- │  3 │      2      │ 2024-01-18 14:00:00 │delivered│   12998.00   │
-- │  9 │      2      │ 2024-02-10 12:00:00 │ pending │    5999.00   │ ← new
-- └────┴─────────────┴─────────────────────┴─────────┴──────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. Procedure: add_order_item
--    Adds a product to an existing order
--    Also updates the product stock
-- -------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_order_item(
    p_order_id   INT,
    p_product_id INT,
    p_quantity   INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price      NUMERIC;
    -- DECLARE → declare variables to use inside procedure
    -- v_price will store the product's current price
    v_stock      INT;
BEGIN
    -- Step 1: Get the current price and stock of the product
    SELECT price, stock
    INTO v_price, v_stock
    FROM products
    WHERE id = p_product_id;

    -- Step 2: Check if enough stock is available
    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock. Available: %, Requested: %',
                        v_stock, p_quantity;
        -- RAISE EXCEPTION → stops the procedure and shows error
    END IF;

    -- Step 3: Insert the item into order_items
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);

    -- Step 4: Reduce the stock of the product
    UPDATE products
    SET stock = stock - p_quantity
    WHERE id = p_product_id;

    -- Step 5: Update the total_amount in the orders table
    UPDATE orders
    SET total_amount = total_amount + (v_price * p_quantity)
    WHERE id = p_order_id;

    RAISE NOTICE 'Item added to order %. Product id: %, Qty: %, Price: %',
                 p_order_id, p_product_id, p_quantity, v_price;
END;
$$;

-- Add Coffee Maker (product id=7) to order id=9
CALL add_order_item(9, 7, 1);

-- =====================================================
-- Output:
-- NOTICE: Item added to order 9. Product id: 7, Qty: 1, Price: 5999.00
-- CALL
-- =====================================================

-- Verify product stock decreased
SELECT id, name, stock FROM products WHERE id = 7;

-- =====================================================
-- Output:
-- ┌────┬──────────────┬───────┐
-- │ id │     name     │ stock │
-- ├────┼──────────────┼───────┤
-- │  7 │ Coffee Maker │  39   │  ← was 40, now 39
-- └────┴──────────────┴───────┘
-- =====================================================

-- Try to order more than available stock
CALL add_order_item(9, 7, 1000);

-- =====================================================
-- Output:
-- ERROR: Not enough stock. Available: 39, Requested: 1000
-- ← Procedure blocked the invalid operation
-- =====================================================


-- -------------------------------------------------------
-- 3. Procedure: update_order_status
--    Changes the status of an order
-- -------------------------------------------------------
CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id INT,
    p_status   VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_status VARCHAR;
BEGIN
    -- Get current status
    SELECT status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;

    -- Check if order exists
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order id % does not exist', p_order_id;
    END IF;

    -- Cannot cancel a delivered order
    IF v_current_status = 'delivered' THEN
        RAISE EXCEPTION 'Cannot change status. Order % is already delivered.',
                        p_order_id;
    END IF;

    -- Update the status
    UPDATE orders
    SET status = p_status
    WHERE id = p_order_id;

    RAISE NOTICE 'Order % status changed from % to %',
                 p_order_id, v_current_status, p_status;
END;
$$;

-- Update order 8 from pending to confirmed
CALL update_order_status(8, 'confirmed');

-- =====================================================
-- Output:
-- NOTICE: Order 8 status changed from pending to confirmed
-- CALL
-- =====================================================

-- Try to change a delivered order
CALL update_order_status(1, 'cancelled');

-- =====================================================
-- Output:
-- ERROR: Cannot change status. Order 1 is already delivered.
-- =====================================================

-- Try with non-existing order
CALL update_order_status(999, 'shipped');

-- =====================================================
-- Output:
-- ERROR: Order id 999 does not exist
-- =====================================================


-- -------------------------------------------------------
-- 4. Procedure: get_customer_report
--    Print a summary report for a specific customer
-- -------------------------------------------------------
CREATE OR REPLACE PROCEDURE get_customer_report(
    p_customer_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_name         VARCHAR;
    v_total_orders INT;
    v_total_spent  NUMERIC;
BEGIN
    -- Get customer name
    SELECT name INTO v_name
    FROM customers
    WHERE id = p_customer_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer id % not found', p_customer_id;
    END IF;

    -- Get order stats
    SELECT COUNT(*), COALESCE(SUM(total_amount), 0)
    INTO v_total_orders, v_total_spent
    FROM orders
    WHERE customer_id = p_customer_id;

    -- Print the report
    RAISE NOTICE '============================';
    RAISE NOTICE 'Customer Report';
    RAISE NOTICE '============================';
    RAISE NOTICE 'Name        : %', v_name;
    RAISE NOTICE 'Total Orders: %', v_total_orders;
    RAISE NOTICE 'Total Spent : Rs. %', v_total_spent;
    RAISE NOTICE '============================';
END;
$$;

-- Get report for Alice (id=1)
CALL get_customer_report(1);

-- =====================================================
-- Output:
-- NOTICE: ============================
-- NOTICE: Customer Report
-- NOTICE: ============================
-- NOTICE: Name        : Alice Johnson
-- NOTICE: Total Orders: 3
-- NOTICE: Total Spent : Rs. 140996.00
-- NOTICE: ============================
-- CALL
-- =====================================================

-- Get report for non-existing customer
CALL get_customer_report(999);

-- =====================================================
-- Output:
-- ERROR: Customer id 999 not found
-- =====================================================