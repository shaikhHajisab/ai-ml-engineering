# 🎯 Day 01 — Interview Questions
## SQL Fundamentals | Citi Bank Data Engineering

---

## 📌 Interview Question 1

**"What is the difference between a Primary Key and a Foreign Key?"**

### Expected Answer:
> A **Primary Key** uniquely identifies each row in a table. It cannot be NULL and cannot have duplicate values. Every table should have exactly one primary key.
>
> A **Foreign Key** is a column in one table that references the Primary Key in another table. It creates a relationship between two tables and enforces **referential integrity** — meaning you cannot insert a Foreign Key value that doesn't exist in the referenced table.

### Banking Example to give in interview:
> "In a banking system, the `customers` table has `customer_id` as a Primary Key. The `accounts` table has `customer_id` as a Foreign Key that references `customers(customer_id)`. This ensures every account belongs to a valid customer."

### Follow-up Question 1:
**"Can a Foreign Key be NULL?"**
> Yes! A NULL Foreign Key means the relationship is optional (e.g., a loan record might not yet be assigned to a branch).

### Follow-up Question 2:
**"Can a table have multiple Primary Keys?"**
> No — a table can have only ONE Primary Key. However, a Primary Key can be **composite** (made of multiple columns together). Example: `(account_id, transaction_date)` together form a unique composite key.

---

## 📌 Interview Question 2

**"Why should you use DECIMAL instead of FLOAT for financial data?"**

### Expected Answer:
> `FLOAT` is a floating-point data type that uses binary approximation. This means it cannot store all decimal values exactly — for example, `0.1 + 0.2` in floating point equals `0.30000000000000004`, not `0.3`.
>
> In financial systems, this rounding error is unacceptable. `DECIMAL(15,2)` stores exact values — it guarantees 2 decimal places with no rounding errors.
>
> In banking, even a 1-paisa error multiplied across millions of transactions is a massive compliance issue.

### Follow-up Question 1:
**"What does DECIMAL(15,2) mean exactly?"**
> `15` = total number of digits (precision)  
> `2` = digits after the decimal point (scale)  
> So `DECIMAL(15,2)` can store values like `9999999999999.99`

### Follow-up Question 2:
**"When would you use FLOAT or DOUBLE?"**
> For scientific calculations where approximate values are acceptable (e.g., ML model weights, statistical calculations). Never for money.

---

## 📌 Bonus Interview Questions

### Q3: "What is referential integrity and why does it matter?"
> Referential integrity ensures that a Foreign Key value always points to an existing Primary Key. It prevents orphan records (e.g., a transaction linked to an account that doesn't exist).

### Q4: "What is the difference between CHAR and VARCHAR?"
> `CHAR(n)` is fixed-length — always stores exactly n characters, padding with spaces if shorter.  
> `VARCHAR(n)` is variable-length — stores only as many characters as needed, up to n.  
> Use `CHAR` for fixed-length codes (e.g., country code 'IN', gender 'M'/'F').  
> Use `VARCHAR` for names, emails, descriptions — anything variable.

### Q5: "What are the 5 sub-languages of SQL?"
> DDL (Data Definition), DML (Data Manipulation), DQL (Data Query), DCL (Data Control), TCL (Transaction Control)

### Q6: "If I delete a customer from the customers table, what happens to their accounts?"
> It depends on the FK constraint:  
> - `ON DELETE CASCADE` → accounts are deleted automatically  
> - `ON DELETE RESTRICT` → deletion is blocked if accounts exist  
> - `ON DELETE SET NULL` → FK in accounts is set to NULL  
> At Citi, we'd never delete customer records — we'd set `is_active = FALSE` instead (soft delete).

---

## 🏆 Pro Tip for Citi Interviews

When answering any SQL question, always:
1. Give the definition
2. Give a **banking/financial example**
3. Mention the **business impact** (why does this matter at Citi?)

Interviewers at Citi are impressed when candidates connect SQL concepts to real banking scenarios.
