-- =============================================================================
-- SQL for Data Engineering — Day 08 Practice Solutions
-- Target: Citi Bank Data Engineering Coding Workshop
-- NOTE: ONLY REVIEW THESE SOLUTIONS AFTER ATTEMPTING practice.sql!
-- =============================================================================

-- Problem 1 (Easy) Solution:
SELECT 
    account_id,
    txn_id,
    amount,
    txn_timestamp,
    ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC) AS txn_seq_num
FROM 
    transactions;

-- Problem 2 (Easy) Solution:
SELECT 
    account_id,
    customer_id,
    balance,
    DENSE_RANK() OVER (ORDER BY balance DESC) AS balance_rank
FROM 
    accounts;

-- Problem 3 (Easy) Solution:
SELECT 
    account_id,
    txn_id,
    amount,
    LAG(amount, 1) OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC) AS previous_txn_amount
FROM 
    transactions;

-- Problem 4 (Medium) Solution:
WITH RankedAccounts AS (
    SELECT 
        branch_id,
        account_id,
        customer_id,
        balance,
        DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS branch_rank
    FROM 
        accounts
)
SELECT 
    branch_id,
    account_id,
    customer_id,
    balance,
    branch_rank
FROM 
    RankedAccounts
WHERE 
    branch_rank <= 2;

-- Problem 5 (Medium) Solution:
SELECT 
    account_id,
    txn_id,
    txn_timestamp,
    LAG(txn_timestamp, 1) OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC) AS previous_txn_timestamp,
    EXTRACT(EPOCH FROM (txn_timestamp - LAG(txn_timestamp, 1) OVER (PARTITION BY account_id ORDER BY txn_timestamp ASC))) / 60 AS minutes_since_last_txn
FROM 
    transactions;

-- Problem 6 (Medium) Solution:
SELECT 
    account_id,
    txn_id,
    txn_type,
    amount,
    txn_timestamp,
    SUM(amount) OVER (
        PARTITION BY account_id 
        ORDER BY txn_timestamp ASC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_ledger_balance
FROM 
    transactions;

-- Problem 7 (Hard) Solution:
WITH RankedTxns AS (
    SELECT 
        a.customer_id,
        t.account_id,
        t.txn_id,
        t.amount,
        t.txn_timestamp,
        DENSE_RANK() OVER (PARTITION BY a.customer_id ORDER BY t.amount DESC) AS rnk
    FROM 
        transactions t
    JOIN 
        accounts a ON t.account_id = a.account_id
)
SELECT 
    customer_id,
    account_id,
    txn_id,
    amount,
    txn_timestamp
FROM 
    RankedTxns
WHERE 
    rnk = 3;

-- Problem 8 (Hard) Solution:
SELECT 
    account_id,
    txn_id,
    amount,
    AVG(amount) OVER (
        PARTITION BY account_id 
        ORDER BY txn_timestamp ASC 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_3_txns,
    FIRST_VALUE(amount) OVER (
        PARTITION BY account_id 
        ORDER BY txn_timestamp ASC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS initial_account_txn_amount,
    amount - FIRST_VALUE(amount) OVER (
        PARTITION BY account_id 
        ORDER BY txn_timestamp ASC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS diff_from_initial
FROM 
    transactions;
