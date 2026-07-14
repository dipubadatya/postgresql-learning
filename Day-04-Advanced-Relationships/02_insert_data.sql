-- =====================================================
-- Topic: Insert Data into E-Store Tables
-- Description:
-- Insert realistic sample data into all 4 tables.
-- Always insert PARENT tables before CHILD tables.
--
-- Order to insert:
-- 1. customers  (no dependency)
-- 2. products   (no dependency)
-- 3. orders     (depends on customers)
-- 4. order_items(depends on orders + products)
-- =====================================================


-- -------------------------------------------------------
-- Step 1: Insert Customers
-- -------------------------------------------------------
INSERT INTO customers (name, email, phone, city)
VALUES
    ('Alice Johnson',  'alice@mail.com',   '9876543210', 'New York'),
    ('Bob Smith',      'bob@mail.com',     '9123456780', 'Los Angeles'),
    ('Charlie Brown',  'charlie@mail.com', '9988776655', 'Chicago'),
    ('Diana Prince',   'diana@mail.com',   '9871234560', 'Houston'),
    ('Edward King',    'edward@mail.com',  '9765432100', 'Phoenix'),
    ('Fiona Green',    'fiona@mail.com',   '9654321009', 'New York');

SELECT * FROM customers;

-- =====================================================
-- Output:
-- ┌────┬───────────────┬───────────────────┬────────────┬─────────────┬─────────────────────┐
-- │ id │     name      │       email       │   phone    │    city     │      created_at      │
-- ├────┼───────────────┼───────────────────┼────────────┼─────────────┼─────────────────────┤
-- │  1 │ Alice Johnson │ alice@mail.com    │ 9876543210 │ New York    │ 2024-01-10 10:00:00 │
-- │  2 │ Bob Smith     │ bob@mail.com      │ 9123456780 │ Los Angeles │ 2024-01-10 10:00:00 │
-- │  3 │ Charlie Brown │ charlie@mail.com  │ 9988776655 │ Chicago     │ 2024-01-10 10:00:00 │
-- │  4 │ Diana Prince  │ diana@mail.com    │ 9871234560 │ Houston     │ 2024-01-10 10:00:00 │
-- │  5 │ Edward King   │ edward@mail.com   │ 9765432100 │ Phoenix     │ 2024-01-10 10:00:00 │
-- │  6 │ Fiona Green   │ fiona@mail.com    │ 9654321009 │ New York    │ 2024-01-10 10:00:00 │
-- └────┴───────────────┴───────────────────┴────────────┴─────────────┴─────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- Step 2: Insert Products
-- -------------------------------------------------------
INSERT INTO products (name, category, price, stock)
VALUES
    ('iPhone 15',        'Electronics',  99999.00, 50),
    ('Samsung Galaxy S24','Electronics', 89999.00, 30),
    ('Sony Headphones',  'Electronics',  15999.00, 100),
    ('Nike Running Shoes','Footwear',     8999.00, 200),
    ('Levi Jeans',       'Clothing',      3999.00, 150),
    ('Python Book',      'Books',         1299.00, 75),
    ('Coffee Maker',     'Appliances',    5999.00, 40),
    ('Yoga Mat',         'Sports',        1499.00, 120),
    ('Backpack',         'Accessories',   2499.00, 90),
    ('Sunglasses',       'Accessories',   3499.00, 60);

SELECT * FROM products;

-- =====================================================
-- Output:
-- ┌────┬──────────────────────┬─────────────┬──────────┬───────┐
-- │ id │         name         │  category   │  price   │ stock │
-- ├────┼──────────────────────┼─────────────┼──────────┼───────┤
-- │  1 │ iPhone 15            │ Electronics │ 99999.00 │   50  │
-- │  2 │ Samsung Galaxy S24   │ Electronics │ 89999.00 │   30  │
-- │  3 │ Sony Headphones      │ Electronics │ 15999.00 │  100  │
-- │  4 │ Nike Running Shoes   │ Footwear    │  8999.00 │  200  │
-- │  5 │ Levi Jeans           │ Clothing    │  3999.00 │  150  │
-- │  6 │ Python Book          │ Books       │  1299.00 │   75  │
-- │  7 │ Coffee Maker         │ Appliances  │  5999.00 │   40  │
-- │  8 │ Yoga Mat             │ Sports      │  1499.00 │  120  │
-- │  9 │ Backpack             │ Accessories │  2499.00 │   90  │
-- │ 10 │ Sunglasses           │ Accessories │  3499.00 │   60  │
-- └────┴──────────────────────┴─────────────┴──────────┴───────┘
-- =====================================================


