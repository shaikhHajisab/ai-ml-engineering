-- ============================================================
-- 🏦 SQL Day 05 — PRACTICE FILE
-- Topic: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER, SELF, CROSS
-- ============================================================
-- TABLES & RELATIONSHIPS:
--   customers   (customer_id PK)
--        ↕  1-to-many
--   accounts    (account_id PK,  customer_id FK → customers)
--        ↕  1-to-many
--   transactions(transaction_id PK, account_id FK → accounts)
--   loans       (loan_id PK,     customer_id FK → customers)
--   employees   (employee_id PK, branch_id FK → branches)
--   branches    (branch_id PK)
-- ============================================================
-- ⚠️ RULES:
--   1. SQL keywords UPPERCASE
--   2. Always use table aliases: customers AS c, accounts AS a
--   3. Always qualify columns: c.customer_id, a.balance
--   4. FROM and each JOIN on their own line
--   5. ON condition indented under JOIN
-- ============================================================


-- ============================================================
-- 🟢 EASY QUESTIONS (3)
-- ============================================================

-- ── Easy 1 ───────────────────────────────────────────────────
-- Citi Customer Service asks:
-- "Show all accounts WITH the customer's first name, last name, and city"
-- Return: customer_id, first_name, last_name, city, account_id, account_type, balance
-- Sort: balance descending
--
-- Think:
-- → Tables: customers + accounts
-- → Link: c.customer_id = a.customer_id
-- → All accounts have a customer → INNER JOIN
-- → columns from BOTH tables → use aliases

-- YOUR SQL HERE:




-- ── Easy 2 ───────────────────────────────────────────────────
-- Loan Department asks:
-- "Show all loans with the customer's first name and city"
-- Return: first_name, city, loan_type, principal_amount, interest_rate, status
-- Sort: principal_amount descending
--
-- Think:
-- → Tables: customers + loans
-- → INNER JOIN on customer_id

-- YOUR SQL HERE:




-- ── Easy 3 ───────────────────────────────────────────────────
-- HR asks:
-- "Show all employees with their branch name and branch city"
-- Return: first_name, last_name, department, salary, branch_name, city (branch city)
-- Sort: salary descending
--
-- Think:
-- → Tables: employees + branches
-- → INNER JOIN on branch_id

-- YOUR SQL HERE:




-- ============================================================
-- 🟡 MEDIUM QUESTIONS (3)
-- ============================================================

-- ── Medium 1 ─────────────────────────────────────────────────
-- Citi Fraud Team asks:
-- "Show all DEBIT transactions with the customer name and city"
-- Return: first_name, city, account_type, amount, transaction_date, description
-- Sort: amount descending
--
-- Think:
-- → 3 tables: customers → accounts → transactions
-- → Two INNER JOINs chained
-- → WHERE for DEBIT filter

-- YOUR SQL HERE:




-- ── Medium 2 ─────────────────────────────────────────────────
-- KYC Compliance asks:
-- "Find all customers who have NO loan with Citi"
-- Return: customer_id, first_name, last_name, city
--
-- Think:
-- → Tables: customers + loans
-- → LEFT JOIN (keep ALL customers)
-- → WHERE l.loan_id IS NULL  ← the anti-join pattern!

-- YOUR SQL HERE:




-- ── Medium 3 ─────────────────────────────────────────────────
-- Analytics Team asks:
-- "For each customer, show their name and
--  total number of accounts and total balance across all accounts"
-- Include customers even if they have NO account (show 0 or NULL)
-- Return: customer_id, first_name, num_accounts, total_balance
-- Sort: total_balance descending
--
-- Think:
-- → Tables: customers + accounts
-- → LEFT JOIN (keep all customers)
-- → GROUP BY customer
-- → COUNT(a.account_id) handles NULLs for customers with no account

-- YOUR SQL HERE:




-- ============================================================
-- 🔴 HARD QUESTIONS (2)
-- ============================================================

-- ── Hard 1 ───────────────────────────────────────────────────
-- Citi Executive Report:
-- "For each customer, show their name, city,
--  total number of transactions, and total transaction amount.
--  Include ALL customers — even those with NO transactions (show 0 / NULL)."
-- Return: customer_id, first_name, city, transaction_count, total_transaction_amount
-- Sort: total_transaction_amount descending
--
-- Think:
-- → 3 tables: customers → accounts → transactions
-- → LEFT JOIN both (keep all customers)
-- → GROUP BY customer
-- → COUNT(t.transaction_id) — skips NULLs → customers with no tx show 0

-- YOUR SQL HERE:




-- ── Hard 2 ───────────────────────────────────────────────────
-- Citi Data Engineering — Full Customer Profile:
-- "Write a query that shows for each customer:
--   - customer_id, first_name, city
--   - total number of accounts they have
--   - their total account balance
--   - total number of loans they have
--   - their total loan amount (principal)"
-- Only include customers who have AT LEAST ONE account.
-- Return the above columns.
-- Sort: total_balance descending.
--
-- Think:
-- → Tables: customers + accounts + loans
-- → INNER JOIN accounts (only customers with accounts)
-- → LEFT JOIN loans (some customers may have no loan)
-- → GROUP BY customer
-- → Multiple aggregates from different joined tables

-- YOUR SQL HERE:




-- ============================================================
-- ✅ WHEN DONE: Paste your answers for review.
-- ============================================================
