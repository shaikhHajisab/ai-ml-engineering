-- =============================================================================
-- SQL for Data Engineering — Day 06 & 07 Practice Exercises
-- Target: Citi Bank Data Engineering Coding Workshop
-- Instructions: Write your SQL queries below each problem statement.
-- DO NOT LOOK AT solutions.sql UNTIL YOU HAVE ATTEMPTED ALL QUESTIONS!
-- =============================================================================

-- Database Schema Provided:
-- customers(customer_id, first_name, last_name, email, phone, credit_score, city, join_date)
-- accounts(account_id, customer_id, account_type, balance, status, opened_date)
-- transactions(txn_id, account_id, txn_type, amount, fee, status, txn_timestamp)
-- loans(loan_id, customer_id, loan_type, principal_amount, interest_rate, status, issue_date)
-- fraud_alerts(alert_id, account_id, risk_score, status, alert_timestamp)

-- -----------------------------------------------------------------------------
-- EASY PROBLEMS (3)
-- -----------------------------------------------------------------------------

-- Problem 1 (Easy): String Formatting & NULL Handling
-- Task: Retrieve customer_id, full_name as "FIRSTNAME LASTNAME" in uppercase,
-- and contact_phone. If phone is NULL, display 'NOT AVAILABLE'.
-- Sort by customer_id ascending.

-- Write Query 1 Below:
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    COALESCE(phone, 'NOT AVAILABLE') AS contact_phone
FROM 
    customers
ORDER BY 
    customer_id;


-- Problem 2 (Easy): Simple Subquery
-- Task: Write a query to find all accounts whose balance is greater than the 
-- average balance of ALL accounts in the bank. Return account_id, customer_id, and balance.

-- Write Query 2 Below:
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


-- Problem 3 (Easy): Date Extraction
-- Task: Find all transactions that occurred in the year 2026 and month of July (Month 7).
-- Return txn_id, account_id, amount, and txn_timestamp.

-- Write Query 3 Below:
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


-- -----------------------------------------------------------------------------
-- MEDIUM PROBLEMS (3)
-- -----------------------------------------------------------------------------

-- Problem 4 (Medium): Correlated EXISTS
-- Task: Find all customers who have at least one account with a 'PENDING_REVIEW' fraud alert.
-- Do NOT use JOIN; use an EXISTS subquery.
-- Return customer_id, first_name, last_name, and email.

-- Write Query 4 Below:
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
        JOIN fraud_alerts fa ON a.account_id = fa.account_id
        WHERE a.customer_id = c.customer_id
          AND fa.status = 'PENDING_REVIEW'
    );


-- Problem 5 (Medium): CASE WHEN Conditional Aggregation (Pivoting)
-- Task: For each customer, write a single query that counts:
-- 1. Total total_transactions
-- 2. Total successful_transactions (where status = 'COMPLETED')
-- 3. Total failed_transactions (where status = 'FAILED' or 'REJECTED')
-- Return customer_id, total_transactions, successful_transactions, and failed_transactions.

-- Write Query 5 Below:
SELECT 
    customer_id,
    COUNT(txn_id) AS total_transactions,
    COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) AS successful_transactions,
    COUNT(CASE WHEN status = 'FAILED' OR status = 'REJECTED' THEN 1 END) AS failed_transactions
FROM 
    transactions
GROUP BY 
    customer_id;


-- Problem 6 (Medium): Safe Division & Percent Calculation
-- Task: Calculate the fee percentage for each transaction relative to its total amount: (fee / amount) * 100.
-- Protect against division by zero using NULLIF when amount is 0 or NULL.
-- Return txn_id, amount, fee, and fee_percentage rounded to 2 decimal places.

-- Write Query 6 Below:
SELECT 
    txn_id,
    amount,
    fee,
    ROUND((fee::NUMERIC / NULLIF(amount, 0)) * 100, 2) AS fee_percentage
FROM 
    transactions;


-- -----------------------------------------------------------------------------
-- HARD PROBLEMS (2)
-- -----------------------------------------------------------------------------

-- Problem 7 (Hard): Correlated Subquery + Windowing/Ranking Logic without Window Functions
-- Task: Write a correlated subquery to find the largest transaction (highest amount) 
-- for EACH account.
-- Return account_id, txn_id, amount, and txn_timestamp.
-- (Hint: Inner query matches outer query account_id and checks amount >= ALL or MAX).

-- Write Query 7 Below:
SELECT 
    a.account_id,
    a.txn_id,
    a.amount,
    a.txn_timestamp
FROM 
    transactions a
WHERE 
    a.amount = (
        SELECT MAX(b.amount) 
        FROM transactions b
        WHERE b.account_id = a.account_id
    );


-- Problem 8 (Hard): Advanced Fraud ETL — Subquery + Conditional Risk Classification
-- Task: Construct a query for Citi Fraud Compliance pipeline:
-- Find all customers whose total balance across all accounts exceeds $50,000, 
-- AND who have made at least one transaction over $10,000 in the last 30 days.
-- Display: customer_id, full_name, total_balance, max_single_txn_amount, and risk_category:
--   - 'HIGH RISK' if total_balance > 100000 AND max_single_txn_amount > 25000
--   - 'MEDIUM RISK' otherwise.
-- Filter out customers with missing email addresses using COALESCE or IS NOT NULL.

-- Write Query 8 Below:
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    (SELECT SUM(a.balance) FROM accounts a WHERE a.customer_id = c.customer_id) AS total_balance,
    (
        SELECT MAX(t.amount) 
        FROM transactions t
        JOIN accounts a ON t.account_id = a.account_id
        WHERE a.customer_id = c.customer_id
          AND t.txn_timestamp >= CURRENT_DATE - INTERVAL '30 days'
    ) AS max_single_txn_amount,
    CASE 
        WHEN (SELECT SUM(a.balance) FROM accounts a WHERE a.customer_id = c.customer_id) > 100000 
             AND (
                SELECT MAX(t.amount) 
                FROM transactions t
                JOIN accounts a ON t.account_id = a.account_id
                WHERE a.customer_id = c.customer_id
                  AND t.txn_timestamp >= CURRENT_DATE - INTERVAL '30 days'
             ) > 25000 
        THEN 'HIGH RISK'
        ELSE 'MEDIUM RISK'
    END AS risk_category
FROM 
    customers c
WHERE 
    c.email IS NOT NULL;
