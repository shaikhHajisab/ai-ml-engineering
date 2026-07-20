# 📓 Day 03 — Complete Notes
## Comparison Operators, Logical Operators, IN, BETWEEN, LIKE, IS NULL

---

# PART 1 — CONCEPT

---

## 1️⃣ Comparison Operators (Review + Depth)

You used these in Day 02. Today we go deeper.

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal | `WHERE city = 'Mumbai'` |
| `<>` or `!=` | Not equal | `WHERE status <> 'CLOSED'` |
| `>` | Greater than | `WHERE amount > 50000` |
| `<` | Less than | `WHERE balance < 1000` |
| `>=` | Greater than or equal | `WHERE salary >= 80000` |
| `<=` | Less than or equal | `WHERE interest_rate <= 9.00` |

### Common Mistake:
❌ `WHERE email = NULL` → WRONG! NULL cannot be compared with `=`  
✅ `WHERE email IS NULL` → CORRECT!

---

## 2️⃣ Logical Operators — AND, OR, NOT

### What they are:
Logical operators let you **combine multiple conditions** in a WHERE clause.

### AND
- Returns rows where **BOTH** conditions are TRUE
- Think: "This AND that must both be true"

```sql
-- Customers who are in Mumbai AND active
WHERE city = 'Mumbai' AND is_active = TRUE
```

### OR
- Returns rows where **AT LEAST ONE** condition is TRUE
- Think: "This OR that — either one is fine"

```sql
-- Customers in Mumbai OR Delhi
WHERE city = 'Mumbai' OR city = 'Delhi'
```

### NOT
- Reverses/negates a condition
- Think: "Everything EXCEPT this"

```sql
-- Customers NOT in Mumbai
WHERE NOT city = 'Mumbai'
-- Same as: WHERE city <> 'Mumbai'
```

### Operator Precedence (CRITICAL for interviews!):
```
NOT → AND → OR
(NOT is evaluated first, then AND, then OR)
```

```sql
-- WARNING: This is a common beginner trap!
WHERE city = 'Mumbai' OR city = 'Delhi' AND is_active = TRUE

-- What SQL actually computes:
WHERE city = 'Mumbai' OR (city = 'Delhi' AND is_active = TRUE)
-- Delhi customers must be active, but Mumbai customers don't have to be!

-- What you probably MEANT:
WHERE (city = 'Mumbai' OR city = 'Delhi') AND is_active = TRUE
-- Use parentheses to be explicit!
```

> 🎯 **Rule:** Always use parentheses when mixing AND and OR. Never assume.

### Real-World Citi Use:
```sql
-- Fraud detection: large debit at night
WHERE transaction_type = 'DEBIT'
  AND amount > 100000
  AND HOUR(transaction_date) BETWEEN 0 AND 4

-- Risk: accounts with very low balance OR inactive status
WHERE balance < 500
   OR is_active = FALSE
```

---

## 3️⃣ IN Operator

### What it is:
`IN` checks if a value matches ANY value in a provided list.  
It's a cleaner way to write multiple OR conditions.

### Why it exists:
```sql
-- WITHOUT IN (ugly, repetitive):
WHERE city = 'Mumbai' OR city = 'Delhi' OR city = 'Bangalore' OR city = 'Chennai'

-- WITH IN (clean, readable):
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore', 'Chennai')
```

### Syntax:
```sql
WHERE column IN (value1, value2, value3)
WHERE column NOT IN (value1, value2, value3)
```

### Real-World Citi Use:
```sql
-- Find all home, auto, and personal loans (exclude education)
WHERE loan_type IN ('Home', 'Auto', 'Personal')

-- Find accounts managed by specific branches
WHERE branch_id IN (101, 102, 105)

-- Exclude certain loan statuses
WHERE status NOT IN ('CLOSED', 'WRITTEN_OFF')
```

### Common Mistakes:
❌ `WHERE city IN 'Mumbai'` → Missing parentheses — must be `IN ('Mumbai')`  
❌ `WHERE city IN ('Mumbai',)` → Trailing comma causes error  
⚠️ `WHERE column NOT IN (...)` with NULLs in the list → returns no rows (NULL comparison issue!)

---

## 4️⃣ BETWEEN Operator

### What it is:
`BETWEEN` filters rows where a value falls within a range — **inclusive** on both ends.

### Syntax:
```sql
WHERE column BETWEEN low_value AND high_value
-- Equivalent to:
WHERE column >= low_value AND column <= high_value
```

### Key Point: BETWEEN is INCLUSIVE
```
BETWEEN 1000 AND 5000
= >= 1000 AND <= 5000
= includes both 1000 and 5000
```

