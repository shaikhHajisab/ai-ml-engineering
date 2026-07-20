# 📓 Day 02 — Complete Notes
## WHERE, ORDER BY, LIMIT, DISTINCT, Aliases

---

# PART 1 — CONCEPT

---

## 1️⃣ WHERE Clause

### What it is:
`WHERE` filters rows from a table. Without WHERE, `SELECT` returns EVERY row.  
With WHERE, you tell the database: *"Give me only the rows that match this condition."*

### Why it exists:
Citi Bank has 50 million customers. You never want ALL of them.  
You want: *"customers in Mumbai"* or *"transactions above ₹1,00,000"* or *"active accounts only"*

### Real-World Citi Use Cases:
| Business Need | SQL Filter |
|---------------|------------|
| Find all active customers | `WHERE is_active = TRUE` |
| Transactions above ₹50,000 | `WHERE amount > 50000` |
| Loans that are DEFAULTED | `WHERE status = 'DEFAULTED'` |
| Customers in Mumbai | `WHERE city = 'Mumbai'` |
| Fraud team: late-night transactions | `WHERE HOUR(transaction_date) BETWEEN 0 AND 4` |

### Common Mistakes Beginners Make:
❌ `WHERE name = Alice` → Missing quotes around string (must be `'Alice'`)  
❌ `WHERE salary = NULL` → WRONG! Use `IS NULL`, not `= NULL`  
❌ Using `WHERE` after `GROUP BY` → WRONG! Use `HAVING` after GROUP BY (Day 04)  
❌ Filtering on a column alias → SQL evaluates WHERE before SELECT, so aliases don't exist yet

---

## 2️⃣ ORDER BY

### What it is:
`ORDER BY` sorts the result rows in ascending or descending order.

### Why it exists:
Data is stored in the order it was inserted. That's rarely useful.  
You want: *"Show me all transactions from newest to oldest"* or *"top earners first"*

### Real-World Citi Use Cases:
| Business Need | SQL Sort |
|---------------|---------|
| Most recent transactions first | `ORDER BY transaction_date DESC` |
| Highest loan amount first | `ORDER BY principal_amount DESC` |
| Customers alphabetically | `ORDER BY last_name ASC` |
| Lowest salary first (pay audit) | `ORDER BY salary ASC` |

### ASC vs DESC:
```
ASC  = Ascending  = smallest → largest   (default, can omit)
DESC = Descending = largest  → smallest
```

---

## 3️⃣ LIMIT

### What it is:
`LIMIT n` returns only the first n rows of the result.

### Why it exists:
A query might return 10 million rows. You don't want all of them — you want the Top 10, or the first 100 to preview.

> 🎯 In **PostgreSQL / MySQL**: use `LIMIT n`  
> In **SQL Server (Citi often uses this)**: use `TOP n` in SELECT  
> In **Oracle (Citi uses Oracle)**: use `FETCH FIRST n ROWS ONLY` or `ROWNUM`

### Real-World Citi Use Cases:
| Business Need | SQL |
|---------------|-----|
| Top 5 highest-value transactions | `ORDER BY amount DESC LIMIT 5` |
| Preview first 10 rows of new table | `LIMIT 10` |
| Find the single most recent transaction | `ORDER BY transaction_date DESC LIMIT 1` |

---

## 4️⃣ DISTINCT

### What it is:
`DISTINCT` removes duplicate values from the result — returns only unique values.

### Why it exists:
Multiple customers can live in the same city.  
`SELECT city FROM customers` returns Mumbai many times.  
`SELECT DISTINCT city FROM customers` returns each city only ONCE.

### Real-World Citi Use Cases:
| Business Need | SQL |
|---------------|-----|
| Which cities have Citi customers? | `SELECT DISTINCT city FROM customers` |
| What account types exist? | `SELECT DISTINCT account_type FROM accounts` |
| How many unique departments? | `SELECT DISTINCT department FROM employees` |

---

## 5️⃣ Aliases (AS)

### What it is:
`AS` gives a temporary new name to a column or table in the result.  
The original table/column name does NOT change.

### Why it exists:
Column names like `principal_amount` are ugly in reports.  
Business users want to see `Loan Amount` instead.  
Aliases make output human-readable.

### Real-World Citi Use Cases:
```sql
-- Column alias: rename output column
SELECT first_name AS "Customer Name", city AS "Location"
FROM customers;

-- Table alias: shorten table name for joins (very useful in Day 05!)
SELECT c.first_name, a.balance
FROM customers AS c
JOIN accounts AS a ON c.customer_id = a.customer_id;
```

---

# PART 2 — SYNTAX (Every Keyword Explained)

---

## WHERE Syntax

