-- ============================================================
-- 🏦 SQL Day 01 — Core Queries (Citi Bank Banking Database)
-- Mentor: Senior Data Engineer @ Citi
-- Topic: CREATE TABLE, INSERT, SELECT
-- ============================================================
-- HOW TO READ THIS FILE:
-- Read each block top to bottom.
-- Every line is explained with a comment.
-- Run each block one at a time in your SQL tool (DB Browser, pgAdmin, etc.)
-- ============================================================


-- ============================================================
-- STEP 1: CREATE THE CUSTOMERS TABLE
-- ============================================================

-- "CREATE TABLE" tells the database: make a new table
-- "customers"    is the name we are giving to this table
-- The parentheses () contain the column definitions

CREATE TABLE customers (

    -- customer_id: A whole number (INTEGER) that uniquely identifies each customer
    -- PRIMARY KEY means: this column is the unique identifier — no duplicates, no NULLs
    customer_id    INT           PRIMARY KEY,

    -- first_name: Variable-length text, max 50 characters
    -- NOT NULL means: this field CANNOT be left empty
    first_name     VARCHAR(50)   NOT NULL,

    -- last_name: Same as first_name — text, max 50 characters, required
    last_name      VARCHAR(50)   NOT NULL,

    -- email: Text field, max 100 characters
    -- UNIQUE means: no two customers can have the same email
    email          VARCHAR(100)  UNIQUE,

    -- city: Text field, max 50 characters — can be NULL (optional)
    city           VARCHAR(50),

    -- date_of_birth: Stores only the date (no time) in YYYY-MM-DD format
    date_of_birth  DATE,

    -- is_active: Boolean — TRUE if customer account is active, FALSE if closed/suspended
    is_active      BOOLEAN       DEFAULT TRUE

    -- DEFAULT TRUE means: if we don't specify, assume the customer is active
);


-- ============================================================
-- STEP 2: CREATE THE ACCOUNTS TABLE
-- ============================================================

-- This table stores bank account information
-- Each customer can have MULTIPLE accounts (checking, savings, etc.)

