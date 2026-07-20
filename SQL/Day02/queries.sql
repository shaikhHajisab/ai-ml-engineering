-- ============================================================
-- 🏦 SQL Day 02 — WHERE, ORDER BY, LIMIT, DISTINCT, Aliases
-- Mentor: Senior Data Engineer @ Citi
-- Database: Citi Bank Banking System
-- ============================================================
-- Using tables created in Day 01:
--   customers, accounts, transactions, employees, loans, branches
-- ============================================================


-- ============================================================
-- SETUP: Run this if starting fresh (reuse Day 01 tables)
-- ============================================================
-- NOTE: These INSERT statements assume the Day 01 tables exist.
-- If you are starting fresh, run Day01/queries.sql first.
-- ============================================================


-- ============================================================
-- SECTION 1: WHERE CLAUSE
-- ============================================================

-- ── Query 1: Basic WHERE with text comparison ────────────────
-- Get all customers who live in Mumbai
--
-- SELECT   → choose all columns
-- FROM     → from customers table
-- WHERE    → apply filter condition
-- city = 'Mumbai' → only return rows where city column equals 'Mumbai'
-- NOTE: String values MUST be in single quotes!

SELECT *
FROM customers
WHERE city = 'Mumbai';


-- ── Query 2: WHERE with boolean filter ──────────────────────
-- Get only ACTIVE customers (those with is_active = TRUE)
-- This is used by Citi to filter inactive/closed accounts

SELECT customer_id, first_name, last_name, city
FROM customers
WHERE is_active = TRUE;


-- ── Query 3: WHERE with number comparison ───────────────────
-- Get all accounts with balance GREATER THAN 100,000

SELECT account_id, customer_id, account_type, balance
FROM accounts
WHERE balance > 100000;


-- ── Query 4: WHERE with greater than or equal ───────────────
-- Get transactions of 50,000 or more (Citi compliance threshold)

SELECT transaction_id, account_id, transaction_type, amount
FROM transactions
WHERE amount >= 50000;


-- ── Query 5: WHERE with not equal ───────────────────────────
-- Get all loans that are NOT in ACTIVE status
-- Use <> or != for "not equal"

SELECT loan_id, customer_id, loan_type, status
FROM loans
WHERE status <> 'ACTIVE';

-- Alternative syntax (same result):
-- WHERE status != 'ACTIVE'


-- ── Query 6: WHERE with less than ───────────────────────────
-- Find all accounts with low balance (below ₹5,000) — risk check

SELECT account_id, customer_id, balance
FROM accounts
WHERE balance < 5000;


-- ── Query 7: WHERE on a DEBIT transaction type ──────────────
-- Get all DEBIT transactions (money going out)

SELECT *
FROM transactions
WHERE transaction_type = 'DEBIT';


-- ============================================================
-- SECTION 2: ORDER BY
-- ============================================================

-- ── Query 8: ORDER BY ascending (default) ───────────────────
-- List all employees sorted by salary from lowest to highest
-- ASC is the DEFAULT — you can write it or omit it

SELECT employee_id, first_name, department, salary
FROM employees
ORDER BY salary ASC;


-- ── Query 9: ORDER BY descending ────────────────────────────
-- List all employees sorted by salary from HIGHEST to LOWEST
-- DESC = Descending = biggest first

SELECT employee_id, first_name, department, salary
FROM employees
ORDER BY salary DESC;


-- ── Query 10: ORDER BY on text column (alphabetical) ────────
-- List customers in alphabetical order by last name

SELECT customer_id, first_name, last_name
FROM customers
ORDER BY last_name ASC;


-- ── Query 11: ORDER BY on date (most recent first) ──────────
-- Show all transactions from newest to oldest
-- This is the most common sort in banking systems!

SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
ORDER BY transaction_date DESC;


-- ── Query 12: ORDER BY multiple columns ─────────────────────
-- Sort employees by department (A→Z), then within same department
-- sort by salary (highest first)
-- First column in ORDER BY takes priority

SELECT first_name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;


-- ============================================================
-- SECTION 3: LIMIT
-- ============================================================

-- ── Query 13: Simple LIMIT ───────────────────────────────────
-- Return only the first 3 rows from customers
-- Useful to preview data without fetching everything

SELECT *
FROM customers
LIMIT 3;


-- ── Query 14: LIMIT + ORDER BY = Top N pattern ──────────────
-- *** THIS IS THE MOST IMPORTANT PATTERN IN SQL INTERVIEWS ***
-- Get the TOP 3 highest-value transactions at Citi
-- Step 1: ORDER BY amount DESC (biggest first)
-- Step 2: LIMIT 3 (take only the top 3)

SELECT transaction_id, account_id, amount, transaction_type
FROM transactions
ORDER BY amount DESC
LIMIT 3;


-- ── Query 15: Get the single most recent transaction ────────
-- LIMIT 1 = return exactly ONE row
-- Very common in fraud detection: "show the last transaction on this account"

SELECT *
FROM transactions
ORDER BY transaction_date DESC
LIMIT 1;


