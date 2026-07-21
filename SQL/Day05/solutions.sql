-- ============================================================
-- 🏦 SQL Day 05 — SOLUTIONS
-- ⚠️ DO NOT OPEN UNTIL YOU HAVE ATTEMPTED ALL QUESTIONS ⚠️
-- ============================================================


-- ── Easy 1 Solution ──────────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    a.account_id,
    a.account_type,
    a.balance
FROM customers AS c
INNER JOIN accounts AS a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC;


-- ── Easy 2 Solution ──────────────────────────────────────────
SELECT
    c.first_name,
    c.city,
    l.loan_type,
    l.principal_amount,
    l.interest_rate,
    l.status
FROM customers AS c
INNER JOIN loans AS l ON c.customer_id = l.customer_id
ORDER BY l.principal_amount DESC;


-- ── Easy 3 Solution ──────────────────────────────────────────
SELECT
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    b.branch_name,
    b.city          AS branch_city
FROM employees AS e
INNER JOIN branches AS b ON e.branch_id = b.branch_id
ORDER BY e.salary DESC;


-- ── Medium 1 Solution ────────────────────────────────────────
SELECT
    c.first_name,
    c.city,
    a.account_type,
    t.amount,
    t.transaction_date,
    t.description
FROM customers     AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
WHERE t.transaction_type = 'DEBIT'
ORDER BY t.amount DESC;


-- ── Medium 2 Solution ────────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
FROM customers AS c
LEFT JOIN loans AS l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;


-- ── Medium 3 Solution ────────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    COUNT(a.account_id)  AS num_accounts,
    SUM(a.balance)       AS total_balance
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY total_balance DESC;


-- ── Hard 1 Solution ──────────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    c.city,
    COUNT(t.transaction_id)  AS transaction_count,
    SUM(t.amount)            AS total_transaction_amount
FROM customers     AS c
LEFT JOIN accounts     AS a ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t ON a.account_id  = t.account_id
GROUP BY c.customer_id, c.first_name, c.city
ORDER BY total_transaction_amount DESC;


-- ── Hard 2 Solution ──────────────────────────────────────────
SELECT
    c.customer_id,
    c.first_name,
    c.city,
    COUNT(DISTINCT a.account_id)   AS num_accounts,
    SUM(a.balance)                 AS total_balance,
    COUNT(DISTINCT l.loan_id)      AS num_loans,
    SUM(l.principal_amount)        AS total_loan_amount
FROM customers AS c
INNER JOIN accounts AS a ON c.customer_id = a.customer_id    -- must have account
LEFT  JOIN loans    AS l ON c.customer_id = l.customer_id    -- may or may not have loan
GROUP BY c.customer_id, c.first_name, c.city
ORDER BY total_balance DESC;
