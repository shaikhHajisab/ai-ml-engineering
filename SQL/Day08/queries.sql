-- =============================================================================
-- SQL for Data Engineering — Day 08 Working Examples
-- Mentor: Senior Data Engineer @ Citi Bank
-- Topic: Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, FIRST_VALUE, NTILE)
-- =============================================================================

-- Setup Banking Schema & Dummy Data
CREATE TABLE IF NOT EXISTS branch_accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    branch_id VARCHAR(10),
    customer_name VARCHAR(50),
    balance NUMERIC(15, 2)
);

CREATE TABLE IF NOT EXISTS account_activity (
    activity_id INT PRIMARY KEY,
    account_id VARCHAR(20),
    amount NUMERIC(15, 2),
    activity_time TIMESTAMP
);

-- Populate Sample Data
INSERT INTO branch_accounts VALUES
('ACC-101', 'BR-NY-01', 'Alice', 150000.00),
('ACC-102', 'BR-NY-01', 'Bob', 150000.00),
('ACC-103', 'BR-NY-01', 'Charlie', 95000.00),
('ACC-104', 'BR-LON-02', 'David', 300000.00),
('ACC-105', 'BR-LON-02', 'Eva', 250000.00)
ON CONFLICT DO NOTHING;

INSERT INTO account_activity VALUES
(1, 'ACC-101', 5000.00, '2026-07-01 09:00:00'),
(2, 'ACC-101', -1200.00, '2026-07-01 14:30:00'),
(3, 'ACC-101', 2500.00, '2026-07-02 10:15:00'),
(4, 'ACC-104', 50000.00, '2026-07-01 11:00:00'),
(5, 'ACC-104', -10000.00, '2026-07-03 16:00:00')
ON CONFLICT DO NOTHING;


-- -----------------------------------------------------------------------------
-- Query 1: Comparing ROW_NUMBER(), RANK(), and DENSE_RANK()
-- Business Goal: Rank account balances per branch to handle ties in balances.
-- -----------------------------------------------------------------------------
SELECT 
    branch_id,
    account_id,
    customer_name,
    balance,
    ROW_NUMBER() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS row_num,
    RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS dense_rnk
FROM 
    branch_accounts;


-- -----------------------------------------------------------------------------
-- Query 2: Lead & Lag for Fraud Velocity Detection
-- Business Goal: Calculate time gap and amount change between consecutive transactions.
-- -----------------------------------------------------------------------------
SELECT 
    account_id,
    activity_id,
    amount,
    activity_time,
    LAG(amount, 1) OVER (PARTITION BY account_id ORDER BY activity_time ASC) AS prev_amount,
    LAG(activity_time, 1) OVER (PARTITION BY account_id ORDER BY activity_time ASC) AS prev_time,
    LEAD(activity_time, 1) OVER (PARTITION BY account_id ORDER BY activity_time ASC) AS next_time
FROM 
    account_activity;


-- -----------------------------------------------------------------------------
-- Query 3: Cumulative Running Total & Moving Average
-- Business Goal: Track real-time account balance progression across transaction events.
-- -----------------------------------------------------------------------------
SELECT 
    account_id,
    activity_id,
    amount,
    activity_time,
    SUM(amount) OVER (
        PARTITION BY account_id 
        ORDER BY activity_time ASC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance,
    AVG(amount) OVER (
        PARTITION BY account_id 
        ORDER BY activity_time ASC 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS 3_event_moving_avg
FROM 
    account_activity;


-- -----------------------------------------------------------------------------
-- Query 4: NTILE for Risk Bucket Segmentation
-- Business Goal: Divide accounts into 4 quartiles based on balance size.
-- -----------------------------------------------------------------------------
SELECT 
    account_id,
    customer_name,
    balance,
    NTILE(4) OVER (ORDER BY balance DESC) AS balance_quartile
FROM 
    branch_accounts;
