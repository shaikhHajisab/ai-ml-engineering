-- ============================================================
-- 🏦 SQL Day 05 — JOINs: INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS
-- Mentor: Senior Data Engineer @ Citi
-- Database: Citi Bank Banking System
-- ============================================================
-- IMPORTANT: Always use table aliases in JOINs!
-- Always qualify column names with table alias: c.customer_id
-- ============================================================


-- ============================================================
-- SECTION 1: INNER JOIN
-- ============================================================

-- ── Query 1: Basic INNER JOIN ─────────────────────────────────
-- Join customers and accounts to get customer name + account info
-- ON c.customer_id = a.customer_id → the linking condition
-- Only rows that exist in BOTH tables are returned

SELECT
    c.customer_id,
    c.first_name,
    c.city,
    a.account_id,
    a.account_type,
    a.balance
FROM customers AS c                                    -- left table
INNER JOIN accounts AS a                               -- right table
    ON c.customer_id = a.customer_id;                 -- join condition


-- ── Query 2: INNER JOIN — select specific columns ────────────
-- Business question: "Show customer names with their account balances"
-- c. prefix means "from customers table"
-- a. prefix means "from accounts table"

SELECT
    c.first_name                     AS "Customer Name",
    c.city                           AS "City",
    a.account_type                   AS "Account Type",
    a.balance                        AS "Balance"
FROM customers AS c
INNER JOIN accounts AS a
    ON c.customer_id = a.customer_id
ORDER BY a.balance DESC;


-- ── Query 3: INNER JOIN — customers and transactions ─────────
-- "Show customer names alongside their transactions"
-- This requires 3 tables: customers → accounts → transactions
-- Chain two JOINs!

SELECT
    c.first_name,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM customers AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
ORDER BY t.transaction_date DESC;


-- ── Query 4: INNER JOIN with WHERE ────────────────────────────
-- "Show all DEBIT transactions with the customer's name"
-- WHERE filters AFTER the join

SELECT
    c.first_name,
    c.city,
    t.amount,
    t.transaction_date,
    t.description
FROM customers AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
WHERE t.transaction_type = 'DEBIT'
ORDER BY t.amount DESC;


-- ── Query 5: INNER JOIN with aggregate ───────────────────────
-- "Total transaction amount per customer" (customer name + total)
-- JOIN first, then GROUP BY

SELECT
    c.customer_id,
    c.first_name,
    COUNT(t.transaction_id)  AS num_transactions,
    SUM(t.amount)            AS total_amount
FROM customers AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
GROUP BY c.customer_id, c.first_name
ORDER BY total_amount DESC;


-- ── Query 6: INNER JOIN — customers and loans ────────────────
-- "Show customer names with their loan details"

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


-- ── Query 7: INNER JOIN — employees and branches ─────────────
-- "Show employee names with their branch city"

SELECT
    e.first_name,
    e.department,
    e.salary,
    b.branch_name,
    b.city   AS branch_city
FROM employees AS e
INNER JOIN branches AS b ON e.branch_id = b.branch_id
ORDER BY e.salary DESC;


-- ============================================================
-- SECTION 2: LEFT JOIN
-- ============================================================

-- ── Query 8: Basic LEFT JOIN ──────────────────────────────────
-- "Show ALL customers and their accounts (even customers with no account)"
-- Customers WITHOUT an account → account columns are NULL

SELECT
    c.customer_id,
    c.first_name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id;

-- Compare with INNER JOIN (Query 1) to see the difference!


-- ── Query 9: LEFT JOIN + IS NULL — THE CLASSIC PATTERN ───────
-- *** MOST ASKED PATTERN IN CITI INTERVIEWS ***
-- "Find all customers who have NO bank account"
-- Step 1: LEFT JOIN keeps all customers
-- Step 2: WHERE a.account_id IS NULL → only the unmatched ones

SELECT
    c.customer_id,
    c.first_name,
    c.city
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;      -- no matching account found!

-- If you have customers in the DB with no account, they appear here.
-- This is used for KYC onboarding: "who registered but never opened an account?"


-- ── Query 10: LEFT JOIN — customers with no loans ────────────
-- "Find all customers who have NEVER taken a loan from Citi"

SELECT
    c.customer_id,
    c.first_name,
    c.city,
    l.loan_id                    -- will be NULL for customers with no loan
FROM customers AS c
LEFT JOIN loans AS l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;


-- ── Query 11: LEFT JOIN with aggregate ───────────────────────
-- "Show all customers and their total account balance"
-- Customers with no account: balance shows as NULL (or 0 if COALESCE used)

SELECT
    c.customer_id,
    c.first_name,
    COUNT(a.account_id)          AS num_accounts,
    SUM(a.balance)               AS total_balance
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY total_balance DESC;

-- Note: COUNT(a.account_id) = 0 for customers with no account (skips NULLs)
-- Note: SUM(a.balance) = NULL for customers with no account


-- ── Query 12: LEFT JOIN — all accounts with transaction count ─
-- "How many transactions does each account have? Include accounts with 0."

SELECT
    a.account_id,
    a.account_type,
    a.balance,
    COUNT(t.transaction_id)      AS transaction_count
FROM accounts AS a
LEFT JOIN transactions AS t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_type, a.balance
ORDER BY transaction_count DESC;


-- ============================================================
-- SECTION 3: RIGHT JOIN
-- ============================================================

-- ── Query 13: RIGHT JOIN ──────────────────────────────────────
-- "Show ALL accounts, with customer info where available"
-- (same result as LEFT JOIN with tables swapped)

SELECT
    c.first_name,
    c.city,
    a.account_id,
    a.account_type,
    a.balance
FROM customers AS c
RIGHT JOIN accounts AS a ON c.customer_id = a.customer_id;

-- EQUIVALENT to:
-- FROM accounts AS a LEFT JOIN customers AS c ON a.customer_id = c.customer_id


-- ============================================================
-- SECTION 4: FULL OUTER JOIN
-- ============================================================

-- ── Query 14: FULL OUTER JOIN ─────────────────────────────────
-- Returns ALL customers AND ALL accounts
-- Where no match: NULLs on the unmatched side

SELECT
    c.customer_id,
    c.first_name,
    a.account_id,
    a.account_type
FROM customers AS c
FULL OUTER JOIN accounts AS a ON c.customer_id = a.customer_id;

-- In MySQL, simulate with UNION:
-- SELECT c.customer_id, c.first_name, a.account_id, a.account_type
-- FROM customers AS c LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
-- UNION
-- SELECT c.customer_id, c.first_name, a.account_id, a.account_type
-- FROM customers AS c RIGHT JOIN accounts AS a ON c.customer_id = a.customer_id;


-- ============================================================
-- SECTION 5: SELF JOIN
-- ============================================================

-- ── Query 15: SELF JOIN — Add manager_id to employees table ──
-- First, let's add a manager_id column to understand the concept
-- (In real scenario, employees table would already have manager_id)

-- Conceptual setup: imagine employees table has:
-- employee_id | first_name | manager_id (FK → employee_id)
-- 201 | Meera | 204   (Meera reports to Rohan)
-- 202 | Karan | 204   (Karan reports to Rohan)
-- 203 | Zara  | 204   (Zara reports to Rohan)
-- 204 | Rohan | NULL  (Rohan is the manager, no one above)

-- SELF JOIN: show each employee with their manager's name
-- e = employee row
-- m = manager row (same table, different alias!)

SELECT
    e.employee_id,
    e.first_name          AS employee_name,
    e.department,
    m.first_name          AS manager_name
FROM employees AS e
LEFT JOIN employees AS m ON e.branch_id = m.branch_id
                         AND e.employee_id <> m.employee_id   -- exclude self-match
WHERE m.salary > e.salary;
-- Shows employees paired with higher-paid colleagues in same branch
-- This is a practical self-join pattern


-- ── Query 16: SELF JOIN — Find employees in same branch ──────
-- "Show pairs of employees who work in the same branch"

SELECT
    e1.first_name AS employee_1,
    e2.first_name AS employee_2,
    e1.branch_id
FROM employees AS e1
INNER JOIN employees AS e2
    ON  e1.branch_id  = e2.branch_id       -- same branch
    AND e1.employee_id < e2.employee_id;    -- avoid duplicate pairs (A,B) and (B,A)


-- ============================================================
-- SECTION 6: CROSS JOIN
-- ============================================================

-- ── Query 17: CROSS JOIN ──────────────────────────────────────
-- "Generate all combinations of loan types and branches"
-- 3 loan types × 3 branches = 9 rows

SELECT
    l.loan_type,
    b.branch_name,
    b.city
FROM loans AS l
CROSS JOIN branches AS b
ORDER BY l.loan_type, b.branch_name;


-- ============================================================
-- SECTION 7: COMPLEX JOINS — Citi Real Scenarios
-- ============================================================

-- ── Query 18: Full Customer 360 View ─────────────────────────
-- "For every transaction, show: customer name, city,
--  account type, transaction type, amount, date"
-- This is the kind of query used in Citi's customer analytics dashboards

SELECT
    c.first_name                 AS customer,
    c.city,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date           AS tx_date,
    t.description
FROM customers     AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
ORDER BY t.transaction_date DESC;


-- ── Query 19: Customer + Loan + Branch Report ─────────────────
-- "Show customer name, their loan details, and their branch name"

SELECT
    c.first_name,
    l.loan_type,
    l.principal_amount,
    l.interest_rate,
    b.branch_name
FROM customers AS c
INNER JOIN loans     AS l ON c.customer_id = l.customer_id
INNER JOIN accounts  AS a ON c.customer_id = a.customer_id
INNER JOIN branches  AS b ON a.account_id  = b.branch_id    -- conceptual
ORDER BY l.principal_amount DESC;


-- ── Query 20: Fraud Report — large transactions with customer name ──
-- "Find all transactions above ₹50,000 with customer info"
-- Fraud team needs full context: who, what, when, how much

SELECT
    c.customer_id,
    c.first_name,
    c.city,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.description
FROM customers     AS c
INNER JOIN accounts     AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id  = t.account_id
WHERE t.amount > 50000
ORDER BY t.amount DESC;


-- ============================================================
-- 🧠 MENTOR NOTES — JOIN Best Practices
-- ============================================================
--
-- 1. ALWAYS use table aliases (c, a, t, l, b)
--    Without aliases: SELECT customer_id → which table's customer_id?!
--
-- 2. ALWAYS qualify columns: c.customer_id, NOT just customer_id
--    When both tables have customer_id → SQL is confused without alias
--
-- 3. JOIN order matters for LEFT/RIGHT but not INNER
--    LEFT JOIN: put the "master" table on the left (the one you want ALL rows from)
--
-- 4. LEFT JOIN + IS NULL = anti-join (find rows NOT in another table)
--    This is the most frequently tested pattern in Citi interviews!
--
-- 5. INNER JOIN ≡ JOIN (they are identical — INNER is implied)
--    Use INNER JOIN for clarity in code reviews
--
-- 6. Watch out for DUPLICATE rows after JOIN
--    If one customer has 3 accounts → customer appears 3 times after join
--    Use GROUP BY + aggregate to roll them up
--
-- 7. JOIN execution adds to query cost
--    On large tables: make sure joining columns are INDEXED (Day 09 topic)
--
-- ============================================================
