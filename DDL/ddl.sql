-- ============================================================================
-- PostgreSQL DDL: SHORT NOTES + REAL E-COMMERCE DATABASE
-- Level: Beginner -> Intermediate | Learn by reading comments + running code
-- ============================================================================
-- DATABASE holds schemas; SCHEMA groups tables; TABLE holds rows and columns.
-- DDL = Data Definition Language: defines/changes database STRUCTURE.
-- Optional: CREATE DATABASE shop_db; -- Run separately, outside a transaction.
-- Main commands: CREATE (make), ALTER (change), DROP (remove).
-- DML = Data Manipulation Language: INSERT, UPDATE, DELETE data (rows).
-- SQL comments: -- one line | /* multiple lines */
-- Run in PostgreSQL (for example, with psql -f ddl.sql).
-- IMPORTANT: This file RESETS ONLY the "ddl_notes_demo" schema each time.
-- Never copy the DROP SCHEMA line into a real/production database blindly.

BEGIN;  -- All schema changes succeed together, or roll back together on error.
DROP SCHEMA IF EXISTS ddl_notes_demo CASCADE;
CREATE SCHEMA ddl_notes_demo;
SET LOCAL search_path TO ddl_notes_demo, public; -- Work inside our demo schema.

-- ============================================================================
-- 1) USEFUL POSTGRESQL DATA TYPES: choose the type that matches your data.
-- ============================================================================
-- SMALLINT / INTEGER / BIGINT  -> whole numbers; BIGINT holds larger IDs.
-- TEXT                        -> flexible text (common PostgreSQL choice).
-- VARCHAR(100)                -> text with a 100-character length limit.
-- NUMERIC(12,2)               -> exact decimal: 12 total digits, 2 after dot.
--                                Prefer NUMERIC for prices/money calculations.
-- REAL / DOUBLE PRECISION     -> approximate decimals; NOT ideal for money.
-- BOOLEAN                     -> TRUE / FALSE.
-- DATE                        -> date only (e.g., 2026-10-23).
-- TIME                        -> clock time only (e.g., 14:30:00).
-- TIMESTAMP                   -> date + time, without time zone handling.
-- TIMESTAMPTZ                 -> time-zone-aware instant; great for events.
-- UUID                        -> globally unique identifier (alternative ID).
-- JSONB                       -> flexible JSON data, stored for efficient queries.
--                                Use normal columns/tables for core relationships.
-- NULL = missing/unknown, NOT an empty string ('') or the number 0.

-- ============================================================================
-- 2) CONSTRAINTS: rules the DATABASE enforces, even if app code has a bug.
-- ============================================================================
-- PRIMARY KEY : uniquely identifies each row AND cannot be NULL.
--               One primary-key constraint per table; can contain 2+ columns.
-- UNIQUE      : prevents repeated values; by default, multiple NULLs allowed.
-- NOT NULL    : value is required (but '' is still a valid empty text value).
-- FOREIGN KEY : child value must match a parent PRIMARY KEY/UNIQUE value.
-- CHECK       : each row must satisfy a condition, e.g., price > 0.
--               IMPORTANT: CHECK does NOT reject NULL by itself; add NOT NULL.
-- DEFAULT     : value used if a column is omitted (or DEFAULT is requested).
--               Explicit NULL is NOT replaced by DEFAULT.
-- GENERATED ALWAYS AS IDENTITY: PostgreSQL generates number IDs automatically.
--               Preferred modern approach instead of older SERIAL syntax.
-- Named constraints make database error messages easier to understand.

-- ============================================================================
-- 3) E-COMMERCE RELATIONSHIPS (1:N means "one to many")
-- ============================================================================
-- categories  1:N products
-- customers   1:N orders
-- orders      1:N order_items N:1 products
-- orders      1:N payments
-- Create the parent table BEFORE tables that reference it.

-- A) CATEGORIES: one category can contain many products.
CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    created_on  DATE NOT NULL DEFAULT CURRENT_DATE
);

