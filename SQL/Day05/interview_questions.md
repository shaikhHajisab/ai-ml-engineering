# 🎯 Day 05 — Interview Questions
## JOINs | Citi Bank Data Engineering

---

## 📌 Interview Question 1

**"What is the difference between INNER JOIN and LEFT JOIN?"**

### Expected Answer:
> - `INNER JOIN` returns only the rows that have a **matching value in both tables**. Rows with no match are excluded from both sides.
> - `LEFT JOIN` returns **ALL rows from the left table**. If a matching row exists in the right table, its values appear; if not, the right-side columns are `NULL`.

```sql
-- INNER JOIN: only customers who have an account
SELECT c.first_name, a.balance
FROM customers AS c
INNER JOIN accounts AS a ON c.customer_id = a.customer_id;

-- LEFT JOIN: ALL customers, even those with no account
SELECT c.first_name, a.balance    -- balance is NULL for no-account customers
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id;
```

### Follow-up 1:
**"When would you use LEFT JOIN over INNER JOIN in a banking context?"**
> When you need a complete list. Example: "Show all customers and their loan status — including customers with no loans." An INNER JOIN would hide those customers. LEFT JOIN preserves them with NULL loan values, which is important for KYC and onboarding reporting.

### Follow-up 2:
**"What does `JOIN` without a keyword default to?"**
> `JOIN` without a prefix is equivalent to `INNER JOIN`. It's better to write `INNER JOIN` explicitly for readability in code reviews.

---

## 📌 Interview Question 2

**"How do you find records in Table A that do NOT exist in Table B?"**

### Expected Answer:
> Use a **LEFT JOIN with an IS NULL check** on the right table's key column.

```sql
-- Find customers who have NO loans at Citi:
SELECT c.customer_id, c.first_name
FROM customers AS c
LEFT JOIN loans AS l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;
```

> This works because: LEFT JOIN keeps all customers. Where there's no matching loan, `l.loan_id` is `NULL`. The `WHERE IS NULL` then filters to only those unmatched rows.

### Follow-up 1:
**"Can you use NOT IN or NOT EXISTS instead? Which is better?"**
> Yes — all three work. In practice:
> - `NOT IN` → simple but breaks silently if the subquery returns a NULL
> - `NOT EXISTS` → safest for correlated checks (Day 06)
> - `LEFT JOIN + IS NULL` → most readable, often best performance with proper indexing

### Follow-up 2:
**"What is an anti-join?"**
> An anti-join returns rows from the left table that have NO match in the right table. `LEFT JOIN + IS NULL` is the SQL anti-join pattern.

---

## 📌 Interview Question 3

**"What is a SELF JOIN? Give an example."**

### Expected Answer:
> A SELF JOIN joins a table to itself. It's used when a table has a self-referencing relationship — most commonly in hierarchical data like an employee-manager relationship.

```sql
-- employees table: employee_id, first_name, manager_id
-- manager_id references employee_id in the SAME table

SELECT
    e.first_name  AS employee,
    m.first_name  AS manager
FROM employees AS e
LEFT JOIN employees AS m ON e.manager_id = m.employee_id;
-- e = the employee row
-- m = the manager row (same physical table, different alias)
```

> Key rule: **always use two different aliases** when self-joining.

---

## 📌 Interview Question 4 (Write the Query)

**"Write a query to show, for each customer: their name, total number of transactions, and total transaction amount. Include customers with NO transactions (show 0)."**

### Expected Answer:
```sql
SELECT
    c.customer_id,
    c.first_name,
    c.city,
    COUNT(t.transaction_id)  AS transaction_count,
    SUM(t.amount)            AS total_amount
FROM customers     AS c
LEFT JOIN accounts     AS a ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t ON a.account_id  = t.account_id
GROUP BY c.customer_id, c.first_name, c.city
ORDER BY total_amount DESC;
```

> Key points to explain:
> - Two LEFT JOINs to preserve customers with no accounts or no transactions
> - `COUNT(t.transaction_id)` not `COUNT(*)` — skips NULLs, shows 0 for no-transaction customers
> - Every non-aggregate in SELECT must be in GROUP BY

---

## 📌 Interview Question 5

**"What is a CROSS JOIN and when would you use it?"**

### Expected Answer:
> A CROSS JOIN produces the **Cartesian product** — every row from the left table paired with every row from the right table. No ON condition is required.
>
> Use cases:
> - Generating all combinations (all products × all branches for availability matrix)
> - Creating test data
> - Date dimension generation
>
> Warning: 1000 rows × 1000 rows = 1,000,000 rows output. Use with extreme caution.

---

## 🏆 Pro Tips for Citi Day 05 Interviews

1. **Always say "anti-join pattern"** when explaining LEFT JOIN + IS NULL — it shows senior-level vocabulary
2. **Mention table aliases**: "I always alias tables as c for customers, a for accounts — this avoids ambiguity when columns have the same name"
3. **COUNT(col) vs COUNT(*)** in JOINs: "After a LEFT JOIN, I use `COUNT(a.account_id)` not `COUNT(*)` so that customers with no accounts correctly show 0, not 1"
4. **INNER JOIN is the default**: "I write `INNER JOIN` explicitly for code readability even though `JOIN` alone is equivalent"
5. **Three-table JOIN pattern**: "In Citi's ETL pipelines, most queries join 3-5 tables — customers → accounts → transactions is the standard chain"
