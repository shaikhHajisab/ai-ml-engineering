-- =============================================================================
-- SQL for Data Engineering — Day 08 Practice Exercises
-- Target: Citi Bank Data Engineering Coding Workshop
-- Topic: Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, FIRST_VALUE, NTILE)
-- Instructions: Write your SQL queries below each problem statement.
-- DO NOT LOOK AT solutions.sql UNTIL YOU HAVE ATTEMPTED ALL QUESTIONS!
-- =============================================================================

-- Provided Schema:
-- customers(customer_id, first_name, last_name, city, join_date)
-- accounts(account_id, customer_id, branch_id, account_type, balance, status)
-- transactions(txn_id, account_id, txn_type, amount, txn_timestamp)
-- credit_cards(card_number, account_id, credit_limit, current_balance)

-- -----------------------------------------------------------------------------
-- EASY PROBLEMS (3)
-- -----------------------------------------------------------------------------

-- Problem 1 (Easy): Basic ROW_NUMBER
-- Task: Assign a sequential row number to every transaction per account_id,
-- ordered by txn_timestamp ASC.
-- Return account_id, txn_id, amount, txn_timestamp, and txn_seq_num.

-- Write Query 1 Below:




-- Problem 2 (Easy): Simple Ranking
-- Task: Rank all accounts across the entire bank by their balance in descending order.
-- Use DENSE_RANK() so ties share ranks without skipping.
-- Return account_id, customer_id, balance, and balance_rank.

-- Write Query 2 Below:




-- Problem 3 (Easy): Basic LAG
-- Task: For each transaction, display the current transaction amount and the 
-- immediately previous transaction amount for the SAME account.
-- Return account_id, txn_id, amount, and previous_txn_amount.

-- Write Query 3 Below:




-- -----------------------------------------------------------------------------
-- MEDIUM PROBLEMS (3)
-- -----------------------------------------------------------------------------

-- Problem 4 (Medium): Partitioned Ranking (Top-N per Category)
-- Task: Find the top 2 highest balance accounts for EACH branch_id.
-- Use DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) inside a CTE.
-- Return branch_id, account_id, customer_id, balance, and branch_rank.

-- Write Query 4 Below:




-- Problem 5 (Medium): Transaction Time-Delta Velocity Detection
-- Task: Citi Fraud Detection engine needs to identify suspicious rapid transactions.
-- Calculate the time difference (in minutes or seconds) between each transaction and 
-- the previous transaction for the SAME account.
-- Return account_id, txn_id, txn_timestamp, previous_txn_timestamp, and minutes_since_last_txn.

-- Write Query 5 Below:




-- Problem 6 (Medium): Cumulative Running Balance
-- Task: Calculate the running ledger balance for each account across transactions 
-- ordered by txn_timestamp ASC.
-- Return account_id, txn_id, txn_type, amount, txn_timestamp, and running_ledger_balance.

-- Write Query 6 Below:




-- -----------------------------------------------------------------------------
-- HARD PROBLEMS (2)
-- -----------------------------------------------------------------------------

-- Problem 7 (Hard): N-th Highest Transaction per Customer with Tie Breaking
-- Task: Write a query to find the 3rd highest transaction amount for EACH customer.
-- If a customer has fewer than 3 transactions, exclude them from the result set.
-- Handle ties gracefully using DENSE_RANK().
-- Return customer_id, account_id, txn_id, amount, and txn_timestamp.

-- Write Query 7 Below:




-- Problem 8 (Hard): Rolling 3-Transaction Moving Average & Boundary Delta
-- Task: Construct a Citi Analytics query computing:
-- 1. A 3-event rolling moving average of transaction amount per account (current row + 2 preceding).
-- 2. The initial transaction amount (`FIRST_VALUE`) for that account partition.
-- 3. The difference between the current amount and the initial transaction amount.
-- Return account_id, txn_id, amount, rolling_avg_3_txns, initial_account_txn_amount, and diff_from_initial.

-- Write Query 8 Below:


