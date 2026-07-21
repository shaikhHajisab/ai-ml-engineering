# 📓 Day 05 — Complete Notes
## JOINs: INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS

---

# PART 1 — CONCEPT

---

## Why JOINs Exist

So far every query used ONE table. But real data is SPLIT across many tables.

```
Question: "Show me the customer name AND their account balance"
Problem:  - Names are in the  CUSTOMERS  table
          - Balances are in the ACCOUNTS   table
Solution: JOIN the two tables on customer_id
```

At Citi Bank:
- Customer data lives in one table
- Account data in another
- Transactions in another
- Loans in another

A JOIN **combines rows** from two or more tables based on a related column (usually PK → FK).

---

## The Mental Model — Venn Diagrams

```
   customers          accounts
  ┌─────────┐        ┌─────────┐
  │  C only │  ████  │ A only  │
  │(no acct)│██████████(no cust)│
  └─────────┘        └─────────┘
               ████
           (both match)

INNER JOIN  =  only the overlap  ████
LEFT JOIN   =  left circle + overlap
RIGHT JOIN  =  right circle + overlap
FULL OUTER  =  entire both circles
```

---

## 1️⃣ INNER JOIN

### What it is:
Returns ONLY rows that have a **matching value in BOTH tables**.
Rows that don't match in either table are excluded.

### When to use:
When you ONLY want records that exist in both tables.

### Banking Example:
> "Show all accounts along with their customer names"
> - Only accounts WITH a customer appear
> - Only customers WITH an account appear

```sql
SELECT c.first_name, c.city, a.account_type, a.balance
FROM customers AS c
INNER JOIN accounts AS a ON c.customer_id = a.customer_id;
```

### Common Mistakes:
❌ Forgetting the `ON` clause → cartesian product (CROSS JOIN accidentally!)
❌ Not using table aliases → confusing when both tables have columns with same name
❌ Assuming INNER JOIN returns all left table rows — it DOESN'T (use LEFT JOIN for that)

---

## 2️⃣ LEFT JOIN (LEFT OUTER JOIN)

### What it is:
Returns ALL rows from the **LEFT** table.
For matching rows in the right table → shows values.
For no match → fills right-side columns with **NULL**.

### When to use:
When you want ALL records from the left table, even if they have no match.

### Banking Examples:
> "Show ALL customers and their accounts (even customers with no account)"
> "Find customers who have NO loans" → LEFT JOIN + IS NULL

```sql
-- All customers with their accounts (customers without accounts get NULL)
SELECT c.customer_id, c.first_name, a.account_id, a.balance
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id;

-- POWERFUL PATTERN: Find customers with NO account
SELECT c.customer_id, c.first_name
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;      -- ← NULL means no match found!
```

> 🎯 **LEFT JOIN + IS NULL = find records that DON'T exist in another table**
> This pattern is asked in EVERY Citi interview!

---

## 3️⃣ RIGHT JOIN (RIGHT OUTER JOIN)

### What it is:
Returns ALL rows from the **RIGHT** table.
For matching rows in the left table → shows values.
For no match → fills left-side columns with NULL.

### When to use:
When you want all records from the right table, even with no match.

> 💡 In practice, most engineers prefer LEFT JOIN (just swap the table order).
> RIGHT JOIN is less commonly seen in production code.

```sql
-- All accounts with customer info (accounts without a customer get NULL)
SELECT c.first_name, a.account_id, a.account_type
FROM customers AS c
RIGHT JOIN accounts AS a ON c.customer_id = a.customer_id;
```

---

## 4️⃣ FULL OUTER JOIN

### What it is:
Returns ALL rows from BOTH tables.
Matches where possible; NULLs where no match on either side.

### When to use:
When you want a complete picture — rows unique to left, unique to right, and matching.

```sql
SELECT c.first_name, a.account_id
FROM customers AS c
FULL OUTER JOIN accounts AS a ON c.customer_id = a.customer_id;
-- Customers with no account → NULL for account_id
-- Accounts with no customer → NULL for first_name
```

