-- =====================================================
-- Topic: Many to Many Relationship
-- Description:
-- One order can have MANY products.
-- One product can appear in MANY orders.
--
-- orders (Many) ◄──── order_items ────► products (Many)
--
-- order_items is the JUNCTION TABLE.
-- It sits in the middle and breaks the
-- Many-to-Many into two One-to-Many relationships.
--
-- Without junction table:
-- orders ↔ products  (impossible to store directly)
--
-- With junction table:
-- orders (1) ──► order_items (Many) ◄── (1) products
-- =====================================================


-- -------------------------------------------------------
-- 1. Full order details with products
--    Show customer → order → products in one query
-- -------------------------------------------------------
SELECT
    c.name            AS customer_name,
    o.id              AS order_id,
    o.status          AS order_status,
    p.name            AS product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS item_total
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id
INNER JOIN order_items oi
    ON o.id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.id
ORDER BY c.name, o.id, p.name;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────┬─────────────┬──────────────────────┬─────────────┬──────────┬────────────┬────────────┐
-- │ customer_name │ order_id │order_status │     product_name     │  category   │ quantity │ unit_price │ item_total │
-- ├───────────────┼──────────┼─────────────┼──────────────────────┼─────────────┼──────────┼────────────┼────────────┤
-- │ Alice Johnson │    1     │ delivered   │ iPhone 15            │ Electronics │    1     │  99999.00  │  99999.00  │
-- │ Alice Johnson │    1     │ delivered   │ Sony Headphones      │ Electronics │    1     │  15999.00  │  15999.00  │
-- │ Alice Johnson │    2     │ shipped     │ Sony Headphones      │ Electronics │    1     │  15999.00  │  15999.00  │
-- │ Alice Johnson │    8     │ pending     │ Nike Running Shoes   │ Footwear    │    1     │   8999.00  │   8999.00  │
-- │ Bob Smith     │    3     │ delivered   │ Levi Jeans           │ Clothing    │    1     │   3999.00  │   3999.00  │
-- │ Bob Smith     │    3     │ delivered   │ Nike Running Shoes   │ Footwear    │    1     │   8999.00  │   8999.00  │
-- │ Charlie Brown │    4     │ confirmed   │ Python Book          │ Books       │    1     │   1299.00  │   1299.00  │
-- │ Charlie Brown │    4     │ confirmed   │ Samsung Galaxy S24   │ Electronics │    1     │  89999.00  │  89999.00  │
-- │ Diana Prince  │    5     │ pending     │ Backpack             │ Accessories │    1     │   2499.00  │   2499.00  │
-- │ Diana Prince  │    5     │ pending     │ Python Book          │ Books       │    1     │   1299.00  │   1299.00  │
-- │ Diana Prince  │    5     │ pending     │ Yoga Mat             │ Sports      │    1     │   1499.00  │   1499.00  │
-- │ Edward King   │    6     │ delivered   │ Nike Running Shoes   │ Footwear    │    1     │   8999.00  │   8999.00  │
-- │ Edward King   │    6     │ delivered   │ Python Book          │ Books       │    1     │   1299.00  │   1299.00  │
-- │ Fiona Green   │    7     │ cancelled   │ Levi Jeans           │ Clothing    │    1     │   3999.00  │   3999.00  │
-- └───────────────┴──────────┴─────────────┴──────────────────────┴─────────────┴──────────┴────────────┴────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. Which products are ordered most?
-- -------------------------------------------------------
SELECT
    p.name                    AS product_name,
    p.category,
    p.price                   AS current_price,
    COUNT(oi.id)              AS times_ordered,
    SUM(oi.quantity)          AS total_qty_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi
    ON p.id = oi.product_id
GROUP BY p.id, p.name, p.category, p.price
ORDER BY total_qty_sold DESC NULLS LAST;

-- =====================================================
-- Output:
-- ┌──────────────────────┬─────────────┬───────────────┬───────────────┬────────────────┬───────────────┐
-- │     product_name     │  category   │ current_price │ times_ordered │ total_qty_sold │ total_revenue │
-- ├──────────────────────┼─────────────┼───────────────┼───────────────┼────────────────┼───────────────┤
-- │ Nike Running Shoes   │ Footwear    │    8999.00    │       3       │       3        │   26997.00    │
-- │ Python Book          │ Books       │    1299.00    │       4       │       4        │    5196.00    │
-- │ Sony Headphones      │ Electronics │   15999.00    │       2       │       2        │   31998.00    │
-- │ Levi Jeans           │ Clothing    │    3999.00    │       2       │       2        │    7998.00    │
-- │ iPhone 15            │ Electronics │   99999.00    │       1       │       1        │   99999.00    │
-- │ Samsung Galaxy S24   │ Electronics │   89999.00    │       1       │       1        │   89999.00    │
-- │ Backpack             │ Accessories │    2499.00    │       1       │       1        │    2499.00    │
-- │ Yoga Mat             │ Sports      │    1499.00    │       1       │       1        │    1499.00    │
-- │ Coffee Maker         │ Appliances  │    5999.00    │       0       │      NULL      │     NULL      │
-- │ Sunglasses           │ Accessories │    3499.00    │       0       │      NULL      │     NULL      │
-- └──────────────────────┴─────────────┴───────────────┴───────────────┴────────────────┴───────────────┘
-- Coffee Maker and Sunglasses were never ordered
-- =====================================================