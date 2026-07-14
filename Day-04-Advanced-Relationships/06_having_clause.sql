-- =====================================================
-- Topic: HAVING Clause (Deep Dive with E-Store)
-- Description:
-- HAVING filters groups AFTER GROUP BY.
-- WHERE filters rows BEFORE grouping.
--
-- Rule to remember:
-- Use WHERE  → to filter individual rows
-- Use HAVING → to filter grouped/aggregated results
--
-- Execution Order:
-- FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
-- =====================================================


-- -------------------------------------------------------
-- 1. Customers who placed MORE than 1 order
-- -------------------------------------------------------
SELECT
    c.name         AS customer_name,
    COUNT(o.id)    AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 1
ORDER BY total_orders DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────────┐
-- │ customer_name │ total_orders │
-- ├───────────────┼──────────────┤
-- │ Alice Johnson │      3       │
-- └───────────────┴──────────────┘
-- Only Alice has more than 1 order
-- =====================================================


-- -------------------------------------------------------
-- 2. Customers who spent MORE than 10000 total
-- -------------------------------------------------------
SELECT
    c.name              AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.total_amount) > 10000
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
-- 3. Categories where total revenue is above 20000
-- -------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.id)                    AS total_products,
    SUM(oi.quantity * oi.unit_price)        AS category_revenue
FROM products p
INNER JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category
HAVING SUM(oi.quantity * oi.unit_price) > 20000
ORDER BY category_revenue DESC;

-- =====================================================
-- Output:
-- ┌─────────────┬────────────────┬──────────────────┐
-- │  category   │ total_products │ category_revenue │
-- ├─────────────┼────────────────┼──────────────────┤
-- │ Electronics │       3        │    221996.00     │
-- │ Footwear    │       1        │     26997.00     │
-- └─────────────┴────────────────┴──────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. Products ordered MORE than 1 time
-- -------------------------------------------------------
SELECT
    p.name                    AS product_name,
    COUNT(oi.id)              AS times_ordered,
    SUM(oi.quantity)          AS total_quantity_sold
FROM products p
INNER JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
HAVING COUNT(oi.id) > 1
ORDER BY times_ordered DESC;

-- =====================================================
-- Output:
-- ┌──────────────────────┬───────────────┬─────────────────────┐
-- │     product_name     │ times_ordered │ total_quantity_sold │
-- ├──────────────────────┼───────────────┼─────────────────────┤
-- │ Python Book          │       4       │          4          │
-- │ Nike Running Shoes   │       3       │          3          │
-- │ Sony Headphones      │       2       │          2          │
-- │ Levi Jeans           │       2       │          2          │
-- └──────────────────────┴───────────────┴─────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. WHERE + GROUP BY + HAVING together
--    Only look at delivered orders
--    Then find customers who spent more than 5000
-- -------------------------------------------------------
SELECT
    c.name              AS customer_name,
    COUNT(o.id)         AS delivered_orders,
    SUM(o.total_amount) AS total_spent_on_delivered
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'delivered'          -- filter rows first
GROUP BY c.id, c.name                 -- then group
HAVING SUM(o.total_amount) > 5000     -- then filter groups
ORDER BY total_spent_on_delivered DESC;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────────────┬──────────────────────────┐
-- │ customer_name │ delivered_orders │ total_spent_on_delivered │
-- ├───────────────┼──────────────────┼──────────────────────────┤
-- │ Alice Johnson │        1         │        115998.00         │
-- │ Charlie Brown │        1         │        101498.00         │
-- │ Bob Smith     │        1         │         12998.00         │
-- │ Edward King   │        1         │          7498.00         │
-- └───────────────┴──────────────────┴──────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. Cities where customers spent more than 50000 total
-- -------------------------------------------------------
SELECT
    c.city,
    COUNT(DISTINCT c.id)        AS total_customers,
    SUM(o.total_amount)         AS city_total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 50000
ORDER BY city_total_spent DESC;

-- =====================================================
-- Output:
-- ┌──────────┬─────────────────┬──────────────────┐
-- │   city   │ total_customers │ city_total_spent │
-- ├──────────┼─────────────────┼──────────────────┤
-- │ New York │        2        │    144995.00     │
-- │ Chicago  │        1        │    101498.00     │
-- └──────────┴─────────────────┴──────────────────┘
-- =====================================================