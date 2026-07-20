-- ============================================================
-- 🏦 SQL Day 01 — SOLUTIONS
-- ⚠️ DO NOT OPEN UNTIL YOU HAVE ATTEMPTED ALL PRACTICE QUESTIONS ⚠️
-- ============================================================


-- ── Easy 1 Solution ──────────────────────────────────────────
CREATE TABLE branches (
    branch_id    INT          PRIMARY KEY,
    branch_name  VARCHAR(100) NOT NULL,
    city         VARCHAR(50),
    state        VARCHAR(50),
    is_open      BOOLEAN      DEFAULT TRUE
);


-- ── Easy 2 Solution ──────────────────────────────────────────
INSERT INTO branches (branch_id, branch_name, city, state, is_open)
VALUES
    (101, 'Citi Mumbai Main',        'Mumbai',    'Maharashtra', TRUE),
    (102, 'Citi Delhi Connaught',    'Delhi',     'Delhi',       TRUE),
    (103, 'Citi Bangalore MG Road',  'Bangalore', 'Karnataka',   TRUE);


-- ── Easy 3 Solution ──────────────────────────────────────────
SELECT *
FROM branches;


-- ── Medium 1 Solution ────────────────────────────────────────
CREATE TABLE employees (
    employee_id  INT            PRIMARY KEY,
    first_name   VARCHAR(50)    NOT NULL,
    last_name    VARCHAR(50)    NOT NULL,
    department   VARCHAR(50),
    salary       DECIMAL(10,2),
    hire_date    DATE,
    branch_id    INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);


-- ── Medium 2 Solution ────────────────────────────────────────
INSERT INTO employees (employee_id, first_name, last_name, department, salary, hire_date, branch_id)
VALUES
    (201, 'Meera', 'Patel', 'Data Engineering', 95000.00,  '2022-03-15', 101),
    (202, 'Karan', 'Joshi', 'Risk',             78000.00,  '2021-07-01', 102),
    (203, 'Zara',  'Ahmed', 'Fraud',            85000.00,  '2023-01-10', 103),
    (204, 'Rohan', 'Gupta', 'Data Engineering', 110000.00, '2020-09-20', 101);


-- ── Medium 3 Solution ────────────────────────────────────────
SELECT first_name, department, salary
FROM employees;


-- ── Hard 1 Solution ──────────────────────────────────────────
CREATE TABLE loans (
    loan_id           INT            PRIMARY KEY,
    customer_id       INT            NOT NULL,
    loan_type         VARCHAR(30),
    principal_amount  DECIMAL(15,2),
    interest_rate     DECIMAL(5,2),
    loan_start_date   DATE           NOT NULL,
    loan_end_date     DATE,
    status            VARCHAR(20)    DEFAULT 'ACTIVE',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- ── Hard 2 Solution ──────────────────────────────────────────
INSERT INTO loans (loan_id, customer_id, loan_type, principal_amount, interest_rate, loan_start_date, loan_end_date, status)
VALUES
    (5001, 1001, 'Home',     5000000.00,  7.50, '2020-06-01', '2040-06-01', 'ACTIVE'),
    (5002, 1002, 'Auto',      800000.00,  9.25, '2022-03-15', '2027-03-15', 'ACTIVE'),
    (5003, 1003, 'Personal',  200000.00, 12.00, '2023-01-10', '2026-01-10', 'ACTIVE');

SELECT loan_id, loan_type, principal_amount, status
FROM loans;
