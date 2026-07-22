# 🏦 SQL for Data Engineering — Day 06 & 07 Detailed Mentor Notes
## Combined Deep-Dive: Advanced Subqueries & Built-in Expressions for Banking Systems

---

##  PART 1 — Concepts

### 1. Subqueries (Scalar, Multi-Row, and Table Subqueries)
* **What it is:** A subquery is an inner SQL query nested inside a outer `SELECT`, `FROM`, `WHERE`, or `HAVING` statement.
* **Why it exists:** Often, filtering or calculation depends on a dynamically computed value that is not known beforehand (e.g., finding accounts with balances greater than the overall bank average).
* **Real-World Example:** Calculating whether a transaction amount exceeds the customer's average daily spend over the past 30 days.
* **Citi Bank Use Case:** Risk & Fraud Detection engines use subqueries to flag transactions that deviate from benchmark standard deviations.
* **Common Interview Questions:**
  * *"What is the difference between a scalar subquery and a multi-row subquery?"*
  * *"Where can a subquery be placed in a SELECT statement?"*
* **Common Mistakes Beginners Make:**
  * Expecting a scalar operator (like `=`) to work when the subquery returns multiple rows (`ERROR: Subquery returned more than 1 row`).
  * Forgetting that subqueries inside `WHERE` execute once per outer query (unless correlated).

---

### 2. Correlated Subqueries & `EXISTS` / `NOT EXISTS`
* **What it is:** A correlated subquery depends on data from the current row of the outer query. It evaluates once for every row processed by the outer query. `EXISTS` returns `TRUE` as soon as the inner query finds at least 1 matching row.
* **Why it exists:** `EXISTS` short-circuits evaluation. Unlike `IN`, which fetches all inner values into memory, `EXISTS` stops scanning as soon as a match is found.
* **Real-World Example:** Checking if a customer has at least one active credit card before approving a loan application.
* **Citi Bank Use Case:** High-throughput ETL pipelines auditing high-risk accounts against global watchlist databases.
* **Common Interview Questions:**
  * *"Why is `EXISTS` preferred over `IN` when handling NULL values or large tables?"*
  * *"Explain how a correlated subquery executes step-by-step."*
* **Common Mistakes Beginners Make:**
  * Using `IN` with a subquery that might return `NULL`s, causing `NOT IN` to evaluate to `NULL` (empty set).
  * Missing the correlation condition (`WHERE inner.cust_id = outer.cust_id`) inside the inner query, turning it into an expensive uncorrelated query.

---

### 3. Conditional Expressions: `CASE WHEN`, `COALESCE`, `NULLIF`
* **What it is:** `CASE WHEN` provides `IF-THEN-ELSE` logic. `COALESCE(val1, val2, ...)` returns the first non-NULL value. `NULLIF(val1, val2)` returns `NULL` if `val1 = val2`.
* **Why it exists:** Essential for feature engineering, data transformation, and avoiding runtime errors (like division by zero).
* **Real-World Example:** Categorizing credit card spending into `VIP`, `PREMIUM`, and `STANDARD` tiers; substituting default phone numbers when contact info is missing.
* **Citi Bank Use Case:** Regulatory reporting where transaction types are mapped to central bank regulatory codes; avoiding divide-by-zero during debt-to-income ratio calculations (`amount / NULLIF(income, 0)`).
* **Common Interview Questions:**
  * *"How do you handle division by zero in SQL safely?"*
  * *"How can you perform conditional aggregation using CASE WHEN inside SUM()?"*
* **Common Mistakes Beginners Make:**
  * Forgetting the `END` keyword in `CASE WHEN`.
  * Expecting `CASE WHEN` to check multiple conditions simultaneously when ordering matters (it evaluates top-down and stops at the first `TRUE`).

---

### 4. String & Date Functions
* **What it is:** Built-in functions to transform text data (`UPPER`, `LOWER`, `CONCAT`, `SUBSTRING`, `REPLACE`, `TRIM`) and manipulate timestamp data (`CURRENT_DATE`, `DATEADD`/`INTERVAL`, `DATEDIFF`, `DATE_TRUNC`, `EXTRACT`).
* **Why it exists:** Banking raw data from legacy mainframes is dirty (trailing spaces, lowercase names, ISO timestamps needing date-truncation for daily aggregations).
* **Real-World Example:** Extracting the branch code from a account number string (`ACC-NY-10492`) or calculating account age in days.
* **Citi Bank Use Case:** Monthly interest calculation runs using `DATE_TRUNC('month', transaction_date)` and masking Sensitive Personal Information (SPI/PII) such as masking SSNs or card numbers (`'XXXX-XXXX-XXXX-' || RIGHT(card_number, 4)`).
* **Common Interview Questions:**
  * *"How do you group hourly financial transactions into daily totals using SQL?"*
  * *"How do you extract the domain name or specific substring from a customer email field?"*
* **Common Mistakes Beginners Make:**
  * Using string functions directly on indexed columns in `WHERE` clauses (e.g., `WHERE LOWER(last_name) = 'smith'`), which prevents index usage (SARGability issue).

