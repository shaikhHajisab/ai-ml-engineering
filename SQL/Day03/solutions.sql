-- ============================================================
-- 🏦 SQL Day 03 — SOLUTIONS
-- ⚠️ DO NOT OPEN UNTIL YOU HAVE ATTEMPTED ALL QUESTIONS ⚠️
-- ============================================================


-- ── Easy 1 Solution ──────────────────────────────────────────
SELECT loan_id, loan_type, principal_amount, status
FROM loans
WHERE loan_type IN ('Home', 'Auto');


-- ── Easy 2 Solution ──────────────────────────────────────────
SELECT customer_id, first_name, last_name
FROM customers
WHERE email IS NULL;


-- ── Easy 3 Solution ──────────────────────────────────────────
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 80000 AND 100000
ORDER BY salary DESC;


-- ── Medium 1 Solution ────────────────────────────────────────
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_type = 'CREDIT'
  AND amount BETWEEN 10000 AND 100000
  AND transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY amount DESC;


-- ── Medium 2 Solution ────────────────────────────────────────
SELECT customer_id, first_name, last_name, city
FROM customers
WHERE is_active = TRUE
  AND (first_name LIKE 'A%' OR first_name LIKE 'R%');


-- ── Medium 3 Solution ────────────────────────────────────────
SELECT account_id, account_type, balance
FROM accounts
WHERE account_type NOT IN ('Savings')
  AND balance > 50000
ORDER BY balance DESC;

-- Alternative (using <>):
-- WHERE account_type <> 'Savings'


-- ── Hard 1 Solution ──────────────────────────────────────────
SELECT customer_id, first_name, last_name, city, date_of_birth
FROM customers
WHERE is_active = TRUE
  AND city IN ('Mumbai', 'Delhi', 'Bangalore')
  AND email IS NULL
  AND date_of_birth BETWEEN '1985-01-01' AND '1995-12-31'
ORDER BY city ASC, last_name ASC;


-- ── Hard 2 Solution ──────────────────────────────────────────
SELECT transaction_id, transaction_type, amount, description, transaction_date
FROM transactions
WHERE transaction_type IN ('DEBIT', 'CREDIT')
  AND amount BETWEEN 5000 AND 200000
  AND (description LIKE '%Transfer%' OR description IS NULL)
  AND transaction_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY transaction_date DESC;