```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

| Keyword | Meaning |
|---------|---------|
| `WHERE` | Start of the filter condition |
| `condition` | A logical test — rows that pass are returned |
| `=` | Equals |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |
| `<>` or `!=` | Not equal to |

## ORDER BY Syntax

```sql
SELECT column1, column2
FROM table_name
ORDER BY column1 ASC, column2 DESC;
```

| Keyword | Meaning |
|---------|---------|
| `ORDER BY` | Start of the sort instruction |
| `column1` | The column to sort by |
| `ASC` | Ascending order (A→Z, 1→9) — this is the DEFAULT |
| `DESC` | Descending order (Z→A, 9→1) |
| `,` | You can sort by multiple columns |

## LIMIT Syntax

```sql
SELECT column1
FROM table_name
LIMIT 10;
```

## DISTINCT Syntax

```sql
SELECT DISTINCT column1
FROM table_name;
```

## AS Alias Syntax

```sql
SELECT column_name AS alias_name
FROM table_name AS t;
```

---

## SQL Execution Order (CRITICAL for Interviews!)

SQL doesn't execute in the order you write it. It runs in this order:

```
1. FROM        → Which table?
2. WHERE       → Filter rows
3. SELECT      → Choose columns
4. DISTINCT    → Remove duplicates
5. ORDER BY    → Sort
6. LIMIT       → Cut result
```

> 🎯 This is why you CANNOT use a column alias in WHERE — WHERE runs BEFORE SELECT!

---

# PART 3 — CODE WALKTHROUGH

See `queries.sql` for the complete working SQL code with line-by-line explanations.

---

# PART 4 — VISUAL EXPLANATION

## customers table (from Day 01):

| customer_id | first_name | last_name | city      | is_active |
|-------------|------------|-----------|-----------|-----------|
| 1001        | Ayesha     | Khan      | Mumbai    | TRUE      |
| 1002        | Ravi       | Sharma    | Delhi     | TRUE      |
| 1003        | Priya      | Nair      | Bangalore | TRUE      |
| 1004        | Ahmed      | Sheikh    | Hyderabad | FALSE     |
| 1005        | Sunita     | Mehta     | Chennai   | TRUE      |

---

### After `WHERE is_active = TRUE`:

| customer_id | first_name | last_name | city      | is_active |
|-------------|------------|-----------|-----------|-----------|
| 1001        | Ayesha     | Khan      | Mumbai    | TRUE      |
| 1002        | Ravi       | Sharma    | Delhi     | TRUE      |
| 1003        | Priya      | Nair      | Bangalore | TRUE      |
| 1005        | Sunita     | Mehta     | Chennai   | TRUE      |

→ Ahmed (FALSE) is filtered out ✅

---

### After `ORDER BY customer_id DESC`:

| customer_id | first_name |
|-------------|------------|
| 1005        | Sunita     |
| 1004        | Ahmed      |
| 1003        | Priya      |
| 1002        | Ravi       |
| 1001        | Ayesha     |

→ Highest ID first (descending) ✅

---

### After `SELECT DISTINCT city FROM customers`:

| city      |
|-----------|
| Mumbai    |
| Delhi     |
| Bangalore |
| Hyderabad |
| Chennai   |

→ Each city appears only once ✅

---

### After `SELECT first_name AS "Name", city AS "Branch City" FROM customers`:

| Name   | Branch City |
|--------|-------------|
| Ayesha | Mumbai      |
| Ravi   | Delhi       |
| Priya  | Bangalore   |
| Ahmed  | Hyderabad   |
| Sunita | Chennai     |

→ Column headers renamed ✅

---

# PART 9 — REVISION

---

## 🔑 Key Takeaways

1. `WHERE` filters ROWS — runs BEFORE SELECT
2. `ORDER BY` sorts results — ASC is default (you can omit it)
3. `LIMIT` caps the number of rows returned — combine with ORDER BY for "Top N" queries
4. `DISTINCT` removes duplicate values in a column
5. `AS` creates an alias — temporary rename for output only
6. SQL runs in this order: FROM → WHERE → SELECT → DISTINCT → ORDER BY → LIMIT
7. `= NULL` is WRONG — always use `IS NULL` or `IS NOT NULL`

---

## 📋 Cheat Sheet

```sql
-- Filter rows
SELECT * FROM customers WHERE city = 'Mumbai';

-- Filter with number comparison
SELECT * FROM accounts WHERE balance > 100000;

-- Sort ascending (default)
SELECT * FROM transactions ORDER BY amount ASC;

-- Sort descending
SELECT * FROM transactions ORDER BY transaction_date DESC;

-- Top N rows
SELECT * FROM transactions ORDER BY amount DESC LIMIT 5;

-- Unique values only
SELECT DISTINCT city FROM customers;

-- Rename columns in output
SELECT first_name AS "First Name", salary AS "Monthly Salary"
FROM employees;

-- Combine everything
SELECT DISTINCT city AS "Customer City"
FROM customers
WHERE is_active = TRUE
ORDER BY city ASC
LIMIT 3;
```

---

## 🧠 Memory Tricks

| Concept | Memory Trick |
|---------|-------------|
| WHERE | "WHERE do you want the data FROM?" |
| ORDER BY DESC | "DESC = Descending = Biggest First" |
| LIMIT | "LIMIT the damage — cap your results" |
| DISTINCT | "DISTINCT = Deduplicate = one of each" |
| AS | "AS = Also Spelled As (rename)" |
| Execution order | "FROM → WHERE → SELECT → DISTINCT → ORDER → LIMIT" |

---

## 📝 Summary

Today you learned how to **control** SELECT output:
- `WHERE` — filter which rows come back
- `ORDER BY` — control the sort order
- `LIMIT` — control how many rows come back
- `DISTINCT` — remove duplicates
- `AS` — rename columns for readable output
- **SQL Execution Order** — critical for interviews

> **Next:** Day 03 — Comparison Operators, Logical Operators (AND/OR/NOT), IN, BETWEEN, LIKE, IS NULL