### Works on Numbers, Dates, and Text:
```sql
-- Numbers:
WHERE amount BETWEEN 10000 AND 100000

-- Dates (very common in banking!):
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-12-31'

-- Text (alphabetical range — less common):
WHERE last_name BETWEEN 'A' AND 'M'
```

### NOT BETWEEN:
```sql
-- Exclude amounts in the 10k-100k range
WHERE amount NOT BETWEEN 10000 AND 100000
```

### Real-World Citi Use:
```sql
-- Quarterly report: all transactions in Q1 2024
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'

-- Mid-range loans (not micro, not jumbo)
WHERE principal_amount BETWEEN 200000 AND 2000000

-- Employees in mid salary band
WHERE salary BETWEEN 70000 AND 120000
```

---

## 5️⃣ LIKE Operator

### What it is:
`LIKE` does **pattern matching** on text columns.  
Used when you don't know the exact value but know part of it.

### Wildcards:
| Wildcard | Meaning | Example |
|----------|---------|---------|
| `%` | Zero or more characters | `'Mum%'` → Mumbai, Mumbra, Mumford |
| `_` | Exactly ONE character | `'_avi'` → Ravi, Kavi, Davi |

### Syntax:
```sql
WHERE column LIKE 'pattern'
WHERE column NOT LIKE 'pattern'
```

### Pattern Examples:
```sql
-- Starts with 'Mum'
WHERE city LIKE 'Mum%'        → Mumbai, Mumbra

-- Ends with 'ai'
WHERE city LIKE '%ai'         → Mumbai, Chennai

-- Contains 'ban' anywhere
WHERE city LIKE '%ban%'       → Bangalore

-- Exactly 5 characters
WHERE city LIKE '_____'       → Delhi, Surat, Patna

-- Second character is 'a'
WHERE first_name LIKE '_a%'   → Ravi, Karan, Zara, Priya
```

### Case Sensitivity:
- **PostgreSQL/Oracle**: LIKE is case-sensitive. `'mumbai'` ≠ `'Mumbai'`
- **MySQL**: LIKE is case-INsensitive by default
- Use `ILIKE` in PostgreSQL for case-insensitive matching
- Use `LOWER(city) LIKE 'mum%'` for safe cross-database behavior

### Real-World Citi Use:
```sql
-- Find customers whose email is from gmail
WHERE email LIKE '%@gmail.com'

-- Find customers whose name starts with 'A'
WHERE first_name LIKE 'A%'

-- Find loan descriptions containing 'home'
WHERE description LIKE '%home%'

-- Search transaction descriptions for 'fraud'
WHERE description LIKE '%fraud%'
```

---

## 6️⃣ IS NULL / IS NOT NULL

### What is NULL?
`NULL` means **unknown** or **missing** — it is NOT zero, NOT empty string, NOT FALSE.  
NULL is the absence of any value.

### Why it's critical at Citi:
In real banking ETL pipelines:
- A customer with no email → `email IS NULL`
- A loan with no end date (open-ended) → `loan_end_date IS NULL`
- A transaction with no description → `description IS NULL`

If you don't handle NULLs, your queries return wrong results silently!

### Syntax:
```sql
-- Find rows with missing email
WHERE email IS NULL

-- Find rows with an email address
WHERE email IS NOT NULL

-- WRONG (this never works!):
WHERE email = NULL      -- ❌ Always returns nothing
WHERE email != NULL     -- ❌ Always returns nothing
```

### Why `= NULL` doesn't work:
NULL represents "unknown". Is "unknown" equal to "unknown"?  
In SQL — **you can't know**. So `NULL = NULL` returns NULL, not TRUE.  
Only `IS NULL` can test for NULL.

### NULL in AND/OR:
```sql
NULL AND TRUE  → NULL (not TRUE!)
NULL OR TRUE   → TRUE
NULL AND FALSE → FALSE
NULL OR FALSE  → NULL
```

### Real-World Citi Use:
```sql
-- Find customers who haven't given their email (incomplete KYC)
WHERE email IS NULL

-- Find loans with no end date (perpetual/revolving credit)
WHERE loan_end_date IS NULL

-- Find accounts that DO have a linked branch
WHERE branch_id IS NOT NULL

-- ETL data quality check: find records with missing transaction descriptions
WHERE description IS NULL
```

---

# PART 2 — SYNTAX SUMMARY

```sql
-- Comparison
WHERE amount > 50000
WHERE status <> 'ACTIVE'

-- AND / OR / NOT
WHERE city = 'Mumbai' AND is_active = TRUE
WHERE city = 'Mumbai' OR city = 'Delhi'
WHERE NOT city = 'Mumbai'
WHERE (city = 'Mumbai' OR city = 'Delhi') AND is_active = TRUE  -- use parentheses!

-- IN
WHERE loan_type IN ('Home', 'Auto', 'Personal')
WHERE city NOT IN ('Chennai', 'Kolkata')

-- BETWEEN (inclusive!)
WHERE amount BETWEEN 10000 AND 100000
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'

-- LIKE (% = many chars, _ = one char)
WHERE email LIKE '%@gmail.com'
WHERE first_name LIKE 'A%'
WHERE city LIKE '_umbai'     → Mumbai

-- IS NULL
WHERE email IS NULL
WHERE loan_end_date IS NOT NULL
```

