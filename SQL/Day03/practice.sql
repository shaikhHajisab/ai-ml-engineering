-- ============================================================
-- 🏦 SQL Day 03 — PRACTICE FILE
-- Topic: AND/OR/NOT, IN, BETWEEN, LIKE, IS NULL
-- Write YOUR answers here. I will review them.
-- ============================================================
-- TABLES:
--   customers   → customer_id, first_name, last_name, email, city, date_of_birth, is_active
--   accounts    → account_id, customer_id, account_type, balance, opened_date
--   transactions→ transaction_id, account_id, transaction_type, amount, transaction_date, description
--   employees   → employee_id, first_name, last_name, department, salary, hire_date, branch_id
--   loans       → loan_id, customer_id, loan_type, principal_amount, interest_rate, loan_start_date, loan_end_date, status
--   branches    → branch_id, branch_name, city, state, is_open
-- ============================================================
-- ⚠️ RULES:
--   1. SQL keywords in UPPERCASE
--   2. Spaces around operators: balance < 10000 (not balance<10000)
--   3. FROM on its own line
--   4. Each AND/OR condition on its own line
--   5. Use parentheses when mixing AND + OR
-- ============================================================


-- ============================================================
-- 🟢 EASY QUESTIONS (3)
-- ============================================================

-- ── Easy 1 ───────────────────────────────────────────────────
-- Citi Compliance asks:
-- "Find all loans of type 'Home' or 'Auto'"
-- Return: loan_id, loan_type, principal_amount, status
--
-- Think:
-- → Table: loans
-- → Which operator? You have a list of values → use IN
-- → Columns: loan_id, loan_type, principal_amount, status

-- YOUR SQL HERE:




-- ── Easy 2 ───────────────────────────────────────────────────
-- Data Quality Team asks:
-- "Which customers have NOT provided their email address?"
-- Return: customer_id, first_name, last_name
--
-- Think:
-- → Table: customers
-- → NULL check: email is missing
-- → Which clause? IS NULL

-- YOUR SQL HERE:




-- ── Easy 3 ───────────────────────────────────────────────────
-- HR asks:
-- "Find all employees with a salary between ₹80,000 and ₹1,00,000"
-- Return: first_name, last_name, salary
-- Sort: salary descending
--
-- Think:
-- → Table: employees
-- → Range filter → BETWEEN

-- YOUR SQL HERE:




-- ============================================================
-- 🟡 MEDIUM QUESTIONS (3)
-- ============================================================

-- ── Medium 1 ─────────────────────────────────────────────────
-- Fraud Team asks:
-- "Find all CREDIT transactions between ₹10,000 and ₹1,00,000
--  from January 2024 only"
-- Return: transaction_id, account_id, amount, transaction_date
-- Sort: amount descending
--
-- Think:
-- → Table: transactions
-- → Filter: CREDIT type AND amount BETWEEN AND date BETWEEN
-- → Three AND conditions

-- YOUR SQL HERE:




-- ── Medium 2 ─────────────────────────────────────────────────
-- Marketing asks:
-- "Find all active customers whose first name starts with 'A' or 'R'"
-- Return: customer_id, first_name, last_name, city
--
-- Think:
-- → Table: customers
-- → Pattern match on first_name → LIKE
-- → is_active = TRUE
-- → Combine with AND + (OR with parentheses!)

-- YOUR SQL HERE:




-- ── Medium 3 ─────────────────────────────────────────────────
-- Risk Team asks:
-- "Find all accounts that are NOT of type 'Savings'
--  AND have a balance above ₹50,000"
-- Return: account_id, account_type, balance
-- Sort: balance descending
--
-- Think:
-- → Table: accounts
-- → NOT IN (or <>) for account_type
-- → AND for balance filter

-- YOUR SQL HERE:




-- ============================================================
-- 🔴 HARD QUESTIONS (2)
-- ============================================================

-- ── Hard 1 ───────────────────────────────────────────────────
-- Citi KYC Compliance Report:
-- "Find all ACTIVE customers from Mumbai, Delhi, or Bangalore
--  who DO NOT have an email on file
--  AND whose date_of_birth is between 1985-01-01 and 1995-12-31"
-- Return: customer_id, first_name, last_name, city, date_of_birth
-- Sort: city ASC, last_name ASC
--
-- Think:
-- → Table: customers
-- → city IN (...)
-- → email IS NULL
-- → date_of_birth BETWEEN
-- → is_active = TRUE
-- → All combined with AND

-- YOUR SQL HERE:




-- ── Hard 2 ───────────────────────────────────────────────────
-- Citi Data Engineering — ETL Audit Query:
-- "Find all transactions where:
--   - transaction_type is DEBIT or CREDIT (use IN)
--   - amount is between ₹5,000 and ₹2,00,000
--   - description contains the word 'Transfer' OR description is NULL
--     (these are the ones to investigate)
--   - transaction_date is in 2024"
-- Return: transaction_id, transaction_type, amount, description, transaction_date
-- Sort: transaction_date DESC
--
-- Think:
-- → Table: transactions
-- → transaction_type IN (...)
-- → amount BETWEEN
-- → (description LIKE '%Transfer%' OR description IS NULL) ← parentheses!
-- → transaction_date BETWEEN for the year 2024

-- YOUR SQL HERE:




-- ============================================================
-- ✅ WHEN DONE: Paste your answers for review.
-- ============================================================
