-- ============================================================
-- 🏦 SQL Day 03 — Operators: AND/OR/NOT, IN, BETWEEN, LIKE, IS NULL
-- Mentor: Senior Data Engineer @ Citi
-- Database: Citi Bank Banking System
-- ============================================================


-- ============================================================
-- SECTION 1: AND, OR, NOT
-- ============================================================

-- ── Query 1: AND — both conditions must be true ──────────────
-- Find customers who are in Mumbai AND are active
-- Both conditions MUST be true for a row to be returned

SELECT customer_id, first_name, city, is_active
FROM customers
WHERE city = 'Mumbai'           -- condition 1
  AND is_active = TRUE;         -- condition 2 (AND = both required)


-- ── Query 2: OR — at least one condition must be true ────────
-- Find customers in Mumbai OR Delhi
-- If either city matches, the row is returned

SELECT customer_id, first_name, city
FROM customers
WHERE city = 'Mumbai'           -- condition 1
   OR city = 'Delhi';           -- condition 2 (OR = either is fine)


-- ── Query 3: NOT — reverse/negate a condition ────────────────
-- Find all customers who are NOT in Mumbai

SELECT customer_id, first_name, city
FROM customers
WHERE NOT city = 'Mumbai';

-- Same result, cleaner syntax:
-- WHERE city <> 'Mumbai'


-- ── Query 4: Combining AND + OR — parentheses are critical! ──
-- Find ACTIVE customers in Mumbai OR Delhi
-- WRONG version (without parentheses):

SELECT customer_id, first_name, city, is_active
FROM customers
WHERE city = 'Mumbai' OR city = 'Delhi' AND is_active = TRUE;
-- SQL evaluates this as:
-- city = 'Mumbai' OR (city = 'Delhi' AND is_active = TRUE)
-- Mumbai customers don't need to be active! Bug!

-- CORRECT version (with parentheses):
SELECT customer_id, first_name, city, is_active
FROM customers
WHERE (city = 'Mumbai' OR city = 'Delhi')
  AND is_active = TRUE;
-- Now BOTH cities require is_active = TRUE


-- ── Query 5: Multiple AND conditions ────────────────────────
-- Find DEBIT transactions above ₹10,000 from account 2001
-- Three conditions, ALL must be true

SELECT transaction_id, account_id, transaction_type, amount
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount > 10000
  AND account_id = 2001;


-- ── Query 6: Combining NOT with IN (preview) ─────────────────
-- Find employees who are NOT in Data Engineering department

SELECT first_name, last_name, department
FROM employees
WHERE NOT department = 'Data Engineering';


-- ============================================================
-- SECTION 2: IN OPERATOR
-- ============================================================

-- ── Query 7: Basic IN ────────────────────────────────────────
-- Find customers in Mumbai, Delhi, or Bangalore
-- IN = shortcut for multiple OR conditions

SELECT customer_id, first_name, city
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore');

-- Without IN, you would write:
-- WHERE city = 'Mumbai' OR city = 'Delhi' OR city = 'Bangalore'
-- IN is cleaner and more readable!


-- ── Query 8: IN with numbers ─────────────────────────────────
-- Find accounts belonging to specific customers

SELECT account_id, account_type, balance
FROM accounts
WHERE customer_id IN (1001, 1003, 1005);


-- ── Query 9: NOT IN ──────────────────────────────────────────
-- Find employees NOT in the Data Engineering or Fraud departments

SELECT employee_id, first_name, department
FROM employees
WHERE department NOT IN ('Data Engineering', 'Fraud');


-- ── Query 10: IN with loan types ─────────────────────────────
-- Find only Home and Auto loans (exclude Personal, Education)

SELECT loan_id, customer_id, loan_type, principal_amount
FROM loans
WHERE loan_type IN ('Home', 'Auto');


-- ── Query 11: Citi Scenario — Multi-city report ──────────────
-- Branch operations report: active customers from key metros
-- Sort by city then by name

SELECT first_name, last_name, city, is_active
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Hyderabad')
  AND is_active = TRUE
ORDER BY city ASC, last_name ASC;


-- ============================================================
-- SECTION 3: BETWEEN OPERATOR
-- ============================================================

-- ── Query 12: BETWEEN with numbers ───────────────────────────
-- Find accounts with balance between ₹50,000 and ₹300,000
-- BETWEEN is INCLUSIVE — includes both 50000 and 300000

SELECT account_id, account_type, balance
FROM accounts
WHERE balance BETWEEN 50000 AND 300000;

-- Same as:
-- WHERE balance >= 50000 AND balance <= 300000


-- ── Query 13: BETWEEN with dates ─────────────────────────────
-- Find all transactions in January 2024
-- Date BETWEEN is extremely common in banking reports!

SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31';


-- ── Query 14: NOT BETWEEN ────────────────────────────────────
-- Find transactions OUTSIDE the normal range (too small or too large)
-- Could indicate data quality issues

SELECT transaction_id, amount
FROM transactions
WHERE amount NOT BETWEEN 100 AND 50000;


-- ── Query 15: BETWEEN on salary ──────────────────────────────
-- HR query: mid-band salary employees

SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 80000 AND 100000
ORDER BY salary ASC;


-- ── Query 16: Citi Scenario — Quarterly Fraud Report ────────
-- Q1 2024 large DEBIT transactions for fraud review

SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount BETWEEN 20000 AND 500000
  AND transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY amount DESC;


