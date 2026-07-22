-- =============================================================================
-- SQL for Data Engineering — Day 06 & 07 Working Examples
-- Mentor: Senior Data Engineer @ Citi Bank
-- Topic: Subqueries, Correlated Subqueries, EXISTS, CASE WHEN, Built-in Functions
-- =============================================================================

-- Setup Banking Schema & Dummy Data for Execution
CREATE TABLE IF NOT EXISTS banking_customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS banking_accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20),
    balance NUMERIC(15, 2),
    credit_limit NUMERIC(15, 2)
);

CREATE TABLE IF NOT EXISTS banking_transactions (
    txn_id VARCHAR(30) PRIMARY KEY,
    account_id VARCHAR(20),
    txn_type VARCHAR(20),
    amount NUMERIC(15, 2),
    txn_timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fraud_watchlist (
    watchlist_id INT PRIMARY KEY,
    account_id VARCHAR(20),
    risk_level VARCHAR(20),
    flagged_date DATE
);

-- Insert Sample Data
INSERT INTO banking_customers VALUES 
(1, 'Sarah', 'Conor', 'sarah.conor@citigroup.com', '555-0101', '2023-01-15 08:30:00'),
(2, 'Michael', 'Ross', NULL, '555-0102', '2023-03-22 10:15:00'),
(3, 'Rachel', 'Zane', 'rachel.z@citigroup.com', NULL, '2024-05-10 14:00:00'),
(4, 'Harvey', 'Specter', 'harvey.s@citigroup.com', '555-0104', '2022-11-01 09:00:00')
ON CONFLICT DO NOTHING;

INSERT INTO banking_accounts VALUES 
('ACC-1001', 1, 'CHECKING', 12500.50, 1000.00),
('ACC-1002', 1, 'SAVINGS', 45000.00, 0.00),
('ACC-1003', 2, 'CHECKING', -250.00, 500.00),
('ACC-1004', 3, 'CREDIT', 1500.00, 10000.00),
('ACC-1005', 4, 'CHECKING', 250000.00, 5000.00)
ON CONFLICT DO NOTHING;

INSERT INTO banking_transactions VALUES 
('TXN-8801', 'ACC-1001', 'DEPOSIT', 5000.00, '2026-07-01 09:00:00'),
('TXN-8802', 'ACC-1001', 'WITHDRAWAL', 12000.00, '2026-07-02 11:30:00'),
('TXN-8803', 'ACC-1003', 'WITHDRAWAL', 800.00, '2026-07-05 14:20:00'),
('TXN-8804', 'ACC-1005', 'WIRE_OUT', 95000.00, '2026-07-10 16:45:00')
ON CONFLICT DO NOTHING;

INSERT INTO banking_watchlist VALUES 
(1, 'ACC-1003', 'HIGH', '2026-07-06')
ON CONFLICT DO NOTHING;


-- -----------------------------------------------------------------------------
-- Query 1: Uncorrelated Scalar Subquery
-- Business Goal: Find accounts with balance higher than average balance of all accounts.
-- -----------------------------------------------------------------------------
SELECT 
    account_id,
    customer_id,
    balance
FROM 
    banking_accounts
WHERE 
    balance > (
        SELECT AVG(balance) 
        FROM banking_accounts
    );


-- -----------------------------------------------------------------------------
-- Query 2: Correlated Subquery with EXISTS
-- Business Goal: Identify customers who have accounts flagged on high-risk watchlist.
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM 
    banking_customers c
WHERE 
    EXISTS (
        SELECT 1 
        FROM banking_accounts a
        JOIN fraud_watchlist f ON a.account_id = f.account_id
        WHERE a.customer_id = c.customer_id
          AND f.risk_level = 'HIGH'
    );


-- -----------------------------------------------------------------------------
-- Query 3: Advanced CASE WHEN with Conditional Aggregation (Pivoting)
-- Business Goal: Pivot account types to count CHECKING vs SAVINGS per customer.
-- -----------------------------------------------------------------------------
SELECT 
    customer_id,
    COUNT(CASE WHEN account_type = 'CHECKING' THEN 1 END) AS checking_count,
    COUNT(CASE WHEN account_type = 'SAVINGS' THEN 1 END) AS savings_count,
    SUM(COALESCE(balance, 0)) AS total_combined_balance
FROM 
    banking_accounts
GROUP BY 
    customer_id;


-- -----------------------------------------------------------------------------
-- Query 4: Safe Division using NULLIF & String / Date Transformations
-- Business Goal: Format customer names, handle missing emails, and extract join year.
-- -----------------------------------------------------------------------------
SELECT 
    customer_id,
    CONCAT(UPPER(last_name), ', ', first_name) AS full_name_uppercase,
    COALESCE(email, 'no_email_provided@citi.com') AS clean_email,
    EXTRACT(YEAR FROM created_at) AS customer_join_year
FROM 
    banking_customers;
