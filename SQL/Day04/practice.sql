-- ============================================================
-- 🏦 SQL Day 04 — PRACTICE FILE
-- Topic: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- ============================================================
-- TABLES:
--   customers    → customer_id, first_name, last_name, email, city, date_of_birth, is_active
--   accounts     → account_id, customer_id, account_type, balance, opened_date
--   transactions → transaction_id, account_id, transaction_type, amount, transaction_date, description
--   employees    → employee_id, first_name, last_name, department, salary, hire_date, branch_id
--   loans        → loan_id, customer_id, loan_type, principal_amount, interest_rate, loan_start_date, status
-- ============================================================
-- ⚠️ RULES (from previous feedback):
--   1. SQL keywords UPPERCASE
--   2. Spaces around operators: balance < 10000
--   3. FROM, WHERE, GROUP BY, HAVING, ORDER BY on their OWN LINE
--   4. Each AND condition on its own line
--   5. GROUP BY rule: every non-aggregate SELECT column MUST appear in GROUP BY
-- ============================================================


-- ============================================================
-- 🟢 EASY QUESTIONS (3)
-- ============================================================

-- ── Easy 1 ───────────────────────────────────────────────────
-- Management asks:
-- "How many total customers does Citi have?
--  Also show how many of them have provided their email."
-- Return: total_customers, customers_with_email (two numbers, one row)
--
-- Think:
-- → Table: customers
-- → COUNT(*) for total
-- → COUNT(email) for those with email

-- YOUR SQL HERE:
SELECT COUNT(customer_id) as total_customer,
    COUNT(email) as customer_with_email
FROM customers  



-- ── Easy 2 ───────────────────────────────────────────────────
-- Finance asks:
-- "What is the total balance held across ALL accounts at Citi?
--  Also show the average balance, minimum balance, and maximum balance."
-- Return: total_balance, avg_balance, min_balance, max_balance (one row)
--
-- Think:
-- → Table: accounts
-- → SUM, AVG, MIN, MAX in one SELECT

-- YOUR SQL HERE:
SELECT SUM(balance) as total_balance,
    AVG(balance) as avg_balance,
    MIN(balance) as min_balance,
    MAX(balance) as max_balance
FROM accounts  



-- ── Easy 3 ───────────────────────────────────────────────────
-- HR asks:
-- "Show me a salary summary for each department:
--  number of employees, average salary, highest salary."
-- Return: department, employee_count, avg_salary, max_salary
-- Sort: avg_salary descending
--
-- Think:
-- → Table: employees
-- → GROUP BY department
-- → COUNT, AVG, MAX per group

-- YOUR SQL HERE:
SELECT department, COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC




-- ============================================================
-- 🟡 MEDIUM QUESTIONS (3)
-- ============================================================

-- ── Medium 1 ─────────────────────────────────────────────────
-- Citi Operations daily report:
-- "For each transaction type (CREDIT/DEBIT),
--  show the number of transactions and total amount."
-- Return: transaction_type, num_transactions, total_amount
-- Sort: transaction_type ASC
--
-- Think:
-- → Table: transactions
-- → GROUP BY transaction_type
-- → COUNT(*) and SUM(amount)

-- YOUR SQL HERE:
SELECT transaction_type, COUNT(*) as num_transactions,
    SUM(amount) as total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_type ASC  



-- ── Medium 2 ─────────────────────────────────────────────────
-- Loan Risk Team asks:
-- "Show me the total loan principal and average interest rate
--  for each loan type. Only include ACTIVE loans."
-- Return: loan_type, loan_count, total_principal, avg_interest_rate
-- Sort: total_principal descending
--
-- Think:
-- → Table: loans
-- → WHERE status = 'ACTIVE'  ← filter BEFORE grouping
-- → GROUP BY loan_type
-- → COUNT, SUM, AVG

-- YOUR SQL HERE:
SELECT loan_type, COUNT(*) as loan_count,
    SUM(principal_amount) as total_principal,
    AVG(interest_rate) as avg_interest_rate
FROM loans
WHERE status = 'ACTIVE'
GROUP BY loan_type
ORDER BY total_principal DESC




-- ── Medium 3 ─────────────────────────────────────────────────
-- Customer Analytics:
-- "How many active customers does Citi have in EACH city?
--  Only show cities that have MORE THAN 0 active customers."
-- Return: city, active_customer_count
-- Sort: active_customer_count descending
--
-- Think:
-- → Table: customers
-- → WHERE is_active = TRUE
-- → GROUP BY city
-- → HAVING COUNT(*) > 0

-- YOUR SQL HERE:





-- ============================================================
-- 🔴 HARD QUESTIONS (2)
-- ============================================================

-- ── Hard 1 ───────────────────────────────────────────────────
-- Fraud Analytics:
-- "Find accounts that have made MORE THAN 1 transaction
--  AND whose total transaction amount is above ₹20,000.
--  Show the account_id, number of transactions, and total amount."
-- Return: account_id, transaction_count, total_amount
-- Sort: total_amount descending
--
-- Think:
-- → Table: transactions
-- → GROUP BY account_id
-- → HAVING with TWO conditions (COUNT > 1 AND SUM > 20000)

-- YOUR SQL HERE:




-- ── Hard 2 ───────────────────────────────────────────────────
-- Citi Executive Dashboard — Department Budget Audit:
-- "Among departments where average salary is ABOVE ₹80,000,
--  show department name, headcount, average salary, and total salary bill.
--  Only include departments that have AT LEAST 1 employee."
-- Return: department, headcount, avg_salary, total_salary_bill
-- Sort: total_salary_bill descending
--
-- BONUS: Add a WHERE clause to only look at employees hired after 2019-01-01
--
-- Think:
-- → Table: employees
-- → (BONUS) WHERE hire_date > '2019-01-01'
-- → GROUP BY department
-- → HAVING AVG(salary) > 80000 AND COUNT(*) >= 1
-- → SELECT must include: department, COUNT, AVG, SUM

-- YOUR SQL HERE:




-- ============================================================
-- ✅ WHEN DONE: Paste your answers for review.
-- ============================================================
