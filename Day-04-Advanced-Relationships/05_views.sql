-- =====================================================
-- Topic: Views
-- Description:
-- A VIEW is a saved SQL query that acts like a
-- virtual table. It does not store data itself.
-- Every time you query a view, it runs the
-- saved query and shows you fresh results.
--
-- Think of a view like a WINDOW into your tables.
-- The window itself has no data. But when you
-- look through it, you see the actual data.
--
-- Benefits of Views:
-- ┌──────────────────┬──────────────────────────────────────────┐
-- │ Benefit          │ Explanation                              │
-- ├──────────────────┼──────────────────────────────────────────┤
-- │ Simplicity       │ Hide complex JOIN queries behind a name  │
-- │ Security         │ Show only specific columns to users      │
-- │ Reusability      │ Write query once, use it many times      │
-- │ Consistency      │ Everyone sees the same structured data   │
-- └──────────────────┴──────────────────────────────────────────┘
--
-- Syntax:
-- CREATE VIEW view_name AS
--     SELECT ... FROM ... JOIN ... WHERE ...;
--
-- Use it:
-- SELECT * FROM view_name;
--
-- Update it:
-- CREATE OR REPLACE VIEW view_name AS ...;
--
-- Delete it:
-- DROP VIEW view_name;
-- =====================================================


-- -------------------------------------------------------
-- 1. View: customer_order_summary
--    Shows each customer with their order summary
-- -------------------------------------------------------
CREATE VIEW customer_order_summary AS
SELECT
    c.id                        AS customer_id,
    c.name                      AS customer_name,
    c.email,
    c.city,
    COUNT(o.id)                 AS total_orders,
    SUM(o.total_amount)         AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    MAX(o.order_date)           AS last_order_date
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name, c.email, c.city;

-- Use the view
SELECT * FROM customer_order_summary;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┬───────────────────┬─────────────┬──────────────┬─────────────┬─────────────────┬──────────────────────┐
-- │ customer_id │ customer_name │       email       │    city     │ total_orders │ total_spent │ avg_order_value │   last_order_date    │
-- ├─────────────┼───────────────┼───────────────────┼─────────────┼──────────────┼─────────────┼─────────────────┼──────────────────────┤
-- │      1      │ Alice Johnson │ alice@mail.com    │ New York    │      3       │  140996.00  │    46998.67     │ 2024-02-01 10:00:00  │
-- │      2      │ Bob Smith     │ bob@mail.com      │ Los Angeles │      1       │   12998.00  │    12998.00     │ 2024-01-18 14:00:00  │
-- │      3      │ Charlie Brown │ charlie@mail.com  │ Chicago     │      1       │  101498.00  │   101498.00     │ 2024-01-22 16:00:00  │
-- │      4      │ Diana Prince  │ diana@mail.com    │ Houston     │      1       │    4798.00  │     4798.00     │ 2024-01-25 10:00:00  │
-- │      5      │ Edward King   │ edward@mail.com   │ Phoenix     │      1       │    7498.00  │     7498.00     │ 2024-01-16 13:00:00  │
-- │      6      │ Fiona Green   │ fiona@mail.com    │ New York    │      1       │    3999.00  │     3999.00     │ 2024-01-28 09:00:00  │
-- └─────────────┴───────────────┴───────────────────┴─────────────┴──────────────┴─────────────┴─────────────────┴──────────────────────┘
-- =====================================================

-- Query the view like a normal table
-- Find top spending customers
SELECT customer_name, total_spent
FROM customer_order_summary
WHERE total_spent > 10000
ORDER BY total_spent DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┐
-- │ customer_name │ total_spent │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │  140996.00  │
-- │ Charlie Brown │  101498.00  │
-- │ Bob Smith     │   12998.00  │
-- └───────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. View: product_sales_report
--    Shows sales performance of each product
-- -------------------------------------------------------
CREATE VIEW product_sales_report AS
SELECT
    p.id                                        AS product_id,
    p.name                                      AS product_name,
    p.category,
    p.price                                     AS current_price,
    p.stock                                     AS remaining_stock,
    COUNT(oi.id)                                AS times_ordered,
    COALESCE(SUM(oi.quantity), 0)               AS total_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
    -- COALESCE → if value is NULL, return 0 instead
FROM products p
LEFT JOIN order_items oi
    ON p.id = oi.product_id
GROUP BY p.id, p.name, p.category, p.price, p.stock;

SELECT * FROM product_sales_report
ORDER BY total_revenue DESC;

