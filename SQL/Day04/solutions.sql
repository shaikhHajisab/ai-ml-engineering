-- ============================================================
-- 🏦 SQL Day 04 — SOLUTIONS
-- ⚠️ DO NOT OPEN UNTIL YOU HAVE ATTEMPTED ALL QUESTIONS ⚠️
-- ============================================================


-- ── Easy 1 Solution ──────────────────────────────────────────
SELECT COUNT(*)     AS total_customers,
       COUNT(email) AS customers_with_email
FROM customers;


-- ── Easy 2 Solution ──────────────────────────────────────────
SELECT SUM(balance) AS total_balance,
       AVG(balance) AS avg_balance,
       MIN(balance) AS min_balance,
       MAX(balance) AS max_balance
FROM accounts;


-- ── Easy 3 Solution ──────────────────────────────────────────
SELECT department,
       COUNT(*)    AS employee_count,
       AVG(salary) AS avg_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;


-- ── Medium 1 Solution ────────────────────────────────────────
SELECT transaction_type,
       COUNT(*)    AS num_transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_type ASC;


-- ── Medium 2 Solution ────────────────────────────────────────
SELECT loan_type,
       COUNT(*)              AS loan_count,
       SUM(principal_amount) AS total_principal,
       AVG(interest_rate)    AS avg_interest_rate
FROM loans
WHERE status = 'ACTIVE'
GROUP BY loan_type
ORDER BY total_principal DESC;


-- ── Medium 3 Solution ────────────────────────────────────────
SELECT city,
       COUNT(*) AS active_customer_count
FROM customers
WHERE is_active = TRUE
GROUP BY city
HAVING COUNT(*) > 0
ORDER BY active_customer_count DESC;


-- ── Hard 1 Solution ──────────────────────────────────────────
SELECT account_id,
       COUNT(*)    AS transaction_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
HAVING COUNT(*) > 1
   AND SUM(amount) > 20000
ORDER BY total_amount DESC;


-- ── Hard 2 Solution (with bonus) ─────────────────────────────
SELECT department,
       COUNT(*)    AS headcount,
       AVG(salary) AS avg_salary,
       SUM(salary) AS total_salary_bill
FROM employees
WHERE hire_date > '2019-01-01'       -- BONUS: filter rows first
GROUP BY department
HAVING AVG(salary) > 80000
   AND COUNT(*) >= 1
ORDER BY total_salary_bill DESC;
