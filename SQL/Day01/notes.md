# 📓 Day 01 — Complete Notes
## SQL Fundamentals for Citi Bank Data Engineering

---

# PART 1 — CONCEPT

---

## 1️⃣ What is a Database?

### What it is:
A **database** is an organized collection of structured data stored electronically.  
Think of it like a **super-powered Excel file** — but instead of one sheet, you have many related tables working together.

### Why it exists:
Before databases, companies stored data in paper files or flat text files.  
Problems:
- Duplicate data everywhere
- Hard to search
- Easy to corrupt
- No security or access control

### Real-World Example at Citi Bank:
Citi stores:
- Millions of **customer records**
- Billions of **transactions** (ATM, NEFT, SWIFT)
- **Loan applications** and repayment schedules
- **Credit card** spending and limits
- **Fraud alerts** and investigation logs

All of this lives in databases — not Excel sheets.

### Where Citi Uses Databases:
| Use Case | Database Type |
|----------|--------------|
| Core Banking System | Oracle DB / DB2 |
| Real-time Fraud Detection | PostgreSQL / Cassandra |
| Data Warehouse (reporting) | Snowflake / Teradata |
| ETL Pipelines | Hive / BigQuery |

---

## 2️⃣ DBMS vs RDBMS

| Term | Full Form | What It Is |
|------|-----------|------------|
| DBMS | Database Management System | Software to store & manage data |
| RDBMS | Relational DBMS | Stores data in RELATED TABLES |

### DBMS Examples:
- MongoDB (document-based)
- Redis (key-value)
- Cassandra (column-family)

### RDBMS Examples (what SQL uses):
- **PostgreSQL** ✅ (most popular in Data Engineering)
- **MySQL**
- **Oracle** ✅ (used heavily at Citi)
- **SQL Server** (Microsoft)
- **SQLite** (lightweight, great for learning)

### Key Difference:
```
DBMS   → stores data in any format
RDBMS  → stores data in TABLES with RELATIONSHIPS between them
SQL    → language used to talk to RDBMS
```

---

## 3️⃣ What is SQL?

**SQL = Structured Query Language**

SQL is the **language** you use to communicate with a relational database.

Think of it like this:
```
You (Data Engineer) ──[SQL]──► Database ──► Returns Data
```

### SQL Sub-languages:

| Category | Full Name | Commands | Purpose |
|----------|-----------|----------|---------|
| DDL | Data Definition Language | CREATE, ALTER, DROP | Define structure |
| DML | Data Manipulation Language | INSERT, UPDATE, DELETE | Change data |
| DQL | Data Query Language | SELECT | Read data |
| DCL | Data Control Language | GRANT, REVOKE | Permissions |
| TCL | Transaction Control Language | COMMIT, ROLLBACK | Transactions |

> 🎯 **For Citi interviews:** Focus on DQL (SELECT) and DML (INSERT/UPDATE/DELETE). These are asked 80% of the time.

### Common Interview Questions:
1. *"What is the difference between DDL and DML?"*
2. *"Is SELECT a DDL or DML command?"* → It's DQL!
3. *"What does SQL stand for and what is it used for?"*

---

## 4️⃣ Tables, Rows, and Columns

A **table** is the core unit of storage in a relational database.

```
TABLE = spreadsheet with a fixed structure

COLUMN = attribute/field (defines what data is stored)
ROW    = record (one entry of actual data)
```

### Example: `customers` table at Citi Bank

| customer_id | first_name | last_name | email                  | city      |
|-------------|------------|-----------|------------------------|-----------|
| 1001        | Ayesha     | Khan      | ayesha@email.com       | Mumbai    |
| 1002        | Ravi       | Sharma    | ravi@email.com         | Delhi     |
| 1003        | Priya      | Nair      | priya@email.com        | Bangalore |

```
- "customer_id", "first_name", "email"  → these are COLUMNS
- Each horizontal line of data        → that is a ROW
- The entire grid                     → that is the TABLE
```

---

## 5️⃣ Primary Key & Foreign Key

### Primary Key (PK)
- **Uniquely identifies** every row in a table
- Cannot be NULL
- Cannot have duplicates
- Every table should have one

```
customers table → customer_id is the PRIMARY KEY
accounts table  → account_id is the PRIMARY KEY
```

### Foreign Key (FK)
- A column in Table B that **references the Primary Key** of Table A
- Creates the **relationship** between tables
- This is what makes a database "relational"

### Banking Example:

```
CUSTOMERS table                    ACCOUNTS table
─────────────────                  ──────────────────────────
customer_id (PK) ◄───────────────► customer_id (FK)
first_name                         account_id (PK)
last_name                          account_type
email                              balance
```

> One customer can have MANY accounts → this is called a **one-to-many relationship**

