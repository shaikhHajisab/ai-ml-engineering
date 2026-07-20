-- ============================================================
-- 🏦 SQL Day 01 — PRACTICE FILE
-- Write YOUR answers here. I will review them.
-- ============================================================
-- INSTRUCTIONS:
-- 1. Read each question carefully
-- 2. Think before writing (see PART 10 in notes.md)
-- 3. Write your SQL below each question
-- 4. Do NOT look at solutions.sql until you attempt ALL questions
-- ============================================================


-- ============================================================
-- 🟢 EASY QUESTIONS (3)
-- ============================================================

-- ── Easy 1 ───────────────────────────────────────────────────
-- Create a table called `branches` for Citi Bank.
-- It should have:
--   - branch_id     (whole number, primary key)
--   - branch_name   (text, required, max 100 characters)
--   - city          (text, max 50 characters)
--   - state         (text, max 50 characters)
--   - is_open       (boolean, default TRUE)

-- YOUR SQL HERE:




-- ── Easy 2 ───────────────────────────────────────────────────
-- Insert 3 branches into the `branches` table:
--   Branch 1: 101, 'Citi Mumbai Main', 'Mumbai', 'Maharashtra', TRUE
--   Branch 2: 102, 'Citi Delhi Connaught', 'Delhi', 'Delhi', TRUE
--   Branch 3: 103, 'Citi Bangalore MG Road', 'Bangalore', 'Karnataka', TRUE

-- YOUR SQL HERE:




-- ── Easy 3 ───────────────────────────────────────────────────
-- Select ALL columns from the `branches` table.

-- YOUR SQL HERE:




-- ============================================================
-- 🟡 MEDIUM QUESTIONS (3)
-- ============================================================

-- ── Medium 1 ─────────────────────────────────────────────────
-- Create a table called `employees` for Citi Bank employees.
-- It should have:
--   - employee_id   (whole number, primary key)
--   - first_name    (text, required, max 50 chars)
--   - last_name     (text, required, max 50 chars)
--   - department    (text, max 50 chars) — e.g. 'Data Engineering', 'Risk', 'Fraud'
--   - salary        (decimal, 10 digits total, 2 decimal places)
--   - hire_date     (date)
--   - branch_id     (whole number, foreign key referencing branches table)

-- YOUR SQL HERE:




-- ── Medium 2 ─────────────────────────────────────────────────
-- Insert 4 employees:
--   Emp 1: 201, 'Meera', 'Patel',  'Data Engineering', 95000.00, '2022-03-15', 101
--   Emp 2: 202, 'Karan', 'Joshi',  'Risk',             78000.00, '2021-07-01', 102
--   Emp 3: 203, 'Zara',  'Ahmed',  'Fraud',            85000.00, '2023-01-10', 103
--   Emp 4: 204, 'Rohan', 'Gupta',  'Data Engineering', 110000.00, '2020-09-20', 101

-- YOUR SQL HERE:




-- ── Medium 3 ─────────────────────────────────────────────────
-- Select only the first_name, department, and salary columns
-- from the employees table.

-- YOUR SQL HERE:




-- ============================================================
-- 🔴 HARD QUESTIONS (2)
-- ============================================================

-- ── Hard 1 ───────────────────────────────────────────────────
-- Create a `loans` table for Citi Bank loan records.
-- Requirements:
--   - loan_id         (whole number, primary key)
--   - customer_id     (whole number, NOT NULL, foreign key → customers)
--   - loan_type       (text, max 30 chars) — 'Home', 'Auto', 'Personal', 'Education'
--   - principal_amount (decimal, 15 digits, 2 decimal places)
--   - interest_rate   (decimal, 5 digits total, 2 decimal places) — e.g. 8.50
--   - loan_start_date (date, NOT NULL)
--   - loan_end_date   (date)
--   - status          (text, max 20 chars, default 'ACTIVE') — 'ACTIVE', 'CLOSED', 'DEFAULTED'

-- YOUR SQL HERE:




-- ── Hard 2 ───────────────────────────────────────────────────
-- Insert 3 loan records using the customers already in the database:
--   Loan 1: 5001, customer 1001 (Ayesha), 'Home',     5000000.00, 7.50, '2020-06-01', '2040-06-01', 'ACTIVE'
--   Loan 2: 5002, customer 1002 (Ravi),   'Auto',      800000.00, 9.25, '2022-03-15', '2027-03-15', 'ACTIVE'
--   Loan 3: 5003, customer 1003 (Priya),  'Personal',  200000.00, 12.00, '2023-01-10', '2026-01-10', 'ACTIVE'
-- 
-- Then select the loan_id, loan_type, principal_amount, and status from the loans table.

-- YOUR SQL HERE:




-- ============================================================
-- ✅ WHEN DONE:
-- Submit your answers and I (your mentor) will review them.
-- I will check: syntax, logic, naming conventions, best practices.
-- ============================================================