---

## PART 2 — Syntax Breakdown

### 1. `EXISTS` & Correlated Subquery Syntax
```sql
SELECT 
    c.customer_id, 
    c.first_name
FROM 
    customers c
WHERE 
    EXISTS (
        SELECT 1 
        FROM transactions t 
        WHERE t.customer_id = c.customer_id 
          AND t.amount > 10000
    );
```
* `SELECT`: Specifies the columns to return from the outer table.
* `FROM customers c`: Specifies the primary outer table with alias `c`.
* `WHERE`: Filters rows based on the subquery condition.
* `EXISTS (...)`: Returns `TRUE` if the inner subquery returns 1 or more rows.
* `SELECT 1`: Optimization convention; `EXISTS` doesn't inspect values, only row presence.
* `WHERE t.customer_id = c.customer_id`: Correlation clause binding outer row `c` to inner table `t`.

---

### 2. `CASE WHEN` & `COALESCE` Syntax
```sql
SELECT 
    account_id,
    balance,
    COALESCE(overdraft_limit, 0.00) AS clean_overdraft,
    CASE 
        WHEN balance >= 100000 THEN 'Platinum'
        WHEN balance >= 25000 THEN 'Gold'
        ELSE 'Standard'
    END AS account_tier
FROM 
    accounts;
```
* `COALESCE(overdraft_limit, 0.00)`: Replaces `NULL` in `overdraft_limit` with `0.00`.
* `CASE`: Starts the conditional block.
* `WHEN balance >= 100000 THEN 'Platinum'`: Evaluates first predicate. If true, returns `'Platinum'`.
* `ELSE 'Standard'`: Fallback if no `WHEN` condition is met.
* `END`: Concludes the `CASE` statement.
* `AS account_tier`: Assigns a clean column alias.

---

### 3. Date & String Transformation Syntax
```sql
SELECT 
    CONCAT(UPPER(last_name), ', ', first_name) AS full_name_formatted,
    DATE_TRUNC('month', transaction_timestamp) AS transaction_month,
    EXTRACT(YEAR FROM transaction_timestamp) AS transaction_year
FROM 
    customers c
JOIN 
    transactions t ON c.customer_id = t.customer_id;
```
* `CONCAT(...)`: Joins text strings together seamlessly.
* `UPPER(last_name)`: Converts text to uppercase.
* `DATE_TRUNC('month', timestamp)`: Truncates timestamp down to the 1st day of that month (essential for monthly financial aggregation).
* `EXTRACT(YEAR FROM timestamp)`: Returns numeric year component.

---

## PART 3 — Code Walkthrough

Let's examine a production banking ETL query that calculates risk status and masks sensitive customer info:

```sql
1: SELECT 
2:     c.customer_id,
3:     CONCAT(c.first_name, ' ', UPPER(c.last_name)) AS masked_name,
4:     COALESCE(c.phone_number, 'UNREGISTERED') AS contact_phone,
5:     a.account_type,
6:     a.balance,
7:     CASE 
8:         WHEN a.balance < 0 THEN 'OVERDRAWN'
9:         WHEN a.balance BETWEEN 0 AND 1000 THEN 'LOW_BALANCE'
10:        ELSE 'HEALTHY'
11:    END AS balance_status
12: FROM 
13:     customers c
14: INNER JOIN 
15:     accounts a ON c.customer_id = a.customer_id
16: WHERE 
17:     EXISTS (
18:         SELECT 1 
19:         FROM fraud_alerts f 
20:         WHERE f.account_id = a.account_id 
21:           AND f.status = 'PENDING_REVIEW'
22:     )
23: ORDER BY 
24:     a.balance ASC;
```

### Line-by-Line Mentor Breakdown:
* **Line 1:** `SELECT` keyword initiates column projection.
* **Line 2:** `c.customer_id` extracts unique identifier from customers alias.
* **Line 3:** `CONCAT` combines first name, a space, and uppercase last name for standardized display.
* **Line 4:** `COALESCE` replaces any missing/NULL phone numbers with explicit `'UNREGISTERED'` text.
* **Line 5-6:** Retrieves account type and balance from accounts alias.
* **Line 7-11:** Evaluates balance ranges using `CASE WHEN` to label account status as `OVERDRAWN`, `LOW_BALANCE`, or `HEALTHY`.
* **Line 12-13:** Specifies source dataset `customers` with alias `c`.
* **Line 14-15:** Performs `INNER JOIN` with `accounts` table on foreign key matching `customer_id`.
* **Line 16-17:** Filters outer records using `EXISTS` subquery predicate.
* **Line 18-21:** Inner query checks if the specific `account_id` has an active record in `fraud_alerts` with `status = 'PENDING_REVIEW'`.
* **Line 22:** Closes the subquery parenthesis.
* **Line 23-24:** Sorts result set by balance ascending so risk compliance officers see lowest/negative balances first.

---

