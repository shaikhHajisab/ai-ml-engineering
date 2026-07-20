# 🎯 Day 02 — Interview Questions
## WHERE, ORDER BY, LIMIT, DISTINCT, Aliases | Citi Bank Data Engineering

---

## 📌 Interview Question 1

**"In what order does SQL execute its clauses?"**

### Expected Answer:
> SQL does NOT execute in the order you write it. The actual execution order is:
> 1. `FROM` — identify the table
> 2. `WHERE` — filter rows
> 3. `SELECT` — choose columns
> 4. `DISTINCT` — deduplicate
> 5. `ORDER BY` — sort
> 6. `LIMIT` — cap results

### Why interviewers ask this:
> It tests whether you truly understand SQL vs. just memorizing syntax.

### Follow-up Question 1:
**"Why can't you use a column alias in a WHERE clause?"**
> Because `WHERE` runs in step 2, before `SELECT` (step 3). The alias is created in SELECT, so it doesn't exist yet when WHERE is evaluated. You must repeat the expression.

```sql
-- WRONG:
SELECT salary * 12 AS annual_salary
FROM employees
WHERE annual_salary > 1000000;   -- ❌ alias doesn't exist here

-- CORRECT:
SELECT salary * 12 AS annual_salary
FROM employees
WHERE salary * 12 > 1000000;    -- ✅ repeat the expression
```

### Follow-up Question 2:
**"Can you use an alias in ORDER BY?"**
> Yes! ORDER BY runs AFTER SELECT, so the alias is already defined and can be used.

---

## 📌 Interview Question 2

**"What is the difference between WHERE and HAVING?"**

### Expected Answer:
> `WHERE` filters rows BEFORE aggregation (before GROUP BY is applied).  
> `HAVING` filters rows AFTER aggregation (after GROUP BY is applied).
>
> Use `WHERE` for row-level conditions.  
> Use `HAVING` for aggregate conditions (like `COUNT > 5` or `SUM > 100000`).

### Banking Example:
```sql
-- WHERE: filter individual transactions before grouping
SELECT account_id, SUM(amount)
FROM transactions
WHERE transaction_type = 'DEBIT'    -- ← filters rows first
GROUP BY account_id;

-- HAVING: filter groups after aggregation
SELECT account_id, SUM(amount) AS total_spent
FROM transactions
GROUP BY account_id
HAVING SUM(amount) > 100000;        -- ← filters aggregated groups
```

### Follow-up Question 1:
**"Can you use both WHERE and HAVING in the same query?"**
> Yes! WHERE filters rows first, then GROUP BY groups them, then HAVING filters the groups.

### Follow-up Question 2:
**"What happens if you put an aggregate function in WHERE?"**
> You get an error. Aggregate functions like `COUNT()`, `SUM()`, `AVG()` cannot be used in WHERE. They must go in HAVING.

---

## 📌 Interview Question 3 (Bonus)

**"What is the difference between DISTINCT and GROUP BY?"**

### Expected Answer:
> Both can return unique values, but:
> - `DISTINCT` simply deduplicates the selected columns — no aggregation
> - `GROUP BY` groups rows so you can apply aggregate functions (COUNT, SUM, etc.)
>
> For just getting unique values: use `DISTINCT`.  
> For unique values WITH aggregate calculations: use `GROUP BY`.

```sql
-- DISTINCT: unique cities only
SELECT DISTINCT city FROM customers;

-- GROUP BY: unique cities WITH count
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;
```

---

## 📌 Interview Question 4 (Scenario-based)

**"A fraud analyst wants to find the 5 most suspicious transactions — those are DEBIT transactions above ₹1,00,000 made at night (we'll say transaction_date as timestamp). How would you write this query?"**

### Expected Answer:
```sql
SELECT 
    transaction_id,
    account_id,
    amount,
    transaction_date,
    description
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount > 100000
ORDER BY amount DESC, transaction_date DESC
LIMIT 5;
```

> Mention: In a real Citi system, you'd also add time filtering, join with account and customer tables, and potentially use window functions to rank transactions per account.

---

## 🏆 Pro Tips for Citi Day 02 Interviews

1. **Always mention execution order** when asked about WHERE/HAVING/aliases — it shows depth
2. **Use Aliases in your answers** — interviewers are impressed when your query output is clean and readable
3. **Mention LIMIT concerns**: In production, LIMIT without ORDER BY is non-deterministic (you might get different rows each time) — always pair them
4. **Know both syntaxes**: `LIMIT n` (PostgreSQL/MySQL) vs `TOP n` (SQL Server) vs `FETCH FIRST n ROWS ONLY` (Oracle/DB2 — Citi uses these!)