### Common Mistakes:
❌ Thinking FK must be unique (it doesn't have to be — one customer can have 5 accounts)  
❌ Forgetting that FK must reference a valid PK value (referential integrity)  
❌ Using names like `id` instead of `customer_id` (bad practice in teams)

---

## 6️⃣ Data Types

Data types tell the database **what kind of data** goes in each column.

### Most Important Data Types:

| Category | Data Type | Example | Banking Use |
|----------|-----------|---------|-------------|
| Numbers | INT | 101, 5000 | customer_id, account_id |
| Numbers | BIGINT | 9876543210 | transaction amounts |
| Numbers | DECIMAL(10,2) | 50000.75 | balance, loan_amount |
| Text | VARCHAR(n) | 'Alice' | names, city |
| Text | CHAR(n) | 'M' | gender, status codes |
| Text | TEXT | long descriptions | notes, comments |
| Date/Time | DATE | 2024-01-15 | dob, loan_date |
| Date/Time | TIMESTAMP | 2024-01-15 10:30:00 | transaction_time |
| Boolean | BOOLEAN | TRUE/FALSE | is_active, is_fraud |

> 🎯 **For money: always use DECIMAL(10,2) — never use FLOAT!**  
> FLOAT has rounding errors. You don't want Citi losing money to floating point bugs!

---

# PART 2 — SYNTAX

---

## CREATE TABLE Syntax

```sql
CREATE TABLE table_name (
    column_name  data_type  constraints,
    column_name  data_type  constraints,
    ...
);
```

### Keyword Breakdown:

| Keyword | Meaning |
|---------|---------|
| `CREATE TABLE` | Tell the DB to make a new table |
| `table_name` | The name you give to the table |
| `column_name` | Name of each attribute |
| `data_type` | What kind of data this column holds |
| `PRIMARY KEY` | Mark this column as the unique identifier |
| `NOT NULL` | This column CANNOT be empty |
| `UNIQUE` | Every value must be different |
| `DEFAULT` | Use this value if none is given |
| `REFERENCES` | This is a Foreign Key pointing to another table |

---

## INSERT INTO Syntax

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

### Keyword Breakdown:

| Keyword | Meaning |
|---------|---------|
| `INSERT INTO` | Tell the DB we are adding a new row |
| `table_name` | Which table to insert into |
| `(column1, ...)` | Which columns we are filling |
| `VALUES` | Here come the actual values |
| `(value1, ...)` | The data — must match column order |

---

## SELECT Syntax

```sql
SELECT column1, column2
FROM table_name;
```

### Keyword Breakdown:

| Keyword | Meaning |
|---------|---------|
| `SELECT` | Tell the DB what columns to return |
| `column1, column2` | Specific columns you want |
| `*` | Give me ALL columns |
| `FROM` | From which table |
| `table_name` | The table to read from |

---

# PART 3 — CODE WALKTHROUGH

---

See `queries.sql` for the complete working SQL code with line-by-line explanations.

---

# PART 4 — VISUAL EXPLANATION

---

## Before INSERT — customers table is empty:

| customer_id | first_name | last_name | email | city | date_of_birth | is_active |
|-------------|------------|-----------|-------|------|---------------|-----------|
| *(empty)*   |            |           |       |      |               |           |

## After INSERT — customers table has data:

| customer_id | first_name | last_name | email                   | city      | date_of_birth | is_active |
|-------------|------------|-----------|-------------------------|-----------|---------------|-----------|
| 1001        | Ayesha     | Khan      | ayesha.khan@citi.com    | Mumbai    | 1990-05-14    | true      |
| 1002        | Ravi       | Sharma    | ravi.sharma@citi.com    | Delhi     | 1985-11-23    | true      |
| 1003        | Priya      | Nair      | priya.nair@citi.com     | Bangalore | 1995-03-08    | true      |
| 1004        | Ahmed      | Sheikh    | ahmed.sheikh@citi.com   | Hyderabad | 1992-07-19    | false     |
| 1005        | Sunita     | Mehta     | sunita.mehta@citi.com   | Chennai   | 1988-12-01    | true      |

## After SELECT * FROM customers:
(Returns the entire table above)

## After SELECT first_name, city FROM customers:

| first_name | city      |
|------------|-----------|
| Ayesha     | Mumbai    |
| Ravi       | Delhi     |
| Priya      | Bangalore |
| Ahmed      | Hyderabad |
| Sunita     | Chennai   |

---

# PART 9 — REVISION

---

## 🔑 Key Takeaways

1. A **database** stores related data in an organized way
2. **RDBMS** stores data in tables with relationships — SQL is the language to access it
3. Every table has **columns** (structure) and **rows** (data)
4. **Primary Key** = unique identifier for each row (never null, never duplicate)
5. **Foreign Key** = links two tables together (referential integrity)
6. Use **DECIMAL(10,2)** for money — never FLOAT
7. **CREATE TABLE** defines the structure; **INSERT** adds data; **SELECT** reads data

---

## 📋 Cheat Sheet

```sql
-- Create a table
CREATE TABLE table_name (
    col_name   DATA_TYPE   CONSTRAINTS
);

-- Insert one row
INSERT INTO table_name (col1, col2) VALUES (val1, val2);

-- Select all columns
SELECT * FROM table_name;

-- Select specific columns
SELECT col1, col2 FROM table_name;
```

---

## 🧠 Memory Tricks

| Concept | Memory Trick |
|---------|-------------|
| Primary Key | "PK = Passport — unique, can't be blank" |
| Foreign Key | "FK = a reference letter pointing to someone else's passport" |
| DECIMAL(10,2) | "10 digits total, 2 after decimal — like a bank statement" |
| SELECT * | "SELECT * = Give me EVERYTHING" |
| FROM | "FROM = FROM which table?" |
| VARCHAR vs CHAR | "VARCHAR = Variable (flexible), CHAR = fixed box" |

---

## 📝 Summary

Today you learned the **foundation** of everything SQL:
- What databases are and why Citi uses them
- The difference between DBMS and RDBMS
- How SQL communicates with the database
- Tables, rows, columns — the building blocks
- Primary Key and Foreign Key — the glue between tables
- Data types — especially DECIMAL for money
- How to CREATE tables, INSERT data, and SELECT it

> **Next:** Day 02 — WHERE, ORDER BY, LIMIT, DISTINCT, Aliases