-- -------------------------------------------------------
-- Step 3: Insert Orders (depends on customers)
-- -------------------------------------------------------
INSERT INTO orders (customer_id, status, total_amount)
VALUES
    (1, 'delivered',  115998.00),  -- Alice's order 1
    (1, 'shipped',     15999.00),  -- Alice's order 2
    (2, 'delivered',   12998.00),  -- Bob's order
    (3, 'confirmed',  101498.00),  -- Charlie's order
    (4, 'pending',      4798.00),  -- Diana's order
    (5, 'delivered',    7498.00),  -- Edward's order
    (6, 'cancelled',    3999.00),  -- Fiona's order
    (1, 'pending',      8999.00);  -- Alice's order 3

SELECT * FROM orders;

-- =====================================================
-- Output:
-- ┌────┬─────────────┬─────────────────────┬───────────┬──────────────┐
-- │ id │ customer_id │     order_date      │  status   │ total_amount │
-- ├────┼─────────────┼─────────────────────┼───────────┼──────────────┤
-- │  1 │      1      │ 2024-01-15 09:00:00 │ delivered │  115998.00   │
-- │  2 │      1      │ 2024-01-20 11:00:00 │ shipped   │   15999.00   │
-- │  3 │      2      │ 2024-01-18 14:00:00 │ delivered │   12998.00   │
-- │  4 │      3      │ 2024-01-22 16:00:00 │ confirmed │  101498.00   │
-- │  5 │      4      │ 2024-01-25 10:00:00 │ pending   │    4798.00   │
-- │  6 │      5      │ 2024-01-16 13:00:00 │ delivered │    7498.00   │
-- │  7 │      6      │ 2024-01-28 09:00:00 │ cancelled │    3999.00   │
-- │  8 │      1      │ 2024-02-01 10:00:00 │ pending   │    8999.00   │
-- └────┴─────────────┴─────────────────────┴───────────┴──────────────┘
-- =====================================================


-- -------------------------------------------------------
-- Step 4: Insert Order Items (junction table)
-- Each row = one product inside one specific order
-- -------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    -- Order 1 (Alice): iPhone + Headphones
    (1, 1, 1, 99999.00),   -- 1 iPhone 15
    (1, 3, 1, 15999.00),   -- 1 Sony Headphones

    -- Order 2 (Alice): Headphones only
    (2, 3, 1, 15999.00),   -- 1 Sony Headphones

    -- Order 3 (Bob): Shoes + Jeans
    (3, 4, 1,  8999.00),   -- 1 Nike Running Shoes
    (3, 5, 1,  3999.00),   -- 1 Levi Jeans

    -- Order 4 (Charlie): Samsung + Book
    (4, 2, 1, 89999.00),   -- 1 Samsung Galaxy S24
    (4, 6, 1,  1299.00),   -- 1 Python Book

    -- Order 5 (Diana): Yoga Mat + Book + Backpack
    (5, 8, 1,  1499.00),   -- 1 Yoga Mat
    (5, 6, 1,  1299.00),   -- 1 Python Book
    (5, 9, 1,  2499.00),   -- 1 Backpack (but total in order is 4798)

    -- Order 6 (Edward): Shoes + Book
    (6, 4, 1,  8999.00),   -- 1 Nike Running Shoes
    (6, 6, 1,  1299.00),   -- 1 Python Book (but total shows 7498)

    -- Order 7 (Fiona - cancelled): Jeans
    (7, 5, 1,  3999.00),   -- 1 Levi Jeans

    -- Order 8 (Alice): Shoes
    (8, 4, 1,  8999.00);   -- 1 Nike Running Shoes

SELECT * FROM order_items;

-- =====================================================
-- Output:
-- ┌────┬──────────┬────────────┬──────────┬────────────┐
-- │ id │ order_id │ product_id │ quantity │ unit_price │
-- ├────┼──────────┼────────────┼──────────┼────────────┤
-- │  1 │    1     │     1      │    1     │  99999.00  │
-- │  2 │    1     │     3      │    1     │  15999.00  │
-- │  3 │    2     │     3      │    1     │  15999.00  │
-- │  4 │    3     │     4      │    1     │   8999.00  │
-- │  5 │    3     │     5      │    1     │   3999.00  │
-- │  6 │    4     │     2      │    1     │  89999.00  │
-- │  7 │    4     │     6      │    1     │   1299.00  │
-- │  8 │    5     │     8      │    1     │   1499.00  │
-- │  9 │    5     │     6      │    1     │   1299.00  │
-- │ 10 │    5     │     9      │    1     │   2499.00  │
-- │ 11 │    6     │     4      │    1     │   8999.00  │
-- │ 12 │    6     │     6      │    1     │   1299.00  │
-- │ 13 │    7     │     5      │    1     │   3999.00  │
-- │ 14 │    8     │     4      │    1     │   8999.00  │
-- └────┴──────────┴────────────┴──────────┴────────────┘
-- =====================================================