-- B) CUSTOMERS: email must be present and unique.
CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name   TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT customers_name_not_blank CHECK (BTRIM(full_name) <> '')
);
-- Note: ordinary TEXT UNIQUE can treat 'A@x.com' and 'a@x.com' as different.
-- For case-insensitive uniqueness, consider a UNIQUE index on LOWER(email).

-- C) PRODUCTS: category_id links a product to an existing category.
CREATE TABLE products (
    product_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id    BIGINT NOT NULL,
    sku            TEXT NOT NULL UNIQUE,       -- Stock Keeping Unit / product code.
    name           TEXT NOT NULL,
    price          NUMERIC(12,2) NOT NULL,
    discount_price NUMERIC(12,2),             -- Optional: can be NULL.
    stock          INTEGER NOT NULL DEFAULT 0,
    attributes     JSONB NOT NULL DEFAULT '{}'::JSONB,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT,                    -- Cannot delete used category.
    CONSTRAINT products_name_not_blank CHECK (BTRIM(name) <> ''),
    CONSTRAINT products_price_positive CHECK (price > 0),
    CONSTRAINT products_stock_nonnegative CHECK (stock >= 0),
    CONSTRAINT products_valid_discount
        CHECK (discount_price BETWEEN 0 AND price),
    CONSTRAINT products_attributes_object
        CHECK (JSONB_TYPEOF(attributes) = 'object')
);
-- Example valid attributes JSON: '{"color":"blue","size":"M"}'::JSONB
-- discount_price can be NULL: CHECK allows unknown; NOT NULL would forbid it.

-- D) ORDERS: each order belongs to one existing customer.
CREATE TABLE orders (
    order_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id      BIGINT NOT NULL,
    shipping_address TEXT NOT NULL,
    status           TEXT NOT NULL DEFAULT 'pending',
    ordered_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT,
    CONSTRAINT orders_allowed_status
        CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'))
);
-- Avoid storing a second copy of an order total unless you maintain it safely.
-- It can be calculated from order_items: SUM(quantity * unit_price).

-- E) ORDER_ITEMS: the bridge between orders and products.
-- An order has many products; a product can appear in many orders (many-to-many).
CREATE TABLE order_items (
    order_id   BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),

    CONSTRAINT order_items_pk PRIMARY KEY (order_id, product_id),
    -- Composite PK: the SAME product appears at most once per order.
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT
);
-- Store unit_price AT PURCHASE TIME; product prices can change later.
-- CASCADE above: deleting an order automatically deletes its order_items.
-- Deleting one order_item NEVER deletes its parent order.

-- F) PAYMENTS: payments belong to orders; preserve financial history.
CREATE TABLE payments (
    payment_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id        BIGINT NOT NULL,
    amount          NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    method          TEXT NOT NULL CHECK (method IN ('card', 'upi', 'bank', 'cash')),
    status          TEXT NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'success', 'failed', 'refunded')),
    transaction_ref TEXT UNIQUE,               -- Optional; many NULLs allowed.
    paid_at         TIMESTAMPTZ,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE RESTRICT
);
-- With payments present, deleting the parent order is BLOCKED (RESTRICT).
-- For real systems, financial records often need retention/audit policies.

-- ============================================================================
-- 4) REFERENTIAL INTEGRITY: what happens when a PARENT row is deleted?
-- ============================================================================
-- ON DELETE CASCADE  -> automatically delete related CHILD rows.
-- ON DELETE RESTRICT -> block parent deletion while child rows still exist.
-- ON DELETE SET NULL -> set child FK to NULL (FK column must allow NULL).
-- ON DELETE NO ACTION -> default; checks FK validity (can be deferred if set up).
-- Choose deliberately: order_items CASCADE; payments RESTRICT in this example.
-- IMPORTANT: These rules apply to DELETE of rows, NOT DROP TABLE.
-- DELETE FROM orders WHERE order_id = 1;  -- Example only; not executed.

