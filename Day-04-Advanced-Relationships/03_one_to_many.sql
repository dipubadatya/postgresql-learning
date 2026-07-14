-- =====================================================
-- Topic: One to Many Relationship
-- Description:
-- One customer can place MANY orders.
-- But each order belongs to only ONE customer.
--
-- customers (1) ──────► orders (Many)
--
-- customer_id in orders table is the FOREIGN KEY
-- that links back to id in customers table.
--
-- Alice (id=1) has 3 orders (id=1, 2, 8)
-- Bob   (id=2) has 1 order  (id=3)
-- Fiona (id=6) has 1 order  (id=7) - cancelled
-- =====================================================


-- -------------------------------------------------------
-- 1. Show every customer with their orders
--    LEFT JOIN → include customers with no orders too
-- -------------------------------------------------------
SELECT
    c.id              AS customer_id,
    c.name            AS customer_name,
    c.city,
    o.id              AS order_id,
    o.status          AS order_status,
    o.total_amount,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
ORDER BY c.id, o.id;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────────┬─────────────┬──────────┬───────────┬──────────────┬─────────────────────┐
-- │ customer_id │ customer_name │    city     │ order_id │  status   │ total_amount │      order_date      │
-- ├─────────────┼───────────────┼─────────────┼──────────┼───────────┼──────────────┼─────────────────────┤
-- │      1      │ Alice Johnson │ New York    │    1     │ delivered │  115998.00   │ 2024-01-15 09:00:00 │
-- │      1      │ Alice Johnson │ New York    │    2     │ shipped   │   15999.00   │ 2024-01-20 11:00:00 │
-- │      1      │ Alice Johnson │ New York    │    8     │ pending   │    8999.00   │ 2024-02-01 10:00:00 │
-- │      2      │ Bob Smith     │ Los Angeles │    3     │ delivered │   12998.00   │ 2024-01-18 14:00:00 │
-- │      3      │ Charlie Brown │ Chicago     │    4     │ confirmed │  101498.00   │ 2024-01-22 16:00:00 │
-- │      4      │ Diana Prince  │ Houston     │    5     │ pending   │    4798.00   │ 2024-01-25 10:00:00 │
-- │      5      │ Edward King   │ Phoenix     │    6     │ delivered │    7498.00   │ 2024-01-16 13:00:00 │
-- │      6      │ Fiona Green   │ New York    │    7     │ cancelled │    3999.00   │ 2024-01-28 09:00:00 │
-- └─────────────┴───────────────┴─────────────┴──────────┴───────────┴──────────────┴─────────────────────┘
-- Alice appears 3 times because she has 3 orders
-- =====================================================


-- -------------------------------------------------------
-- 2. How many orders does each customer have?
-- -------------------------------------------------------
SELECT
    c.name               AS customer_name,
    COUNT(o.id)          AS total_orders,
    SUM(o.total_amount)  AS total_spent
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY total_orders DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────────┬─────────────┐
-- │ customer_name │ total_orders │ total_spent │
-- ├───────────────┼──────────────┼─────────────┤
-- │ Alice Johnson │      3       │  140996.00  │
-- │ Bob Smith     │      1       │   12998.00  │
-- │ Charlie Brown │      1       │  101498.00  │
-- │ Diana Prince  │      1       │    4798.00  │
-- │ Edward King   │      1       │    7498.00  │
-- │ Fiona Green   │      1       │    3999.00  │
-- └───────────────┴──────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. Show only delivered orders with customer name
-- -------------------------------------------------------
SELECT
    c.name      AS customer_name,
    o.id        AS order_id,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id
WHERE o.status = 'delivered'
ORDER BY o.total_amount DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────┬───────────┬──────────────┐
-- │ customer_name │ order_id │  status   │ total_amount │
-- ├───────────────┼──────────┼───────────┼──────────────┤
-- │ Alice Johnson │    1     │ delivered │  115998.00   │
-- │ Charlie Brown │    4     │ delivered │  101498.00   │
-- │ Bob Smith     │    3     │ delivered │   12998.00   │
-- │ Edward King   │    6     │ delivered │    7498.00   │
-- └───────────────┴──────────┴───────────┴──────────────┘
-- =====================================================