> ⚠️ MySQL does NOT support FULL OUTER JOIN natively.
> Workaround: LEFT JOIN UNION RIGHT JOIN

---

## 5️⃣ SELF JOIN

### What it is:
A table joined with **itself**. Used when a table has a self-referencing column
(like an employee who has a manager who is also an employee).

### Banking Example:
> "Show each employee and the name of their manager"
> Both employee AND manager are in the same `employees` table

```sql
-- employees table has: employee_id, first_name, manager_id (FK → employee_id)
SELECT
    e.first_name  AS employee_name,
    m.first_name  AS manager_name
FROM employees AS e
LEFT JOIN employees AS m ON e.manager_id = m.employee_id;
-- e = the employee
-- m = the manager (same table, different alias!)
```

> 🎯 SELF JOIN always requires TWO aliases for the same table.

---

## 6️⃣ CROSS JOIN

### What it is:
Returns the **Cartesian product** — every row from left combined with every row from right.
No `ON` condition — every combination is produced.

### When to use:
- Generating all combinations (e.g., all products × all branches)
- Rarely in banking production code
- Interview knowledge check

```sql
-- 3 loan_types × 3 branches = 9 rows
SELECT l.loan_type, b.branch_name
FROM loans AS l
CROSS JOIN branches AS b;
```

> ⚠️ If left table has 1000 rows and right has 1000 rows → 1,000,000 rows output!
> Use with extreme caution on large tables.

---

## JOIN Comparison Table

| JOIN | Left rows | Right rows | Result |
|------|-----------|------------|--------|
| INNER | matched only | matched only | rows in BOTH |
| LEFT | ALL | matched only | all left + NULLs |
| RIGHT | matched only | ALL | all right + NULLs |
| FULL OUTER | ALL | ALL | everything + NULLs |
| SELF | self-reference | self-reference | hierarchical data |
| CROSS | ALL | ALL | every combination |

---

# PART 2 — SYNTAX

```sql
-- INNER JOIN
SELECT t1.col, t2.col
FROM   table1 AS t1
INNER JOIN table2 AS t2 ON t1.id = t2.id;

-- LEFT JOIN
SELECT t1.col, t2.col
FROM   table1 AS t1
LEFT JOIN table2 AS t2 ON t1.id = t2.id;

-- RIGHT JOIN
SELECT t1.col, t2.col
FROM   table1 AS t1
RIGHT JOIN table2 AS t2 ON t1.id = t2.id;

-- FULL OUTER JOIN
SELECT t1.col, t2.col
FROM   table1 AS t1
FULL OUTER JOIN table2 AS t2 ON t1.id = t2.id;

-- SELF JOIN
SELECT a.col AS "self", b.col AS "other"
FROM   table1 AS a
LEFT JOIN table1 AS b ON a.ref_col = b.id;

-- CROSS JOIN
SELECT t1.col, t2.col
FROM   table1 AS t1
CROSS JOIN table2 AS t2;
```

### Keyword Breakdown:
| Keyword | Meaning |
|---------|---------|
| `INNER JOIN` | Match rows from both tables |
| `LEFT JOIN` | Keep all left rows |
| `RIGHT JOIN` | Keep all right rows |
| `FULL OUTER JOIN` | Keep all rows from both |
| `ON` | The condition linking the two tables |
| `t1.id = t2.id` | Column in table1 must equal column in table2 |
| `AS c` | Table alias — shortens table name |
| `c.column` | Qualify which table the column comes from |

---

# PART 4 — VISUAL EXPLANATION

## Our two tables:

### customers:
| customer_id | first_name | city |
|-------------|------------|------|
| 1001 | Ayesha | Mumbai |
| 1002 | Ravi | Delhi |
| 1003 | Priya | Bangalore |
| 1004 | Ahmed | Hyderabad |
| 1005 | Sunita | Chennai |

