# 🏦 SQL for Data Engineering — Citi Bank Coding Workshop

> **Mentor:** Senior Data Engineer @ Citi Bank  
> **Goal:** SQL from beginner to advanced for Data Engineering interviews  
> **Target:** Citi Bank Data Engineering Coding Workshop

---

## 📋 Roadmap Progress

| Day | Topic | Status |
|-----|-------|--------|
| Day 01 | Introduction — Database, DBMS, RDBMS, SQL, CREATE TABLE, INSERT, SELECT | ✅ Done |
| Day 02 | WHERE, ORDER BY, LIMIT, DISTINCT, Aliases | ✅ Done |
| Day 03 | Comparison & Logical Operators, IN, BETWEEN, LIKE, IS NULL | ✅ Done |
| Day 04 | Aggregate Functions — COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING | ✅ Done |
| Day 05 | JOINs — INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS | 🔜 Next |
| Day 06 | Subqueries, Correlated Subqueries, EXISTS, ANY, ALL | 📅 |
| Day 07 | CASE WHEN, COALESCE, NULLIF, String & Date Functions | 📅 |
| Day 08 | Window Functions — ROW_NUMBER, RANK, LEAD, LAG, NTILE | 📅 |
| Day 09 | CTEs, Recursive CTEs, Views, Indexes | 📅 |
| Day 10 | Stored Procedures, Triggers, Transactions, ACID, Normalization | 📅 |
| Day 11 | Advanced SQL Problems | 📅 |
| Day 12 | Complete Banking SQL Project | 📅 |

---

## 🏛️ Banking Database Schema

```
customers
    customer_id (PK) ── first_name, last_name, email, city, date_of_birth, is_active

accounts
    account_id (PK) ── customer_id (FK→customers), account_type, balance, opened_date

transactions
    transaction_id (PK) ── account_id (FK→accounts), transaction_type, amount, transaction_date, description

loans
    loan_id (PK) ── customer_id (FK→customers), loan_type, principal_amount, interest_rate, loan_start_date, loan_end_date, status

employees
    employee_id (PK) ── first_name, last_name, department, salary, hire_date, branch_id (FK→branches)

branches
    branch_id (PK) ── branch_name, city, state, is_open
```

---

## 📁 Each Day Contains

| File | Content |
|------|---------|
| `README.md` | Day overview and checklist |
| `notes.md` | Full lesson — concepts, syntax, visuals, cheat sheet |
| `queries.sql` | 20–30 working SQL examples with line-by-line comments |
| `practice.sql` | 8 practice questions (3 Easy + 3 Medium + 2 Hard) |
| `solutions.sql` | Solutions — open only AFTER attempting |
| `interview_questions.md` | Citi interview Q&A with banking examples |

---

## 🎯 Teaching Philosophy

> *"Think before you write SQL."*

Every query follows this mental checklist:
1. Which **TABLE** has the data?
2. Which **COLUMNS** do I need?
3. What is the **FILTER** condition? (WHERE)
4. Is there **GROUPING** needed? (GROUP BY)
5. Is there an **AGGREGATE FILTER**? (HAVING)
6. What **SORT ORDER** is needed? (ORDER BY)
7. Do I need a **JOIN**? (Day 05+)

---

## 🔑 Key Interview Concepts Covered

- PK vs FK and referential integrity
- DECIMAL vs FLOAT for financial data
- SQL execution order (FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY→LIMIT)
- WHERE vs HAVING
- COUNT(*) vs COUNT(col) vs COUNT(DISTINCT col)
- NULL handling — IS NULL, NOT IN trap, AVG with NULLs
- LIKE wildcards and performance (`'A%'` vs `'%A%'`)
- GROUP BY golden rule

---

*Built with real Citi Bank banking scenarios: customers, accounts, transactions, loans, branches, employees*
