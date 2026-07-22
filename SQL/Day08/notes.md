# 🏦 SQL for Data Engineering — Day 08 Detailed Mentor Notes
## Deep-Dive: Window (Analytic) Functions for Advanced Financial Engineering

---

## PART 1 — Concept

### 1. What are Window Functions?
* **What it is:** A Window Function performs a calculation across a set of table rows that are somehow related to the current row (called a **window frame**). Unlike `GROUP BY` aggregates, window functions **do NOT collapse rows**; every single detail row is preserved while acquiring calculated metrics.
* **Why it exists:** Before window functions were introduced in ANSI SQL:1999, calculating running balances, moving averages, or ranking within sub-groups required slow self-joins or nested subqueries.
* **Real-World Example:** Calculating an account's running balance after every deposit/withdrawal, or computing the time interval (in minutes) between consecutive debit card swipes.
* **Where Citi Bank Uses It:**
  * **Fraud Detection:** Identifying rapid-succession transactions across different geolocation nodes (`LAG(txn_timestamp)`).
  * **Ledger Accounting:** Computing daily cumulative running balance on checking accounts (`SUM(amount) OVER (PARTITION BY account_id ORDER BY txn_timestamp)`).
  * **Risk Tiering:** Ranking customers into wealth tiers by branch (`DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC)`).
* **Common Interview Questions:**
  * *"What is the core difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` when tie values exist?"*
  * *"How does `PARTITION BY` differ from `GROUP BY`?"*
  * *"Why can't window functions be placed directly in the `WHERE` clause?"*
* **Common Mistakes Beginners Make:**
  * Placing a window function in the `WHERE` clause (e.g., `WHERE ROW_NUMBER() OVER (...) = 1`), which causes a syntax error because window functions evaluate after `WHERE` and `GROUP BY` during logical query processing.
  * Forgetting that `LAST_VALUE()` defaults to frame `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, which returns the current row instead of the true partition end unless explicitly specified.

---

## PART 2 — Syntax Breakdown

### 1. General Window Function Syntax
```sql
SELECT 
    column_name,
    WINDOW_FUNCTION() OVER (
        PARTITION BY partition_column
        ORDER BY sort_column ASC|DESC
        ROWS|RANGE BETWEEN frame_start AND frame_end
    ) AS window_alias
FROM 
    table_name;
