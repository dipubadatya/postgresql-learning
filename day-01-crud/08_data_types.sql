-- =====================================================
-- PostgreSQL Data Types
-- Description:
-- PostgreSQL provides different data types to store
-- numbers, text, dates, boolean values, and more.
-- =====================================================

CREATE TABLE data_types_demo (

    -- Numeric Types
    id SERIAL PRIMARY KEY,
    age INT,
    salary NUMERIC(10,2),

    -- Character Types
    name VARCHAR(100),
    description TEXT,

    -- Boolean Type
    is_active BOOLEAN,

    -- Date & Time Types
    birth_date DATE,
    created_at TIMESTAMP,

    -- UUID (Requires pgcrypto extension)
    -- user_id UUID,

    -- JSON
    profile JSONB

);