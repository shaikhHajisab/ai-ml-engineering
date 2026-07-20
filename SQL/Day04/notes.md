# 📓 Day 04 — Complete Notes
## Aggregate Functions: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING

---

# PART 1 — CONCEPT

---

## What Are Aggregate Functions?

Aggregate functions **collapse many rows into a single value**.

```
Without aggregate:   SELECT amount FROM transactions   → returns every single row
With aggregate:      SELECT SUM(amount) FROM transactions → returns ONE number (total)
```

They answer business questions like:
- *"How much total money moved through Citi today?"*
- *"What is the average loan amount?"*
- *"How many customers are in each city?"*
- *"Which account has the highest balance?"*

### Real-World Citi Use:
| Business Question | Aggregate |
|-------------------|-----------|
| Total transactions today | `SUM(amount)` |
| Number of defaulted loans | `COUNT(*)` |
| Average salary by dept | `AVG(salary)` |
| Largest single transaction | `MAX(amount)` |
| Minimum account balance | `MIN(balance)` |
| Customers per city | `COUNT(*) GROUP BY city` |

---

## 1️⃣ COUNT()

### What it is:
Counts the number of rows that match a condition.

### Variants:
```sql
COUNT(*)         -- count ALL rows (including NULLs)
COUNT(column)    -- count rows where column is NOT NULL
COUNT(DISTINCT column) -- count unique non-NULL values
```

### Key difference:
```
customers table has 5 rows, but email column has 1 NULL

COUNT(*)      = 5   ← counts all rows
COUNT(email)  = 4   ← skips the NULL row
COUNT(DISTINCT city) = 5  ← counts unique cities
```

### Citi Interview Trap:
> *"What is the difference between COUNT(*) and COUNT(column_name)?"*
> - `COUNT(*)` counts ALL rows including NULLs
> - `COUNT(col)` counts only NON-NULL values in that column

---

## 2️⃣ SUM()

### What it is:
Adds up all values in a numeric column.

```sql
SELECT SUM(amount) FROM transactions;
-- Returns the total of all transaction amounts
```

### Important:
- `SUM()` ignores NULLs automatically
- Only works on numeric columns (INT, DECIMAL, FLOAT)

### Citi Use:
```sql
-- Total loan portfolio value
SELECT SUM(principal_amount) FROM loans WHERE status = 'ACTIVE';

-- Total DEBIT amount today
SELECT SUM(amount) FROM transactions WHERE transaction_type = 'DEBIT';
```

---

## 3️⃣ AVG()

### What it is:
Calculates the average (mean) of a numeric column.

```sql
SELECT AVG(balance) FROM accounts;
-- Returns the average balance across all accounts
```

### Important:
- `AVG()` ignores NULLs (does NOT count them in the denominator!)
- This can give misleading results if NULLs represent "zero"

### Citi Use:
```sql
-- Average transaction amount (fraud baseline)
SELECT AVG(amount) FROM transactions;

-- Average salary by department
SELECT department, AVG(salary) FROM employees GROUP BY department;
```

---

## 4️⃣ MIN() and MAX()

### What they are:
- `MIN()` — returns the smallest value in the column
- `MAX()` — returns the largest value in the column

### Works on numbers, dates, and text (alphabetical for text):
```sql
SELECT MIN(balance) FROM accounts;            -- lowest balance
SELECT MAX(amount)  FROM transactions;        -- largest transaction
SELECT MIN(hire_date) FROM employees;         -- earliest hire date
SELECT MAX(loan_end_date) FROM loans;         -- latest loan end date
```

### Citi Use:
```sql
-- Fraud: what is the largest single transaction ever?
SELECT MAX(amount) FROM transactions;

-- When was the first account ever opened at our branch?
SELECT MIN(opened_date) FROM accounts;
```

---

## 5️⃣ GROUP BY

### What it is:
`GROUP BY` divides rows into groups based on one or more columns,
then aggregate functions are applied **per group**.

### Without GROUP BY:
```sql
SELECT SUM(amount) FROM transactions;
-- Returns ONE total: sum of ALL transactions
```

### With GROUP BY:
```sql
SELECT account_id, SUM(amount)
FROM transactions
GROUP BY account_id;
-- Returns ONE row PER account with that account's total
```

### The Golden Rule of GROUP BY:
> **Every column in SELECT that is NOT inside an aggregate function MUST appear in GROUP BY.**

```sql
-- ✅ CORRECT:
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;               -- city is in both SELECT and GROUP BY

-- ❌ WRONG (will give error):
SELECT city, first_name, COUNT(*)
FROM customers
GROUP BY city;
-- first_name is in SELECT but NOT in GROUP BY → ERROR!
-- SQL doesn't know WHICH first_name to show for each city group
```

### Group By Multiple Columns:
```sql
SELECT department, city, COUNT(*) AS emp_count
FROM employees
GROUP BY department, city;
-- Groups by the COMBINATION of department + city
```

---

## 6️⃣ HAVING

### What it is:
`HAVING` filters groups AFTER aggregation — like `WHERE` but for groups.

