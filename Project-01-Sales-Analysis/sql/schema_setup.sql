-- 1. Clean up existing table for a fresh start
DROP TABLE IF EXISTS sales_data;

-- 2. Create the table with optimized data types
CREATE TABLE sales_data (
    order_id      INT PRIMARY KEY,
    order_date    DATE NOT NULL,
    customer_id   INT NOT NULL,
    category      VARCHAR(100),
    sales_amount  DECIMAL(10, 2), -- More precise than FLOAT for currency
    quantity      INT,
    profit        DECIMAL(10, 2),
    profit_margin DECIMAL(5, 2)    -- Stored as a percentage (e.g., 15.50)
);

-- 3. Add Indexes to speed up common analysis queries
-- Indexing category because we frequently group by it
CREATE INDEX idx_category ON sales_data(category);

-- Indexing order_date for time-series/YoY analysis
CREATE INDEX idx_order_date ON sales_data(order_date);

-- 4. Commenting on table purpose (Good Documentation Practice)
COMMENT ON TABLE sales_data IS 'Cleaned e-commerce transaction records for Q1 2023 - Q4 2024 analysis.';