```

#### Keyword-by-Keyword Explanation:
* **`WINDOW_FUNCTION()`:** The analytic operation to apply (e.g., `ROW_NUMBER()`, `RANK()`, `SUM()`, `LEAD()`).
* **`OVER`:** Crucial keyword indicating that the preceding function operates as a window function rather than a standard aggregate.
* **`PARTITION BY partition_column`:** Splits the dataset into isolated groups/sub-windows (similar to `GROUP BY`, but without collapsing rows). If omitted, the entire table is treated as a single partition.
* **`ORDER BY sort_column`:** Specifies the order in which rows inside each partition are processed. Essential for ranking and time-series calculations.
* **`ROWS BETWEEN frame_start AND frame_end`:** Defines the exact window frame boundary relative to the current row (e.g., `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`).

---

### 2. Difference Between Ranking Functions

| Function | Ties Handling | Example Output for Values (100, 100, 80, 70) |
|----------|---------------|----------------------------------------------|
| **`ROW_NUMBER()`** | Sequential unique numbers, ignores ties | `1, 2, 3, 4` |
| **`RANK()`** | Same rank for ties, **skips** next rank values | `1, 1, 3, 4` |
| **`DENSE_RANK()`** | Same rank for ties, **no gaps** in ranking | `1, 1, 2, 3` |

---

## PART 3 — Code Walkthrough

Let's walk through a production Citi Bank query computing running balances, transaction gaps, and branch balance ranks:

```sql
1: SELECT 
2:     t.account_id,
3:     t.txn_id,
4:     t.txn_timestamp,
5:     t.amount,
6:     SUM(t.amount) OVER (
7:         PARTITION BY t.account_id 
8:         ORDER BY t.txn_timestamp ASC
9:         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
10:    ) AS running_account_balance,
11:    LAG(t.txn_timestamp, 1) OVER (
12:        PARTITION BY t.account_id 
13:        ORDER BY t.txn_timestamp ASC
14:    ) AS prev_txn_timestamp,
15:    DENSE_RANK() OVER (
16:        PARTITION BY a.branch_id 
17:        ORDER BY a.balance DESC
18:    ) AS branch_balance_rank
19: FROM 
20:     banking_transactions t
21: JOIN 
22:     banking_accounts a ON t.account_id = a.account_id;
```

### Line-by-Line Mentor Breakdown:
* **Lines 1–5:** Specifies output columns (`account_id`, `txn_id`, `txn_timestamp`, `amount`).
* **Line 6:** `SUM(t.amount)` initiates cumulative summation.
* **Line 7:** `PARTITION BY t.account_id` resets the running total calculation independently for each account.
* **Line 8:** `ORDER BY t.txn_timestamp ASC` orders events chronologically.
* **Line 9:** `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` explicitly instructs SQL to add all previous rows up to the current row inside the account partition.
* **Line 10:** Aliases the running total as `running_account_balance`.
* **Lines 11–14:** `LAG(t.txn_timestamp, 1)` fetches the timestamp of the immediately preceding transaction (`1` step prior) for the same account.
* **Lines 15–18:** `DENSE_RANK()` calculates the account balance rank relative to all other accounts within the same `branch_id`, ensuring no gaps in rank numbers if balances tie.
* **Lines 19–22:** Specifies source table `banking_transactions` joined with `banking_accounts`.

---

## PART 4 — Visual Explanation

### Table: `banking_transactions` (Before Query)
| account_id | txn_id | amount  | txn_timestamp       |
|------------|--------|---------|---------------------|
| ACC_101    | T_1    | +500.00 | 2026-07-01 09:00:00 |
| ACC_101    | T_2    | -100.00 | 2026-07-01 10:30:00 |
| ACC_101    | T_3    | +250.00 | 2026-07-02 14:15:00 |

### Result Output (After Query)
| account_id | txn_id | amount  | running_account_balance | prev_txn_timestamp   | ROW_NUMBER |
|------------|--------|---------|-------------------------|----------------------|------------|
| ACC_101    | T_1    | +500.00 | 500.00                  | NULL                 | 1          |
| ACC_101    | T_2    | -100.00 | 400.00                  | 2026-07-01 09:00:00  | 2          |
| ACC_101    | T_3    | +250.00 | 650.00                  | 2026-07-01 10:30:00  | 3          |

---

## PART 7 — Interview Deep-Dive (Citi Bank DE Scenarios)

### Q1: How do you find the 2nd highest transaction per customer in SQL?
* **Answer:** Wrap a `DENSE_RANK()` or `ROW_NUMBER()` query inside a CTE or derived table subquery, then filter where rank equals 2 in the outer query:
```sql
WITH RankedTxns AS (
    SELECT 
        customer_id, txn_id, amount,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS rnk
    FROM transactions
)
SELECT customer_id, txn_id, amount 
FROM RankedTxns 
WHERE rnk = 2;
```

### Q2: Why does `LAST_VALUE(col)` sometimes return the current row's value instead of the last row in partition?
* **Answer:** By default, the frame specification for window functions with an `ORDER BY` clause is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. Because the default boundary ends at `CURRENT ROW`, `LAST_VALUE()` evaluates to the current row! To fix this, explicitly specify `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

---

## PART 9 — Revision & Cheat Sheet

### Key Takeaways
1. Window functions **never** collapse rows (unlike `GROUP BY`).
2. Filter window function results using CTEs or subqueries, never directly in `WHERE`.
3. Use `DENSE_RANK()` for financial top-N queries without skipping ranks.
4. Use `LAG()` for velocity metrics (time differences between transaction events).

### Quick Syntax Cheat Sheet
```sql
-- Deduplication / Top 1 per group
ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY txn_timestamp DESC)

-- Financial Ranking without Gaps
DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC)

-- Time Delta between Txns
LAG(txn_timestamp) OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC)

-- Cumulative Running Total
SUM(amount) OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
```

---

## PART 10 — Coding Style: Thought Process for Window Queries

1. **Identify Partitioning:** What column defines the boundaries? (`PARTITION BY account_id`).
2. **Identify Ordering:** What column defines chronological or priority sequence? (`ORDER BY txn_timestamp ASC`).
3. **Select Function:**
   - Sequential unique number? -> `ROW_NUMBER()`
   - Tied rankings? -> `DENSE_RANK()`
   - Previous row comparison? -> `LAG()`
   - Running total? -> `SUM()`
4. **Is Outer Filtering Required?** If filtering by rank (e.g. `WHERE rnk <= 3`), wrap in CTE!