---

# PART 4 — VISUAL EXPLANATION

## customers table:

| customer_id | first_name | city      | is_active | email |
|-------------|------------|-----------|-----------|-------|
| 1001 | Ayesha | Mumbai    | TRUE  | ayesha@citi.com |
| 1002 | Ravi   | Delhi     | TRUE  | ravi@citi.com |
| 1003 | Priya  | Bangalore | TRUE  | priya@citi.com |
| 1004 | Ahmed  | Hyderabad | FALSE | NULL |
| 1005 | Sunita | Chennai   | TRUE  | sunita@citi.com |

---

### `WHERE city IN ('Mumbai', 'Delhi')`:
| customer_id | first_name | city |
|-------------|------------|------|
| 1001 | Ayesha | Mumbai |
| 1002 | Ravi | Delhi |

---

### `WHERE is_active = TRUE AND city LIKE '%a%'` (city contains letter 'a'):
| customer_id | first_name | city |
|-------------|------------|------|
| 1003 | Priya | Bangal**o**re... wait → 'Bangalore' contains 'a' ✅ |
| 1005 | Sunita | Chenn**a**i ✅ |

*(Mumbai has 'a' → Mumba**i** → Ayesha also qualifies)*

---

### `WHERE email IS NULL`:
| customer_id | first_name | email |
|-------------|------------|-------|
| 1004 | Ahmed | NULL |

---

## loans table:

| loan_id | customer_id | loan_type | principal_amount | status |
|---------|-------------|-----------|-----------------|--------|
| 5001 | 1001 | Home | 5000000.00 | ACTIVE |
| 5002 | 1002 | Auto | 800000.00 | ACTIVE |
| 5003 | 1003 | Personal | 200000.00 | ACTIVE |

### `WHERE principal_amount BETWEEN 500000 AND 3000000`:
| loan_id | loan_type | principal_amount |
|---------|-----------|-----------------|
| 5002 | Auto | 800000.00 |

*(5,000,000 is above 3,000,000 → excluded. 200,000 is below 500,000 → excluded)*

---

# PART 9 — REVISION

## 🔑 Key Takeaways

1. `AND` — both conditions must be TRUE
2. `OR` — at least one must be TRUE
3. `NOT` — reverses the condition
4. **Always use parentheses** when mixing AND and OR
5. `IN (val1, val2)` = cleaner version of multiple OR conditions
6. `BETWEEN a AND b` = inclusive on BOTH ends (>= a AND <= b)
7. `LIKE '%text%'` = contains; `'text%'` = starts with; `'%text'` = ends with
8. `_ ` in LIKE = exactly ONE character
9. `NULL` = unknown/missing — test with `IS NULL`, NEVER with `= NULL`
10. `NOT IN` with NULLs in the list returns no rows — a hidden bug!

## 📋 Cheat Sheet

```sql
-- AND / OR / NOT
WHERE city = 'Mumbai' AND is_active = TRUE
WHERE (city = 'A' OR city = 'B') AND salary > 50000  -- parentheses!

-- IN
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore')
WHERE status NOT IN ('CLOSED', 'DEFAULTED')

-- BETWEEN
WHERE amount BETWEEN 10000 AND 500000
WHERE tx_date BETWEEN '2024-01-01' AND '2024-12-31'

-- LIKE
WHERE email LIKE '%@gmail.com'   -- ends with @gmail.com
WHERE name  LIKE 'A%'            -- starts with A
WHERE name  LIKE '%a%'           -- contains a
WHERE code  LIKE '__X'           -- 2 chars + X

-- NULL
WHERE email IS NULL              -- missing email
WHERE phone IS NOT NULL          -- has phone number
```

## 🧠 Memory Tricks

| Concept | Trick |
|---------|-------|
| AND | "Strict bouncer — BOTH conditions must pass" |
| OR | "Relaxed bouncer — EITHER condition is fine" |
| IN | "VIP List — is this value on the guest list?" |
| BETWEEN | "BETWEEN the ropes — both ends included" |
| `%` | "% = unlimited wildcard" |
| `_` | "_ = exactly ONE mystery character" |
| IS NULL | "IS NULL = asking 'is anything there?'" |
| `= NULL` | "Never write = NULL — it always returns empty!" |

> **Next:** Day 04 — Aggregate Functions (COUNT, SUM, AVG, MIN, MAX), GROUP BY, HAVING
