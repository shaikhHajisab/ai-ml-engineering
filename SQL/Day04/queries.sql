-- ============================================================
-- 🏦 SQL Day 04 — Aggregate Functions: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- Mentor: Senior Data Engineer @ Citi
-- Database: Citi Bank Banking System
-- ============================================================


-- ============================================================
-- SECTION 1: COUNT()
-- ============================================================

-- ── Query 1: COUNT(*) — count all rows ───────────────────────
-- How many customers does Citi have?
-- COUNT(*) counts every row, including NULLs

SELECT COUNT(*) AS total_customers
FROM customers;


-- ── Query 2: COUNT(column) — skips NULLs ─────────────────────
-- How many customers have provided their email?
-- COUNT(email) counts only NON-NULL email values

SELECT COUNT(email) AS customers_with_email
FROM customers;

-- Compare with COUNT(*):
SELECT COUNT(*)     AS total_customers,
       COUNT(email) AS with_email
FROM customers;
-- If numbers differ → some customers have NULL email


-- ── Query 3: COUNT(DISTINCT) — unique values ──────────────────
-- How many unique cities do our customers come from?

SELECT COUNT(DISTINCT city) AS unique_cities
FROM customers;


-- ── Query 4: COUNT with WHERE ─────────────────────────────────
-- How many ACTIVE customers does Citi have?

SELECT COUNT(*) AS active_customers
FROM customers
WHERE is_active = TRUE;


-- ── Query 5: COUNT with WHERE on transactions ─────────────────
-- How many DEBIT transactions were made?

SELECT COUNT(*) AS total_debits
FROM transactions
WHERE transaction_type = 'DEBIT';


-- ============================================================
-- SECTION 2: SUM()
-- ============================================================

-- ── Query 6: Simple SUM ───────────────────────────────────────
-- What is the total value of all transactions at Citi?

SELECT SUM(amount) AS total_transaction_value
FROM transactions;


-- ── Query 7: SUM with WHERE ───────────────────────────────────
-- What is the total DEBIT amount (money that left Citi accounts)?

SELECT SUM(amount) AS total_debited
FROM transactions
WHERE transaction_type = 'DEBIT';


-- ── Query 8: SUM of loan portfolio ───────────────────────────
-- What is Citi's total active loan book value?
-- (This is a real metric: "loan portfolio size")

SELECT SUM(principal_amount) AS total_loan_portfolio
FROM loans
WHERE status = 'ACTIVE';


-- ── Query 9: SUM of account balances ─────────────────────────
-- What is the total money held in ALL savings accounts?

SELECT SUM(balance) AS total_savings_held
FROM accounts
WHERE account_type = 'Savings';


-- ============================================================
-- SECTION 3: AVG()
-- ============================================================

-- ── Query 10: Simple AVG ──────────────────────────────────────
-- What is the average account balance at Citi?

SELECT AVG(balance) AS avg_balance
FROM accounts;


-- ── Query 11: AVG with WHERE ──────────────────────────────────
-- What is the average salary of Data Engineering employees?

SELECT AVG(salary) AS avg_de_salary
FROM employees
WHERE department = 'Data Engineering';


-- ── Query 12: AVG transaction amount ─────────────────────────
-- What is the average transaction amount?
-- Fraud team uses this as a "normal behaviour" baseline

SELECT AVG(amount) AS avg_transaction_amount
FROM transactions;


-- ── Query 13: AVG of loan interest rates ─────────────────────
-- What is the average interest rate Citi charges on active loans?

SELECT AVG(interest_rate) AS avg_interest_rate
FROM loans
WHERE status = 'ACTIVE';


-- ============================================================
-- SECTION 4: MIN() and MAX()
-- ============================================================

-- ── Query 14: MIN and MAX on balance ─────────────────────────
-- What is the lowest and highest account balance at Citi?

SELECT MIN(balance) AS min_balance,
       MAX(balance) AS max_balance
FROM accounts;


-- ── Query 15: MAX transaction (fraud check) ───────────────────
-- What is the largest single transaction ever made?

SELECT MAX(amount) AS largest_transaction
FROM transactions;


-- ── Query 16: MIN and MAX on dates ───────────────────────────
-- When was the first and most recent account opened at Citi?

SELECT MIN(opened_date) AS oldest_account,
       MAX(opened_date) AS newest_account
FROM accounts;


-- ── Query 17: MIN salary per department ──────────────────────
-- What is the minimum salary in each department?

SELECT MIN(salary) AS lowest_salary,
       MAX(salary) AS highest_salary
FROM employees;


-- ============================================================
-- SECTION 5: GROUP BY
-- ============================================================

-- ── Query 18: Basic GROUP BY ──────────────────────────────────
-- How many customers does Citi have in EACH city?
-- GROUP BY groups all rows with the same city together
-- COUNT(*) then counts per group

SELECT city,
       COUNT(*) AS customer_count
FROM customers
GROUP BY city          -- one group per unique city
ORDER BY customer_count DESC;