## PART 4 — Visual Explanation

### Table 1: `accounts` (Before Query)
| account_id | customer_id | balance | overdraft_limit |
|------------|-------------|---------|-----------------|
| ACC_101    | CUST_1      | -150.00 | 500.00          |
| ACC_102    | CUST_2      | 450.00  | NULL            |
| ACC_103    | CUST_3      | 8500.00 | 1000.00         |

### Table 2: `fraud_alerts` (Before Query)
| alert_id | account_id | status          |
|----------|------------|-----------------|
| FLG_901  | ACC_101    | PENDING_REVIEW  |
| FLG_902  | ACC_102    | RESOLVED        |
| FLG_903  | ACC_103    | PENDING_REVIEW  |

### Output Result (After Query)
| customer_id | masked_name | contact_phone | account_type | balance | balance_status |
|-------------|-------------|---------------|--------------|---------|----------------|
| CUST_1 | John DOE | 555-0192 | CHECKING | -150.00 | OVERDRAWN |
| CUST_3 | Alice SMITH | UNREGISTERED | SAVINGS | 8500.00 | HEALTHY |

*(Note: ACC_102 was omitted because its fraud alert status is `RESOLVED`, failing the `EXISTS` check).*

---

## PART 7 — Interview Deep-Dive (Citi Bank DE Scenarios)

### Q1: Difference between `WHERE` subquery using `IN` vs `EXISTS`?
* **Answer:** `IN` executes the subquery fully first, constructs a distinct hash table of results, and compares outer values against it. If the inner result contains `NULL`s, `NOT IN` returns zero rows (evaluates to `UNKNOWN`). `EXISTS` evaluates iteratively per row using short-circuit evaluation, returning true as soon as one matching tuple is found, and handles `NULL`s gracefully.

### Q2: How do you safely compute percentage changes without throwing division by zero errors in SQL?
* **Answer:** Wrap the denominator in `NULLIF(denominator, 0)`. If denominator is `0`, `NULLIF` turns it into `NULL`. Any division by `NULL` in SQL safely yields `NULL` instead of a query crash (`Division by zero`).
```sql
SELECT (current_revenue - prior_revenue) / NULLIF(prior_revenue, 0) * 100 AS pct_growth FROM quarterly_metrics;
```

### Follow-up Q1: How do you extract daily transactional aggregates from a timestamp column without losing index utilization?
* **Answer:** Avoid wrapping the table column in a function in `WHERE` clause (e.g. `WHERE DATE(txn_timestamp) = '2026-07-22'`). Instead, use range filtering: `WHERE txn_timestamp >= '2026-07-22 00:00:00' AND txn_timestamp < '2026-07-23 00:00:00'`. This keeps the predicate SARGable (Search Argument Able) so B-Tree indexes can be scanned efficiently.

### Follow-up Q2: What happens if a `CASE WHEN` clause has no `ELSE` branch and no condition evaluates to TRUE?
* **Answer:** It returns `NULL` for that row. In production Data Engineering pipelines, always provide an explicit `ELSE` clause (e.g. `ELSE 'UNKNOWN'`) to maintain strict schema definitions and avoid unexpected null values downstream.

---

## PART 9 — Revision & Cheat Sheet

### Key Takeaways
1. **Correlated Subqueries** execute once per outer row; use `EXISTS` for fast presence checks.
2. **Conditional Aggregation:** `SUM(CASE WHEN status = 'APPROVED' THEN amount ELSE 0 END)` turns row data into pivot metrics in a single table scan.
3. **`COALESCE`** is your primary defensive programming tool for NULL handling.
4. **`DATE_TRUNC`** is essential for time-series bucket aggregation in financial ETLs.

### Quick Syntax Cheat Sheet
```sql
-- Defensive Division
amount / NULLIF(total_count, 0)

-- Null Replacement
COALESCE(column_name, fallback_value)

-- Conditional Aggregation
COUNT(CASE WHEN transaction_type = 'WIRE' THEN 1 END) AS wire_count

-- Date Truncation
DATE_TRUNC('month', txn_timestamp)
```

---

## PART 10 — Coding Style: Senior Data Engineer Thought Process

Before writing a single line of SQL, follow this **7-Step Blueprint**:

1. **Understand Goal:** Identify the final business metrics needed (e.g., *"Find fraud risk per branch for last month"*).
2. **Identify Primary & Foreign Tables:** Pinpoint base table (`branches`) and event table (`transactions`).
3. **Identify Required Columns:** Filter columns needed in output vs intermediate steps.
4. **Determine Filtering Logic:** Determine `WHERE` constraints, `EXISTS` subqueries, or date ranges.
5. **Determine Grouping Requirements:** Identify dimensions for `GROUP BY` (e.g., `branch_id`).
6. **Determine Ordering:** Select sorting rules (`ORDER BY total_risk_score DESC`).
7. **Optimize for Index & NULL Safety:** Apply `NULLIF` for division, check for `EXISTS` vs `IN`, ensure SARGable predicates.
