-- =============================================================================
-- SQL for Data Engineering — Day 06 & 07 Practice Solutions
-- Target: Citi Bank Data Engineering Coding Workshop
-- NOTE: ONLY REVIEW THESE SOLUTIONS AFTER ATTEMPTING practice.sql!
-- =============================================================================

-- Problem 1 (Easy) Solution:
SELECT 
    customer_id,
    UPPER(CONCAT(first_name, ' ', last_name)) AS full_name,
    COALESCE(phone, 'NOT AVAILABLE') AS contact_phone
FROM 
    customers
ORDER BY 
    customer_id ASC;

-- Problem 2 (Easy) Solution:
SELECT 
    account_id,
    customer_id,
    balance
FROM 
    accounts
WHERE 
    balance > (
        SELECT AVG(balance) 
        FROM accounts
    );

-- Problem 3 (Easy) Solution:
SELECT 
    txn_id,
    account_id,
    amount,
    txn_timestamp
FROM 
    transactions
WHERE 
    EXTRACT(YEAR FROM txn_timestamp) = 2026
    AND EXTRACT(MONTH FROM txn_timestamp) = 7;

-- Problem 4 (Medium) Solution:
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM 
    customers c
WHERE 
    EXISTS (
        SELECT 1 
        FROM accounts a
        JOIN fraud_alerts f ON a.account_id = f.account_id
        WHERE a.customer_id = c.customer_id
          AND f.status = 'PENDING_REVIEW'
    );

-- Problem 5 (Medium) Solution:
SELECT 
    a.customer_id,
    COUNT(t.txn_id) AS total_transactions,
    COUNT(CASE WHEN t.status = 'COMPLETED' THEN 1 END) AS successful_transactions,
    COUNT(CASE WHEN t.status IN ('FAILED', 'REJECTED') THEN 1 END) AS failed_transactions
FROM 
    accounts a
JOIN 
    transactions t ON a.account_id = t.account_id
GROUP BY 
    a.customer_id;

-- Problem 6 (Medium) Solution:
SELECT 
    txn_id,
    amount,
    fee,
    ROUND((fee / NULLIF(amount, 0)) * 100, 2) AS fee_percentage
FROM 
    transactions;

-- Problem 7 (Hard) Solution:
SELECT 
    t1.account_id,
    t1.txn_id,
    t1.amount,
    t1.txn_timestamp
FROM 
    transactions t1
WHERE 
    t1.amount = (
        SELECT MAX(t2.amount)
        FROM transactions t2
        WHERE t2.account_id = t1.account_id
    );

-- Problem 8 (Hard) Solution:
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(a.balance) AS total_balance,
    MAX(t.amount) AS max_single_txn_amount,
    CASE 
        WHEN SUM(a.balance) > 100000 AND MAX(t.amount) > 25000 THEN 'HIGH RISK'
        ELSE 'MEDIUM RISK'
    END AS risk_category
FROM 
    customers c
JOIN 
    accounts a ON c.customer_id = a.customer_id
JOIN 
    transactions t ON a.account_id = t.account_id
WHERE 
    c.email IS NOT NULL
    AND t.txn_timestamp >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    SUM(a.balance) > 50000
    AND MAX(t.amount) > 10000;
