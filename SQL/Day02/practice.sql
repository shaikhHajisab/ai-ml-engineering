-- ============================================================
-- 🏦 SQL Day 02 — PRACTICE FILE
-- Write YOUR answers here. I will review them.
-- ============================================================
-- TABLES AVAILABLE (from Day 01):
--   customers   → customer_id, first_name, last_name, email, city, date_of_birth, is_active
--   accounts    → account_id, customer_id, account_type, balance, opened_date
--   transactions→ transaction_id, account_id, transaction_type, amount, transaction_date, description
--   employees   → employee_id, first_name, last_name, department, salary, hire_date, branch_id
--   loans       → loan_id, customer_id, loan_type, principal_amount, interest_rate, loan_start_date, status
--   branches    → branch_id, branch_name, city, state, is_open
-- ============================================================
-- ⚠️ THINK BEFORE YOU WRITE:
--   1. Which TABLE has the data I need?
--   2. Which COLUMNS do I need?
--   3. What is the FILTER condition? (WHERE)
--   4. Does it need SORTING? (ORDER BY)
--   5. Does it need a ROW LIMIT? (LIMIT)
--   6. Are there DUPLICATES to remove? (DISTINCT)
-- ============================================================


-- ============================================================
-- 🟢 EASY QUESTIONS (3)
-- ============================================================

-- ── Easy 1 ───────────────────────────────────────────────────
-- Citi Risk Team asks:
-- "Show me all accounts where the balance is LESS THAN ₹10,000"
-- Return: account_id, account_type, balance
--
-- Think:
-- → Table: accounts
-- → Columns: account_id, account_type, balance
-- → Filter: balance < 10000

-- YOUR SQL HERE:
SELECT account_id, account_type, balance
FROM accounts
WHERE balance<10000;




-- ── Easy 2 ───────────────────────────────────────────────────
-- HR asks:
-- "List all employees from highest salary to lowest"
-- Return: first_name, last_name, department, salary

-- Think:
-- → Table: employees
-- → Columns: first_name, last_name, department, salary
-- → Sort: salary descending

-- YOUR SQL HERE:
SELECT first_name, last_name, department, salary
FROM employees
ORDER BY salary desc;





-- ── Easy 3 ───────────────────────────────────────────────────
-- Marketing asks:
-- "What unique cities do our customers come from?"
-- Return: only distinct city names, sorted A to Z

-- Think:
-- → Table: customers
-- → Distinct cities only
-- → Sort alphabetically

-- YOUR SQL HERE:
select  distinct city_name
from customer
order by city_name asc;





-- ============================================================
-- 🟡 MEDIUM QUESTIONS (3)
-- ============================================================

-- ── Medium 1 ─────────────────────────────────────────────────
-- Fraud Team asks:
-- "Show the 3 largest transactions ever made at Citi, most recent first"
-- Return: transaction_id, account_id, amount, transaction_date
--
-- Think:
-- → Table: transactions
-- → Sort: amount DESC first, then transaction_date DESC
-- → Limit: top 3 only

-- YOUR SQL HERE:

SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
ORDER BY amount DESC, transaction_date DESC
LIMIT 3;



-- ── Medium 2 ─────────────────────────────────────────────────
-- Compliance Team asks:
-- "Find all ACTIVE loans"
-- Return: loan_id, loan_type, principal_amount, interest_rate, status
-- Rename the columns as:
--   loan_id          → "Loan ID"
--   loan_type        → "Type"
--   principal_amount → "Principal (INR)"
--   interest_rate    → "Rate (%)"
--   status           → "Status"

-- Think:
-- → Table: loans
-- → Filter: status = 'ACTIVE'
-- → Aliases: rename columns

-- YOUR SQL HERE:
SELECT 
    loan_id          AS "Loan ID",
    loan_type        AS "Type",
    principal_amount AS "Principal (INR)",
    interest_rate    AS "Rate (%)",
    status           AS "Status"
FROM loans
WHERE status = 'ACTIVE';



-- ── Medium 3 ─────────────────────────────────────────────────
-- Data Engineering Team asks:
-- "Show me only Data Engineering employees, sorted by hire date (oldest first)"
-- Return: first_name, last_name, salary, hire_date

-- Think:
-- → Table: employees
-- → Filter: department = 'Data Engineering'
-- → Sort: hire_date ASC (oldest first)

-- YOUR SQL HERE:
SELECT first_name, last_name, salary, hire_date
FROM employees
WHERE department = 'Data Engineering'
ORDER BY hire_date ASC;




-- ============================================================
-- 🔴 HARD QUESTIONS (2)
-- ============================================================

-- ── Hard 1 ───────────────────────────────────────────────────
-- Citi Wealth Management Dashboard:
-- "Show me the TOP 3 highest-balance SAVINGS accounts.
--  Display customer_id, account_id, and balance.
--  Rename balance to 'Savings Balance'.
--  Only include accounts with balance above ₹50,000."
--
-- Think:
-- → Table: accounts
-- → Filter: account_type = 'Savings' AND balance > 50000
-- → Sort: balance DESC
-- → Limit: 3
-- → Alias: balance

-- YOUR SQL HERE:
SELECT 
    customer_id,
    account_id,
    balance AS "Savings Balance"
FROM accounts
WHERE account_type = 'Savings'
  AND balance > 50000
ORDER BY balance DESC
LIMIT 3;




-- ── Hard 2 ───────────────────────────────────────────────────
-- Citi Fraud Analytics:
-- "Find all DEBIT transactions.
--  Show transaction_id, amount (renamed 'Debit Amount'), and transaction_date (renamed 'When').
--  Sort by amount descending.
--  Return only the top 2."
--
-- BONUS CHALLENGE: Can you also filter to only show amounts > ₹5,000?
--
-- Think:
-- → Table: transactions
-- → Filter: transaction_type = 'DEBIT' (and amount > 5000 for bonus)
-- → Columns with aliases
-- → Sort + Limit

-- YOUR SQL HERE:
SELECT 
    transaction_id,
    amount           AS "Debit Amount",
    transaction_date AS "When"
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount > 5000
ORDER BY amount DESC
LIMIT 2;




-- ============================================================
-- ✅ WHEN DONE:
-- Paste your code back and I will review it.
-- I check: logic, syntax, style, performance, industry best practices.
-- ============================================================