### accounts:
| account_id | customer_id | account_type | balance |
|------------|-------------|-------------|---------|
| 2001 | 1001 | Savings | 250000 |
| 2002 | 1002 | Checking | 85000 |
| 2003 | 1003 | Savings | 175000 |
| 2004 | 1001 | Checking | 42000 |
| 2005 | 1004 | Savings | 0 |
| 2006 | 1005 | Savings | 500000 |

> Note: customer 1001 (Ayesha) has 2 accounts. All 5 customers have accounts here.

---

### INNER JOIN result (customers ⟕ accounts):
| first_name | city | account_type | balance |
|------------|------|-------------|---------|
| Ayesha | Mumbai | Savings | 250000 |
| Ayesha | Mumbai | Checking | 42000 |
| Ravi | Delhi | Checking | 85000 |
| Priya | Bangalore | Savings | 175000 |
| Ahmed | Hyderabad | Savings | 0 |
| Sunita | Chennai | Savings | 500000 |

→ 6 rows (Ayesha appears twice — she has 2 accounts!)

---

### LEFT JOIN with a customer who has NO account (hypothetical):
Imagine customer 1006 (Nadia) has no account yet:

| first_name | account_id | account_type | balance |
|------------|------------|-------------|---------|
| Ayesha | 2001 | Savings | 250000 |
| Ravi | 2002 | Checking | 85000 |
| Priya | 2003 | Savings | 175000 |
| **Nadia** | **NULL** | **NULL** | **NULL** |

→ Nadia appears with NULLs — her KYC is pending!

---

### Find customers with NO account (LEFT JOIN + IS NULL):
```sql
SELECT c.first_name
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;
```
→ Returns Nadia (the customer with no account)

---

# PART 9 — REVISION

## 🔑 Key Takeaways

1. **INNER JOIN** — only rows matching in BOTH tables
2. **LEFT JOIN** — all left rows + NULLs for unmatched right rows
3. **LEFT JOIN + IS NULL** = find records in left table NOT in right table ← interview favorite!
4. **RIGHT JOIN** = LEFT JOIN with tables swapped (less common in practice)
5. **FULL OUTER JOIN** = all rows from both tables, NULLs where no match
6. **SELF JOIN** = table joined with itself, always needs two different aliases
7. **CROSS JOIN** = cartesian product, dangerous on large tables
8. Always use **table aliases** in JOINs — `customers AS c`, `accounts AS a`
9. Always **qualify column names**: `c.customer_id`, not just `customer_id`
10. INNER JOIN is the default — just `JOIN` without a keyword = INNER JOIN

## 📋 Cheat Sheet

```sql
-- Inner join (only matches)
SELECT c.first_name, a.balance
FROM customers AS c
INNER JOIN accounts AS a ON c.customer_id = a.customer_id;

-- Left join (all customers, even without accounts)
SELECT c.first_name, a.account_id
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id;

-- Find customers with NO account
SELECT c.first_name
FROM customers AS c
LEFT JOIN accounts AS a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;

-- Three-table join
SELECT c.first_name, a.account_type, t.amount
FROM customers AS c
INNER JOIN accounts    AS a ON c.customer_id = a.customer_id
INNER JOIN transactions AS t ON a.account_id = t.account_id;
```

## 🧠 Memory Tricks

| JOIN | Memory Trick |
|------|-------------|
| INNER JOIN | "Strict — both must show up to the meeting" |
| LEFT JOIN | "Loyal to the left — no left row gets left behind" |
| RIGHT JOIN | "Loyal to the right — mirror of LEFT JOIN" |
| FULL OUTER | "Nobody gets left out — everyone is included" |
| SELF JOIN | "Talking to yourself — same table, two aliases" |
| CROSS JOIN | "Every person meets every other person — party of N×M" |
| LEFT + IS NULL | "Show me who DIDN'T come — the absentees" |

> **Next:** Day 06 — Subqueries, Correlated Subqueries, EXISTS, ANY, ALL