-- ============================================================================
-- 5) INDEXES: help frequent joins/lookups, but take space and slow writes.
-- ============================================================================
-- PRIMARY KEY / UNIQUE already create supporting unique indexes.
-- PostgreSQL does NOT automatically index the CHILD side of FOREIGN KEY.
CREATE INDEX idx_products_category_id   ON products(category_id);
CREATE INDEX idx_orders_customer_id     ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_order_id      ON payments(order_id);
-- Add this only when you often search inside JSONB attributes:
-- CREATE INDEX idx_products_attributes ON products USING GIN(attributes);

-- ============================================================================
-- 6) ALTER TABLE: change an EXISTING table (schema evolution).
-- Practice on a separate table, so the e-commerce model stays unchanged.
-- ============================================================================
CREATE TABLE schema_change_practice (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    old_name    TEXT NOT NULL,
    legacy_code TEXT
);

ALTER TABLE schema_change_practice ADD COLUMN notes TEXT;                -- Add.
ALTER TABLE schema_change_practice RENAME COLUMN old_name TO name;       -- Rename.
ALTER TABLE schema_change_practice ALTER COLUMN name TYPE VARCHAR(100);  -- Change type.
ALTER TABLE schema_change_practice ALTER COLUMN notes SET DEFAULT 'N/A'; -- Set default.
ALTER TABLE schema_change_practice
    ADD CONSTRAINT practice_name_not_blank CHECK (BTRIM(name) <> '');    -- Add rule.
ALTER TABLE schema_change_practice DROP COLUMN legacy_code;              -- Delete column + its data.
-- Other useful patterns (not executed):
-- ALTER TABLE products ADD COLUMN description TEXT;
-- ALTER TABLE products DROP CONSTRAINT products_price_positive;
-- ALTER TABLE products ALTER COLUMN stock SET NOT NULL;
-- DROP TABLE schema_change_practice;   -- Deletes entire practice table + data.
-- TRUNCATE TABLE schema_change_practice; -- Deletes rows; keeps table structure.
-- On an existing table, new constraints/type changes may fail if OLD rows violate them.
-- Large ALTER TABLE operations may lock the table: plan migrations carefully.

-- ============================================================================
-- 7) COMMON MISTAKES + QUICK REMINDERS
-- ============================================================================
-- 1. NOT NULL stops missing values, not blanks (''); use CHECK for blanks.
-- 2. UNIQUE is not the same as PRIMARY KEY: PK also forbids NULL.
-- 3. Foreign keys prevent orphan rows (e.g., item linked to missing order).
-- 4. CASCADE can erase related data: never enable it without thinking.
-- 5. Use NUMERIC for prices; TIMESTAMPTZ for recorded event times.
-- 6. Avoid using JSONB to replace normal product/order relationships.
-- 7. Index frequently joined FKs; avoid unnecessary indexes.
-- 8. DDL changes structure; INSERT/UPDATE/DELETE change rows.

COMMIT;
-- Done! Tables are inside the ddl_notes_demo schema.
-- To inspect: SELECT * FROM ddl_notes_demo.products;  -- Empty until INSERTs.
-- Practice: try inserting a negative price, duplicate SKU, or invalid category_id.
-- PostgreSQL should reject each invalid row because constraints protect the data.
-- Official reference: https://www.postgresql.org/docs/current/ddl.html

-- ------------------------------------------------------------------------------------------------------------------------


-- ==========================================
-- STEP 1: CREATE DATABASE
-- ==========================================

CREATE DATABASE school_db;

-- IMPORTANT:
-- Connect to school_db in SQLTools before
-- running the remaining commands.


-- ==========================================
-- STEP 2: CREATE TABLE
-- ==========================================

CREATE TABLE students (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(150) UNIQUE
);


-- ==========================================
-- STEP 3: INSERT DATA
-- ==========================================

INSERT INTO students (name, age, email)
VALUES
    ('Rahul', 21, 'rahul@gmail.com'),
    ('Priya', 22, 'priya@gmail.com'),
    ('Aman', 20, 'aman@gmail.com');


-- ==========================================
-- STEP 4: SHOW ALL DATA
-- ==========================================

SELECT * FROM students;


-- ==========================================
-- STEP 5: SHOW TABLE STRUCTURE
-- ==========================================

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'students'
  AND table_schema = 'public';