### Why it exists:
You cannot use aggregate functions in `WHERE`.
```sql
-- WRONG: WHERE cannot use aggregate functions
SELECT account_id, SUM(amount)
FROM transactions
WHERE SUM(amount) > 50000   -- ❌ ERROR!
GROUP BY account_id;

-- CORRECT: use HAVING for aggregate filters
SELECT account_id, SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
HAVING SUM(amount) > 50000;  -- ✅ filters after grouping
```

### WHERE vs HAVING — The Most Common Interview Question:
```
WHERE  → filters ROWS before grouping  → cannot use aggregates
HAVING → filters GROUPS after grouping → can use aggregates

Execution order:
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

---

# PART 2 — SYNTAX

```sql
SELECT   column, AGGREGATE(column) AS alias
FROM     table_name
WHERE    condition              -- filter rows BEFORE grouping
GROUP BY column                -- group the filtered rows
HAVING   AGGREGATE(column) > value  -- filter groups AFTER aggregating
ORDER BY AGGREGATE(column) DESC     -- sort the grouped results
LIMIT    n;                    -- cap the output
```

### Full Execution Order (MEMORIZE THIS):
```
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY
8. LIMIT
```

---

# PART 4 — VISUAL EXPLANATION

## transactions table:

| transaction_id | account_id | transaction_type | amount |
|----------------|------------|-----------------|--------|
| 3001 | 2001 | CREDIT | 50000 |
| 3002 | 2001 | DEBIT  | 25000 |
| 3003 | 2002 | CREDIT | 15000 |
| 3004 | 2002 | DEBIT  |  2500 |
| 3005 | 2003 | CREDIT | 30000 |
| 3006 | 2006 | DEBIT  | 200000 |

---

### `SELECT COUNT(*) FROM transactions`:

| COUNT(*) |
|---------|
| 6 |

---

### `SELECT SUM(amount) FROM transactions`:

| SUM(amount) |
|------------|
| 322500 |

---

### `SELECT account_id, SUM(amount) FROM transactions GROUP BY account_id`:

| account_id | SUM(amount) |
|------------|------------|
| 2001 | 75000   ← 50000 + 25000 |
| 2002 | 17500   ← 15000 + 2500 |
| 2003 | 30000 |
| 2006 | 200000 |

---

### After `HAVING SUM(amount) > 50000`:

| account_id | SUM(amount) |
|------------|------------|
| 2001 | 75000 |
| 2006 | 200000 |

---

### employees table:

| employee_id | first_name | department        | salary |
|-------------|------------|-------------------|--------|
| 201 | Meera | Data Engineering | 95000 |
| 202 | Karan | Risk             | 78000 |
| 203 | Zara  | Fraud            | 85000 |
| 204 | Rohan | Data Engineering | 110000 |

### `SELECT department, COUNT(*), AVG(salary), MAX(salary) GROUP BY department`:

| department | COUNT(*) | AVG(salary) | MAX(salary) |
|------------|---------|-------------|-------------|
| Data Engineering | 2 | 102500 | 110000 |
| Risk | 1 | 78000 | 78000 |
| Fraud | 1 | 85000 | 85000 |

---

# PART 9 — REVISION

## 🔑 Key Takeaways

1. Aggregate functions collapse many rows into ONE summary value
2. `COUNT(*)` counts all rows; `COUNT(col)` skips NULLs; `COUNT(DISTINCT col)` counts unique values
3. `SUM()`, `AVG()`, `MIN()`, `MAX()` — all ignore NULLs automatically
4. Every non-aggregate SELECT column **MUST** appear in GROUP BY
5. `WHERE` filters rows **before** grouping; `HAVING` filters groups **after** grouping
6. You CANNOT use aggregate functions in WHERE — use HAVING
7. Full execution order: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

## 📋 Cheat Sheet

```sql
-- Simple aggregates
SELECT COUNT(*), SUM(amount), AVG(amount), MIN(amount), MAX(amount)
FROM transactions;

-- Group by one column
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Group by + HAVING
SELECT account_id, SUM(amount) AS total
FROM transactions
GROUP BY account_id
HAVING SUM(amount) > 50000;

-- WHERE + GROUP BY + HAVING (combined)
SELECT department, AVG(salary) AS avg_sal
FROM employees
WHERE is_active = TRUE           -- filter rows first
GROUP BY department              -- then group
HAVING AVG(salary) > 80000       -- then filter groups
ORDER BY avg_sal DESC;
```

## 🧠 Memory Tricks

| Concept | Trick |
|---------|-------|
| GROUP BY rule | "If it's in SELECT without an aggregate → it MUST be in GROUP BY" |
| WHERE vs HAVING | "WHERE = before cooking; HAVING = after cooking, taste the dish" |
| COUNT(*) vs COUNT(col) | "* counts everything; column name skips the empty plates (NULLs)" |
| AVG ignores NULL | "AVG doesn't count absent students — only those present" |
| Execution order | "FROM → WHERE → GROUP → HAVING → SELECT → ORDER → LIMIT" |

> **Next:** Day 05 — JOINs (INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS)
