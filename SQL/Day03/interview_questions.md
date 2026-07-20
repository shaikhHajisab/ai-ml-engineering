# 🎯 Day 03 — Interview Questions
## AND/OR/NOT, IN, BETWEEN, LIKE, IS NULL | Citi Bank Data Engineering

---

## 📌 Interview Question 1

**"What is the difference between IN and BETWEEN?"**

### Expected Answer:
> `IN` checks if a value matches ANY value from a specific **list**.  
> `BETWEEN` checks if a value falls within a **range** — and is **inclusive** on both ends.

```sql
-- IN: exact list of values
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore')

-- BETWEEN: continuous range (includes boundaries)
WHERE amount BETWEEN 10000 AND 100000
-- Same as: WHERE amount >= 10000 AND amount <= 100000
```

### Follow-up 1:
**"Can BETWEEN be used with dates?"**
> Yes! BETWEEN works with dates, numbers, and text. It's most commonly used with dates in banking for period-based reports: `BETWEEN '2024-01-01' AND '2024-03-31'`

### Follow-up 2:
**"Is BETWEEN inclusive or exclusive?"**
> **Inclusive on both ends.** `BETWEEN 10 AND 20` includes 10 and 20.

---

## 📌 Interview Question 2

**"Why can't you use `= NULL` in SQL? Why must you use `IS NULL`?"**

### Expected Answer:
> `NULL` represents an unknown or missing value. In SQL, comparing anything to an unknown result is itself unknown — not TRUE or FALSE.  
>
> `NULL = NULL` evaluates to `NULL`, not `TRUE`.  
> Only `IS NULL` is the correct way to test for NULL values.

```sql
-- WRONG — always returns 0 rows:
WHERE email = NULL

-- CORRECT:
WHERE email IS NULL
```

### Follow-up 1:
**"What is the NOT IN NULL trap?"**
> If a subquery or list used with `NOT IN` contains a NULL value, the entire query returns **no rows**.  
> This is because `value NOT IN (..., NULL, ...)` internally becomes `value <> NULL` which evaluates to NULL (unknown), causing all rows to be filtered out.  
> **Fix:** Always add `WHERE col IS NOT NULL` before using NOT IN.

### Follow-up 2:
**"How does NULL behave with AND and OR?"**
```
NULL AND TRUE  = NULL  (not TRUE — the row is excluded!)
NULL AND FALSE = FALSE
NULL OR TRUE   = TRUE
NULL OR FALSE  = NULL
```
> This is why NULL values are dangerous in WHERE conditions — they silently exclude rows.

---

## 📌 Interview Question 3

**"Explain the LIKE operator and its wildcards."**

### Expected Answer:
> `LIKE` performs pattern matching on text columns using two wildcards:
> - `%` = zero or more characters (flexible match)
> - `_` = exactly one character (single character match)

```sql
WHERE name LIKE 'A%'      -- starts with A
WHERE name LIKE '%a'      -- ends with a
WHERE name LIKE '%an%'    -- contains 'an'
WHERE code LIKE '__X'     -- 2 chars then X (exactly 3 chars total)
```

### Follow-up 1:
**"Is LIKE case-sensitive?"**
> Depends on the database:
> - PostgreSQL/Oracle: YES, case-sensitive → use `ILIKE` or `LOWER(col) LIKE LOWER('pattern')`
> - MySQL: NO, case-insensitive by default

### Follow-up 2:
**"What is the performance concern with LIKE?"**
> `LIKE '%text%'` (leading wildcard) cannot use an index — it forces a full table scan.  
> `LIKE 'text%'` (trailing wildcard only) CAN use an index.  
> In large Citi tables with billions of rows, this performance difference is critical.

---

## 📌 Interview Question 4 (Scenario)

**"Write a query to find all high-risk transactions at Citi:  
DEBIT transactions above ₹1,00,000 in Q1 2024, where the description mentions 'Wire' or is missing."**

### Expected Answer:
```sql
SELECT 
    transaction_id,
    account_id,
    amount,
    description,
    transaction_date
FROM transactions
WHERE transaction_type = 'DEBIT'
  AND amount > 100000
  AND transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
  AND (description LIKE '%Wire%' OR description IS NULL)
ORDER BY amount DESC;
```

> **Key points to mention:**
> - Parentheses around the OR condition (critical!)
> - IS NULL for missing descriptions — never `= NULL`
> - BETWEEN for date range — inclusive
> - ORDER BY amount DESC to see highest risk first

---

## 🏆 Pro Tips for Citi Day 03 Interviews

1. **Always use parentheses** when mixing AND and OR — interviewers watch for this
2. **Mention NOT IN NULL trap** — it impresses senior engineers immediately
3. **LIKE performance**: mention `'text%'` is faster than `'%text%'` — shows production awareness
4. **NULL is not zero**: "NULL means unknown, not zero or false — they are completely different"
5. **BETWEEN boundary**: always confirm you know it's inclusive — interviewers test this