-- =====================================================
-- Output:
-- ┌────────────┬──────────────────────┬─────────────┬───────────────┬─────────────────┬───────────────┬────────────┬───────────────┐
-- │ product_id │     product_name     │  category   │ current_price │ remaining_stock │ times_ordered │ total_sold │ total_revenue │
-- ├────────────┼──────────────────────┼─────────────┼───────────────┼─────────────────┼───────────────┼────────────┼───────────────┤
-- │     1      │ iPhone 15            │ Electronics │    99999.00   │       50        │       1       │     1      │   99999.00    │
-- │     2      │ Samsung Galaxy S24   │ Electronics │    89999.00   │       30        │       1       │     1      │   89999.00    │
-- │     3      │ Sony Headphones      │ Electronics │    15999.00   │      100        │       2       │     2      │   31998.00    │
-- │     4      │ Nike Running Shoes   │ Footwear    │     8999.00   │      200        │       3       │     3      │   26997.00    │
-- │     5      │ Levi Jeans           │ Clothing    │     3999.00   │      150        │       2       │     2      │    7998.00    │
-- │     6      │ Python Book          │ Books       │     1299.00   │       75        │       4       │     4      │    5196.00    │
-- │     9      │ Backpack             │ Accessories │     2499.00   │       90        │       1       │     1      │    2499.00    │
-- │     8      │ Yoga Mat             │ Sports      │     1499.00   │      120        │       1       │     1      │    1499.00    │
-- │     7      │ Coffee Maker         │ Appliances  │     5999.00   │       40        │       0       │     0      │       0       │
-- │    10      │ Sunglasses           │ Accessories │     3499.00   │       60        │       0       │     0      │       0       │
-- └────────────┴──────────────────────┴─────────────┴───────────────┴─────────────────┴───────────────┴────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. View: order_detail_view
--    Full order breakdown with customer and products
-- -------------------------------------------------------
CREATE VIEW order_detail_view AS
SELECT
    o.id                              AS order_id,
    c.name                            AS customer_name,
    c.city,
    o.status                          AS order_status,
    p.name                            AS product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)     AS item_total,
    o.order_date
FROM orders o
INNER JOIN customers c   ON o.customer_id  = c.id
INNER JOIN order_items oi ON o.id          = oi.order_id
INNER JOIN products p    ON oi.product_id  = p.id;

SELECT * FROM order_detail_view
ORDER BY order_id;

-- =====================================================
-- Output:
-- ┌──────────┬───────────────┬─────────────┬─────────────┬──────────────────────┬─────────────┬──────────┬────────────┬────────────┬─────────────────────┐
-- │ order_id │ customer_name │    city     │order_status │     product_name     │  category   │ quantity │ unit_price │ item_total │      order_date      │
-- ├──────────┼───────────────┼─────────────┼─────────────┼──────────────────────┼─────────────┼──────────┼────────────┼────────────┼─────────────────────┤
-- │    1     │ Alice Johnson │ New York    │ delivered   │ iPhone 15            │ Electronics │    1     │  99999.00  │  99999.00  │ 2024-01-15 09:00:00 │
-- │    1     │ Alice Johnson │ New York    │ delivered   │ Sony Headphones      │ Electronics │    1     │  15999.00  │  15999.00  │ 2024-01-15 09:00:00 │
-- │    2     │ Alice Johnson │ New York    │ shipped     │ Sony Headphones      │ Electronics │    1     │  15999.00  │  15999.00  │ 2024-01-20 11:00:00 │
-- │    3     │ Bob Smith     │ Los Angeles │ delivered   │ Nike Running Shoes   │ Footwear    │    1     │   8999.00  │   8999.00  │ 2024-01-18 14:00:00 │
-- │    3     │ Bob Smith     │ Los Angeles │ delivered   │ Levi Jeans           │ Clothing    │    1     │   3999.00  │   3999.00  │ 2024-01-18 14:00:00 │
-- └──────────┴───────────────┴─────────────┴─────────────┴──────────────────────┴─────────────┴──────────┴────────────┴────────────┴─────────────────────┘
-- (remaining rows truncated for space)
-- =====================================================


-- -------------------------------------------------------
-- 4. CREATE OR REPLACE VIEW → Update existing view
--    Add phone column to customer_order_summary
-- -------------------------------------------------------
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT
    c.id                          AS customer_id,
    c.name                        AS customer_name,
    c.email,
    c.phone,
    c.city,
    COUNT(o.id)                   AS total_orders,
    SUM(o.total_amount)           AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    MAX(o.order_date)             AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name, c.email, c.phone, c.city;

-- =====================================================
-- Output:
-- CREATE VIEW  ← view updated successfully
-- =====================================================


-- -------------------------------------------------------
-- 5. DROP VIEW → Delete a view
-- -------------------------------------------------------
-- DROP VIEW order_detail_view;
-- We keep it for now, using it in next files