-- ── Query 16: Top 2 highest-balance accounts ────────────────
-- Citi wealth management: find the top accounts by balance

SELECT account_id, customer_id, account_type, balance
FROM accounts
ORDER BY balance DESC
LIMIT 2;


-- ============================================================
-- SECTION 4: DISTINCT
-- ============================================================

-- ── Query 17: DISTINCT on city ──────────────────────────────
-- Find all unique cities where Citi has customers
-- Without DISTINCT, 'Mumbai' would appear once per Mumbai customer

SELECT DISTINCT city
FROM customers;


-- ── Query 18: DISTINCT on account_type ──────────────────────
-- What types of accounts does Citi offer?

SELECT DISTINCT account_type
FROM accounts;


-- ── Query 19: DISTINCT on department ────────────────────────
-- What departments exist in our branch system?

SELECT DISTINCT department
FROM employees;


-- ── Query 20: DISTINCT on transaction_type ──────────────────
-- What transaction types are in the system?

SELECT DISTINCT transaction_type
FROM transactions;


-- ── Query 21: DISTINCT on multiple columns ──────────────────
-- Unique combinations of city + is_active
-- Returns each unique PAIR — not just unique cities

SELECT DISTINCT city, is_active
FROM customers;


-- ============================================================
-- SECTION 5: ALIASES (AS)
-- ============================================================

-- ── Query 22: Column alias ───────────────────────────────────
-- Rename columns in the output for readability
-- The original column names in the table DO NOT change
-- Aliases only affect what the user sees in the result

SELECT 
    first_name    AS "First Name",
    last_name     AS "Last Name",
    city          AS "Home City"
FROM customers;


-- ── Query 23: Column alias without quotes ───────────────────
-- You can skip quotes for single-word aliases
-- Use quotes only when alias has SPACES or special characters

SELECT 
    account_id   AS acc_id,
    account_type AS acc_type,
    balance      AS current_balance
FROM accounts;


-- ── Query 24: Table alias ────────────────────────────────────
-- Give the table a short name to avoid typing long names
-- Table aliases are CRITICAL when doing JOINs (Day 05)

SELECT 
    c.customer_id,
    c.first_name,
    c.city
FROM customers AS c;

-- "c" is now a shorthand for "customers"
-- "c.customer_id" means "the customer_id column from the customers table"


-- ── Query 25: Alias in ORDER BY ─────────────────────────────
-- You CAN use an alias in ORDER BY (but NOT in WHERE)
-- This works because ORDER BY runs AFTER SELECT

SELECT 
    first_name    AS name,
    salary        AS monthly_pay
FROM employees
ORDER BY monthly_pay DESC;   -- ← alias works here!


-- ============================================================
-- SECTION 6: COMBINING EVERYTHING
-- ============================================================

-- ── Query 26: WHERE + ORDER BY + LIMIT ──────────────────────
-- Business question: "Who are the top 2 highest-balance SAVINGS accounts?"
-- Step 1: FROM accounts
-- Step 2: WHERE account_type = 'Savings'   → filter savings only
-- Step 3: ORDER BY balance DESC            → highest first
-- Step 4: LIMIT 2                          → top 2 only

SELECT 
    account_id, 
    customer_id, 
    balance AS current_balance
FROM accounts
WHERE account_type = 'Savings'
ORDER BY balance DESC
LIMIT 2;


-- ── Query 27: WHERE + DISTINCT ──────────────────────────────
-- Which cities have ACTIVE Citi customers?

SELECT DISTINCT city
FROM customers
WHERE is_active = TRUE
ORDER BY city ASC;


-- ── Query 28: Real Citi Scenario — Fraud Investigation ──────
-- Fraud team asks: "Show me the 5 largest DEBIT transactions,
-- most recent first"

SELECT 
    transaction_id,
    account_id,
    amount          AS "Transaction Amount",
    transaction_date AS "Date & Time",
    description
FROM transactions
WHERE transaction_type = 'DEBIT'
ORDER BY amount DESC, transaction_date DESC
LIMIT 5;


-- ============================================================
-- 🧠 MENTOR NOTES — SQL Execution Order
-- ============================================================
--
-- SQL DOES NOT run in the order you write it!
-- Actual execution order:
--
-- 1. FROM        → Which table to use?
-- 2. WHERE       → Filter the rows
-- 3. SELECT      → Choose columns
-- 4. DISTINCT    → Remove duplicates
-- 5. ORDER BY    → Sort
-- 6. LIMIT       → Return n rows
--
-- Interview Question: "Why can't you use a column alias in WHERE?"
-- Answer: Because WHERE (step 2) runs BEFORE SELECT (step 3).
--         The alias doesn't exist yet when WHERE is evaluated!
--
-- Example of a WRONG query:
-- SELECT salary * 12 AS annual_salary
-- FROM employees
-- WHERE annual_salary > 1000000;  ← ERROR! alias not yet defined
--
-- Correct version:
-- SELECT salary * 12 AS annual_salary
-- FROM employees
-- WHERE salary * 12 > 1000000;   ← repeat the expression in WHERE
--
-- ============================================================