-- ============================================================
-- SECTION 4: LIKE OPERATOR
-- ============================================================

-- ── Query 17: LIKE with % — starts with ──────────────────────
-- Find customers whose first name starts with 'A'
-- '%' = zero or more characters

SELECT customer_id, first_name, last_name
FROM customers
WHERE first_name LIKE 'A%';
-- Matches: Ayesha, Ahmed, Arjun, Amita, etc.


-- ── Query 18: LIKE with % — ends with ────────────────────────
-- Find all gmail customers (email KYC check)

SELECT customer_id, first_name, email
FROM customers
WHERE email LIKE '%@gmail.com';
-- Matches: anything ending in @gmail.com


-- ── Query 19: LIKE with % — contains ─────────────────────────
-- Find transaction descriptions that mention 'Transfer'

SELECT transaction_id, amount, description
FROM transactions
WHERE description LIKE '%Transfer%';


-- ── Query 20: LIKE with _ — single character wildcard ────────
-- Find customers whose name is exactly 4 characters
-- _ = exactly ONE character

SELECT customer_id, first_name
FROM customers
WHERE first_name LIKE '____';
-- 4 underscores = exactly 4 characters
-- Matches: Ravi, Zara, etc.


-- ── Query 21: LIKE with _ and % — combined ───────────────────
-- Find first names where the second character is 'a'

SELECT first_name
FROM customers
WHERE first_name LIKE '_a%';
-- _ = any first character
-- a = second character must be 'a'
-- % = anything after
-- Matches: Ravi, Karan, Zara, Priya


-- ── Query 22: NOT LIKE ───────────────────────────────────────
-- Exclude customers with citi.com email (find non-Citi emails)

SELECT customer_id, first_name, email
FROM customers
WHERE email NOT LIKE '%@citi.com';


-- ── Query 23: Citi Scenario — KYC email domain check ────────
-- Compliance: find all customers on company domains (not personal email)

SELECT customer_id, first_name, email
FROM customers
WHERE email LIKE '%@citi.com'
   OR email LIKE '%@corporate.com'
ORDER BY first_name ASC;


-- ============================================================
-- SECTION 5: IS NULL / IS NOT NULL
-- ============================================================

-- ── Query 24: IS NULL ────────────────────────────────────────
-- Find customers with no email on file (incomplete KYC)
-- NULL = missing/unknown value

SELECT customer_id, first_name, last_name, email
FROM customers
WHERE email IS NULL;

-- NEVER write: WHERE email = NULL  → this ALWAYS returns 0 rows!


-- ── Query 25: IS NOT NULL ────────────────────────────────────
-- Find customers who HAVE provided their email

SELECT customer_id, first_name, email
FROM customers
WHERE email IS NOT NULL;


-- ── Query 26: IS NULL on dates ───────────────────────────────
-- Find loans with no end date (open-ended / revolving credit)

SELECT loan_id, loan_type, loan_start_date, loan_end_date
FROM loans
WHERE loan_end_date IS NULL;


-- ── Query 27: IS NULL + AND ──────────────────────────────────
-- Citi KYC check: active customers with missing email
-- This is an ETL data quality query — used in onboarding pipelines

SELECT customer_id, first_name, last_name, is_active, email
FROM customers
WHERE is_active = TRUE
  AND email IS NULL;


-- ── Query 28: IS NOT NULL + ORDER BY ────────────────────────
-- Find all transactions that have a description, newest first

SELECT transaction_id, amount, description, transaction_date
FROM transactions
WHERE description IS NOT NULL
ORDER BY transaction_date DESC;


-- ============================================================
-- SECTION 6: COMBINING EVERYTHING
-- ============================================================

-- ── Query 29: Full filter — Citi Risk Dashboard ──────────────
-- Risk team: active savings accounts with balance below ₹5,000
-- from customers in major metros — potential dormant account flag

SELECT
    c.customer_id,
    c.first_name,
    c.city,
    a.account_id,
    a.balance
FROM customers AS c,
     accounts AS a
WHERE c.customer_id = a.customer_id          -- link the two tables (preview of JOINs!)
  AND c.is_active = TRUE
  AND c.city IN ('Mumbai', 'Delhi', 'Bangalore')
  AND a.account_type = 'Savings'
  AND a.balance BETWEEN 0 AND 5000
ORDER BY a.balance ASC;

-- NOTE: The c.customer_id = a.customer_id is a basic JOIN (you'll master this on Day 05)
-- Today, just notice how IN, BETWEEN, and AND work together


-- ============================================================
-- 🧠 MENTOR NOTES — NULL Trap with NOT IN
-- ============================================================
--
-- DANGEROUS BUG: NOT IN with NULLs
--
-- If a column has ANY NULL values, NOT IN returns NO ROWS.
-- Example:
--
-- emails = ('a@b.com', 'c@d.com', NULL)
--
-- SELECT * FROM customers
-- WHERE email NOT IN ('a@b.com');
-- → Returns NOTHING because SQL checks:
--   Is 'c@d.com' not in ('a@b.com')? YES
--   Is NULL not in ('a@b.com')? UNKNOWN → row excluded!
--
-- Safe version: combine NOT IN with IS NOT NULL
-- WHERE email IS NOT NULL
--   AND email NOT IN ('a@b.com')
--
-- This is a FAMOUS SQL interview gotcha question at Citi!
--
-- ============================================================