-- ── Query 19: GROUP BY with SUM ──────────────────────────────
-- Total transaction amount per account
-- This shows which account has the most activity

SELECT account_id,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
ORDER BY total_amount DESC;


-- ── Query 20: GROUP BY with AVG ──────────────────────────────
-- Average salary per department
-- Very common HR analytics query

SELECT department,
       COUNT(*)      AS employee_count,
       AVG(salary)   AS avg_salary,
       MIN(salary)   AS min_salary,
       MAX(salary)   AS max_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;


-- ── Query 21: GROUP BY with multiple aggregates ───────────────
-- Per transaction type: count and total amount
-- Citi uses this for daily reconciliation reports

SELECT transaction_type,
       COUNT(*)      AS num_transactions,
       SUM(amount)   AS total_amount,
       AVG(amount)   AS avg_amount,
       MAX(amount)   AS largest
FROM transactions
GROUP BY transaction_type;


-- ── Query 22: GROUP BY with WHERE ────────────────────────────
-- Only ACTIVE customers: how many per city?
-- WHERE filters rows BEFORE GROUP BY
-- So GROUP BY only sees active customers

SELECT city,
       COUNT(*) AS active_customers
FROM customers
WHERE is_active = TRUE          -- filters rows first!
GROUP BY city
ORDER BY active_customers DESC;


-- ── Query 23: GROUP BY on loan type ──────────────────────────
-- Summary of Citi's loan portfolio by type

SELECT loan_type,
       COUNT(*)               AS num_loans,
       SUM(principal_amount)  AS total_principal,
       AVG(interest_rate)     AS avg_rate
FROM loans
GROUP BY loan_type
ORDER BY total_principal DESC;


-- ── Query 24: GROUP BY on multiple columns ────────────────────
-- Transaction count by account AND transaction_type
-- Rows are grouped by the COMBINATION

SELECT account_id,
       transaction_type,
       COUNT(*)    AS num_transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id, transaction_type
ORDER BY account_id, transaction_type;


-- ============================================================
-- SECTION 6: HAVING
-- ============================================================

-- ── Query 25: Basic HAVING ────────────────────────────────────
-- Find accounts with total transaction amount ABOVE ₹50,000
-- HAVING filters AFTER GROUP BY — WHERE cannot do this!

SELECT account_id,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
HAVING SUM(amount) > 50000     -- ← filters groups, not rows!
ORDER BY total_amount DESC;


-- ── Query 26: HAVING with COUNT ──────────────────────────────
-- Find cities with MORE THAN 1 customer
-- (useful to find well-served vs under-served regions)

SELECT city,
       COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;


-- ── Query 27: WHERE + GROUP BY + HAVING ──────────────────────
-- *** THE FULL PATTERN — Most common in Citi interviews! ***
-- Among ACTIVE loans, find loan types with avg interest rate above 8%

SELECT loan_type,
       COUNT(*)           AS loan_count,
       AVG(interest_rate) AS avg_rate
FROM loans
WHERE status = 'ACTIVE'         -- 1. filter rows (before grouping)
GROUP BY loan_type              -- 2. group filtered rows
HAVING AVG(interest_rate) > 8  -- 3. filter groups (after aggregating)
ORDER BY avg_rate DESC;         -- 4. sort the result


-- ── Query 28: Fraud Detection — high-activity accounts ───────
-- Find accounts with MORE THAN 1 transaction AND total > ₹20,000
-- Both HAVING conditions must be true

SELECT account_id,
       COUNT(*)    AS transaction_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
HAVING COUNT(*) > 1
   AND SUM(amount) > 20000
ORDER BY total_amount DESC;


-- ── Query 29: HAVING with AVG ────────────────────────────────
-- Find departments where the average salary exceeds ₹85,000
-- Only return departments with at least 1 employee

SELECT department,
       COUNT(*)    AS headcount,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 85000
ORDER BY avg_salary DESC;


-- ============================================================
-- 🧠 MENTOR NOTES — Common Mistakes
-- ============================================================
--
-- MISTAKE 1: Using aggregate in WHERE
-- ❌ WHERE SUM(amount) > 50000     → ERROR!
-- ✅ HAVING SUM(amount) > 50000    → CORRECT
--
-- MISTAKE 2: Non-aggregate column not in GROUP BY
-- ❌ SELECT city, first_name, COUNT(*) FROM customers GROUP BY city;
--    → first_name not in GROUP BY → ERROR!
-- ✅ SELECT city, COUNT(*) FROM customers GROUP BY city;
--
-- MISTAKE 3: COUNT(col) vs COUNT(*)
-- COUNT(*) = 5 (all rows)
-- COUNT(email) = 4 (skips 1 NULL)
--
-- MISTAKE 4: AVG with NULLs
-- If salary has NULLs, AVG only averages non-NULL values
-- This can make AVG look higher than reality
-- Fix: use COALESCE(salary, 0) to treat NULLs as 0
--      but only when 0 is semantically correct!
--
-- ============================================================