CREATE TABLE accounts (

    -- account_id: Unique identifier for each bank account
    account_id     INT           PRIMARY KEY,

    -- customer_id: This REFERENCES the customers table
    -- It is a FOREIGN KEY — it links each account to its owner
    -- Every customer_id here must exist in the customers table
    customer_id    INT           NOT NULL,

    -- account_type: What kind of account — Savings, Checking, Loan, etc.
    account_type   VARCHAR(20)   NOT NULL,

    -- balance: The current money in the account
    -- DECIMAL(15, 2) = up to 15 digits total, 2 decimal places (e.g., 99999999999.99)
    -- Never use FLOAT for money — it has rounding errors!
    balance        DECIMAL(15,2) DEFAULT 0.00,

    -- opened_date: When the account was created
    opened_date    DATE          NOT NULL,

    -- FOREIGN KEY constraint: Links customer_id in this table to customer_id in customers
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- ============================================================
-- STEP 3: CREATE THE TRANSACTIONS TABLE
-- ============================================================

-- This table records every single financial transaction at Citi
-- In real Citi systems, this table can have BILLIONS of rows

CREATE TABLE transactions (

    -- transaction_id: Unique ID for each transaction
    transaction_id   INT             PRIMARY KEY,

    -- account_id: Which account this transaction belongs to
    account_id       INT             NOT NULL,

    -- transaction_type: CREDIT (money in) or DEBIT (money out)
    transaction_type VARCHAR(10)     NOT NULL,

    -- amount: How much money was moved
    amount           DECIMAL(15,2)   NOT NULL,

    -- transaction_date: TIMESTAMP includes date AND time (important for fraud detection)
    transaction_date TIMESTAMP       NOT NULL,

    -- description: What was this transaction for
    description      VARCHAR(200),

    -- FOREIGN KEY links this to the accounts table
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


-- ============================================================
-- STEP 4: INSERT DATA INTO customers
-- ============================================================

-- "INSERT INTO customers" = We are adding rows to the customers table
-- "(customer_id, first_name, ...)" = these are the columns we are filling
-- "VALUES" = here come the actual data values
-- Each set of () is ONE row

INSERT INTO customers (customer_id, first_name, last_name, email, city, date_of_birth, is_active)
VALUES
    -- Row 1: Ayesha Khan, Mumbai customer, active
    (1001, 'Ayesha',  'Khan',   'ayesha.khan@citi.com',   'Mumbai',    '1990-05-14', TRUE),

    -- Row 2: Ravi Sharma, Delhi customer, active
    (1002, 'Ravi',    'Sharma', 'ravi.sharma@citi.com',   'Delhi',     '1985-11-23', TRUE),

    -- Row 3: Priya Nair, Bangalore customer, active
    (1003, 'Priya',   'Nair',   'priya.nair@citi.com',    'Bangalore', '1995-03-08', TRUE),

    -- Row 4: Ahmed Sheikh, Hyderabad customer, INACTIVE (account closed)
    (1004, 'Ahmed',   'Sheikh', 'ahmed.sheikh@citi.com',  'Hyderabad', '1992-07-19', FALSE),

    -- Row 5: Sunita Mehta, Chennai customer, active
    (1005, 'Sunita',  'Mehta',  'sunita.mehta@citi.com',  'Chennai',   '1988-12-01', TRUE);


-- ============================================================
-- STEP 5: INSERT DATA INTO accounts
-- ============================================================

INSERT INTO accounts (account_id, customer_id, account_type, balance, opened_date)
VALUES
    -- Ayesha has a Savings account with 250,000 balance
    (2001, 1001, 'Savings',  250000.00, '2018-03-01'),

    -- Ravi has a Checking account
    (2002, 1002, 'Checking',  85000.50, '2019-07-15'),

    -- Priya has a Savings account
    (2003, 1003, 'Savings',  175000.00, '2020-01-10'),

    -- Ayesha ALSO has a Checking account (one customer, two accounts!)
    (2004, 1001, 'Checking',  42000.75, '2021-06-22'),

    -- Ahmed has a Savings account (even though his customer account is inactive)
    (2005, 1004, 'Savings',       0.00, '2017-09-30'),

    -- Sunita has a Savings account
    (2006, 1005, 'Savings',  500000.00, '2016-12-05');


-- ============================================================
-- STEP 6: INSERT DATA INTO transactions
-- ============================================================

INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, transaction_date, description)
VALUES
    -- Credit: salary deposited into Ayesha's savings
    (3001, 2001, 'CREDIT', 50000.00, '2024-01-01 09:00:00', 'Salary Credit'),

    -- Debit: Ayesha paid her rent
    (3002, 2001, 'DEBIT',  25000.00, '2024-01-05 14:30:00', 'Rent Payment'),

    -- Credit: Ravi received money transfer
    (3003, 2002, 'CREDIT', 15000.00, '2024-01-10 11:00:00', 'NEFT Transfer Received'),

    -- Debit: Ravi paid electricity bill
    (3004, 2002, 'DEBIT',   2500.00, '2024-01-12 16:45:00', 'Electricity Bill'),

    -- Credit: Priya received freelance payment
    (3005, 2003, 'CREDIT', 30000.00, '2024-01-15 10:00:00', 'Freelance Income'),

    -- Large debit from Sunita — suspicious? Fraud team would flag this
    (3006, 2006, 'DEBIT', 200000.00, '2024-01-20 02:15:00', 'Wire Transfer');


-- ============================================================
-- STEP 7: SELECT QUERIES — Reading Data
-- ============================================================

-- ── Query 1: Get EVERYTHING from customers ──────────────────
-- "*" means "all columns"
-- This returns every row and every column in the table

SELECT *
FROM customers;


-- ── Query 2: Select SPECIFIC columns only ───────────────────
-- Instead of *, we name only the columns we want
-- This is better practice — only fetch what you need!

SELECT first_name, last_name, city
FROM customers;


-- ── Query 3: Select from accounts ───────────────────────────
-- Shows all bank accounts and their balances

SELECT *
FROM accounts;


-- ── Query 4: Select specific account info ───────────────────

SELECT account_id, account_type, balance
FROM accounts;


-- ── Query 5: Select all transactions ────────────────────────

SELECT *
FROM transactions;


-- ── Query 6: Select only transaction type and amount ────────

SELECT transaction_id, transaction_type, amount, description
FROM transactions;


-- ============================================================
-- 🧠 MENTOR NOTES:
-- ============================================================
--
-- Q: Why name columns instead of using SELECT *?
-- A: In production, tables can have 50+ columns.
--    SELECT * fetches all of them — slow and wasteful.
--    Always name what you need in interviews and real work.
--
-- Q: Why use DECIMAL(15,2) for money?
-- A: FLOAT has rounding errors (0.1 + 0.2 ≠ 0.3 in floating point).
--    DECIMAL is exact. Banks CANNOT afford rounding errors.
--
-- Q: Why is customer_id 1001 appearing in accounts twice?
-- A: One customer can have MANY accounts.
--    The FK allows this — it just means customer_id 1001 owns both account 2001 and 2004.
--    This is a one-to-many relationship.
--
-- ============================================================
