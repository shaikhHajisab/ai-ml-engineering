-- ============================================================
-- 🏦 SQL Day 02 — SOLUTIONS
-- ⚠️ DO NOT OPEN UNTIL YOU HAVE ATTEMPTED ALL PRACTICE QUESTIONS ⚠️
-- ============================================================


-- ── Easy 1 Solution ──────────────────────────────────────────
SELECT account_id, account_type, balance
FROM accounts
WHERE balance < 10000;


-- ── Easy 2 Solution ──────────────────────────────────────────
SELECT first_name, last_name, department, salary
FROM employees
ORDER BY salary DESC;


-- ── Easy 3 Solution ──────────────────────────────────────────
SELECT DISTINCT city
FROM customers
ORDER BY city ASC;


-- ── Medium 1 Solution ────────────────────────────────────────
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
ORDER BY amount DESC, transaction_date DESC
LIMIT 3;


-- ── Medium 2 Solution ────────────────────────────────────────
SELECT 
    loan_id          AS "Loan ID",
    loan_type        AS "Type",
    principal_amount AS "Principal (INR)",
    interest_rate    AS "Rate (%)",
    status           AS "Status"
FROM loans
WHERE status = 'ACTIVE';


-- ── Medium 3 Solution ────────────────────────────────────────
SELECT first_name, last_name, salary, hire_date
FROM employees
WHERE department = 'Data Engineering'
ORDER BY hire_date ASC;


-- ── Hard 1 Solution ──────────────────────────────────────────
SELECT 
    customer_id,
    account_id,
    balance AS "Savings Balance"
FROM accounts
WHERE account_type = 'Savings'
  AND balance > 50000
ORDER BY balance DESC
LIMIT 3;


-- ── Hard 2 Solution (with bonus) ─────────────────────────────
SELECT 
    transaction_id,
    amount           AS "Debit Amount",
    transaction_date AS "When"
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount > 5000
ORDER BY amount DESC
LIMIT 2;
