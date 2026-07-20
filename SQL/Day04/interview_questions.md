# 🎯 Day 04 — Interview Questions
## COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING | Citi Bank Data Engineering

---

## 📌 Interview Question 1

**"What is the difference between WHERE and HAVING?"**

### Expected Answer:
> - `WHERE` filters **individual rows** BEFORE grouping — it cannot use aggregate functions.
> - `HAVING` filters **groups** AFTER `GROUP BY` — it CAN use aggregate functions.
>
> Execution order: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

```sql
-- WHERE filters rows before grouping
SELECT department, AVG(salary)
FROM employees
WHERE hire_date > '2020-01-01'     -- ← filters rows
GROUP BY department
HAVING AVG(salary) > 80000;        -- ← filters groups
```

### Follow-up 1:
**"Can you use both WHERE and HAVING in the same query?"**
> Yes! WHERE filters rows first, GROUP BY groups them, then HAVING filters the resulting groups.

### Follow-up 2:
**"What happens if you put an aggregate function in WHERE?"**
> SQL throws an error: `"aggregate functions are not allowed in WHERE"`.
> Aggregate functions can only appear in SELECT, HAVING, and ORDER BY.

---

## 📌 Interview Question 2

**"What is the difference between COUNT(*), COUNT(column), and COUNT(DISTINCT column)?"**

### Expected Answer:
| Function | Counts | Includes NULLs? |
|----------|--------|----------------|
| `COUNT(*)` | All rows | ✅ Yes |
| `COUNT(column)` | Non-NULL values in column | ❌ No |
| `COUNT(DISTINCT column)` | Unique non-NULL values | ❌ No |

```sql
-- Table has 5 rows, 1 email is NULL, cities: Mumbai, Mumbai, Delhi, Bangalore, Chennai

COUNT(*)              = 5   -- all rows
COUNT(email)          = 4   -- skips 1 NULL
COUNT(DISTINCT city)  = 4   -- unique cities (Mumbai counted once)
```

### Follow-up 1:
**"In what scenario would COUNT(*) and COUNT(column) return different values?"**
> When the column has NULL values. `COUNT(col)` skips NULLs, `COUNT(*)` does not. This matters for KYC completeness reports where missing email/phone tells a different story than total customer count.

### Follow-up 2:
**"Does AVG() include NULLs in its calculation?"**
> No — `AVG()` ignores NULLs completely. It sums only non-NULL values and divides by the count of non-NULL rows. This can make AVG appear higher than expected if there are many NULLs.

---

## 📌 Interview Question 3 (Scenario)

**"Write a query to find all departments at Citi where the average salary is above ₹80,000. Show the department name, number of employees, and average salary."**

### Expected Answer:
```sql
SELECT department,
       COUNT(*)    AS headcount,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 80000
ORDER BY avg_salary DESC;
```

> **Key points to explain:**
> - `GROUP BY department` groups all employees by their department
> - `HAVING AVG(salary) > 80000` filters groups (not rows!) — can't use WHERE here
> - Every column in SELECT that isn't an aggregate (`department`) must be in GROUP BY

---

## 📌 Interview Question 4

**"What is the GROUP BY rule? Give an example of a mistake."**

### Expected Answer:
> The GROUP BY rule: **every column in SELECT that is NOT inside an aggregate function MUST appear in GROUP BY.**

```sql
-- ❌ WRONG — first_name is in SELECT but not in GROUP BY:
SELECT city, first_name, COUNT(*)
FROM customers
GROUP BY city;
-- ERROR: first_name is not in GROUP BY

-- ✅ CORRECT:
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

-- ✅ ALSO CORRECT (both non-aggregates in GROUP BY):
SELECT city, is_active, COUNT(*) AS count
FROM customers
GROUP BY city, is_active;
```

---

## 📌 Interview Question 5 (Write the Query)

**"Citi wants a fraud report: find all accounts where the total DEBIT amount exceeds ₹50,000. Show account_id, number of debit transactions, and total debit amount."**

### Expected Answer:
```sql
SELECT account_id,
       COUNT(*)    AS debit_count,
       SUM(amount) AS total_debited
FROM transactions
WHERE transaction_type = 'DEBIT'       -- filter rows first
GROUP BY account_id
HAVING SUM(amount) > 50000             -- filter groups after
ORDER BY total_debited DESC;
```

---

## 🏆 Pro Tips for Citi Day 04 Interviews

1. **Always state the execution order** when explaining GROUP BY / HAVING
2. **Distinguish COUNT variants** — interviewers always test COUNT(*) vs COUNT(col)
3. **WHERE before, HAVING after** — say this phrase in the interview
4. **GROUP BY completeness** — mention the rule that every non-aggregate column must appear in GROUP BY
5. **Connect to business context** — "In Citi's daily reconciliation, we use GROUP BY transaction_type with SUM to verify debit/credit balance..."
