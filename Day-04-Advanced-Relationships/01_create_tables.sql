-- =====================================================
-- Topic: E-Store Project - Create All Tables
-- Description:
-- We are building a small online shopping store.
-- There are 4 tables in this project.
--
-- Relationships:
-- customers → orders       (One to Many)
--   One customer can place many orders
--   But each order belongs to only one customer
--
-- orders → order_items     (One to Many)
--   One order can have many items
--   But each item belongs to only one order
--
-- products → order_items   (One to Many)
--   One product can appear in many order items
--   But each order item refers to one product
--
-- orders ↔ products        (Many to Many)
--   One order can have many products
--   One product can be in many orders
--   order_items is the JUNCTION table between them
--
-- Visual Map:
--
-- customers ──────────────────────────────────────────┐
--     │                                               │
--     │ (1 customer → many orders)                    │
--     ▼                                               │
--   orders ──────────────────────────────────────────┐│
--     │                                              ││
--     │ (1 order → many order_items)                 ││
--     ▼                                              ││
--  order_items ◄──── products                        ││
--  (junction table)                                  ││
--     │         (1 product → many order_items)       ││
--     └──────────────────────────────────────────────┘│
--                                                     │
-- =====================================================


-- -------------------------------------------------------
-- Table 1: customers (Parent Table)
-- Stores all customer information
-- -------------------------------------------------------
CREATE TABLE customers (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) UNIQUE NOT NULL,
    phone      VARCHAR(15),
    city       VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- TIMESTAMP → stores date and time together
    -- CURRENT_TIMESTAMP → automatically saves sign up time
);


-- -------------------------------------------------------
-- Table 2: products (Parent Table)
-- Stores all product information with price
-- -------------------------------------------------------
CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    category    VARCHAR(50),
    price       NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    -- price must be greater than 0
    stock       INT DEFAULT 0 CHECK (stock >= 0),
    -- stock cannot go negative
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- -------------------------------------------------------
-- Table 3: orders (Child of customers, Parent of order_items)
-- Each order belongs to one customer
-- -------------------------------------------------------
CREATE TABLE orders (
    id           SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(20) DEFAULT 'pending'
                 CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
    -- status must be one of these 5 values only
    total_amount NUMERIC(10, 2) DEFAULT 0,

    -- Foreign Key: connects order to customer
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE CASCADE
        -- If customer is deleted → their orders are also deleted
);


-- -------------------------------------------------------
-- Table 4: order_items (Junction Table - Child of both orders and products)
-- This is the JUNCTION table for Many to Many
-- One row = one product inside one order
-- -------------------------------------------------------
CREATE TABLE order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INT NOT NULL,
    product_id  INT NOT NULL,
    quantity    INT NOT NULL CHECK (quantity > 0),
    -- quantity must be at least 1
    unit_price  NUMERIC(10, 2) NOT NULL,
    -- unit_price stores price AT THE TIME of purchase
    -- (product price may change later, this stays fixed)

    -- Foreign Key: connects item to its order
    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    -- Foreign Key: connects item to its product
    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE RESTRICT
        -- RESTRICT → Cannot delete a product if it
        -- has been ordered by someone
);

-- =====================================================
-- Output:
-- CREATE TABLE  ← customers
-- CREATE TABLE  ← products
-- CREATE TABLE  ← orders
-- CREATE TABLE  ← order_items
-- =====================================================