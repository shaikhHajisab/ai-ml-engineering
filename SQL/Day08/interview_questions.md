# 🏦 Citi Bank Data Engineering SQL Interview Questions — Day 08

---

### Question 1: Performance Overhead of Window Functions at Petabyte Scale
**Interviewer:** *"How does the SQL database engine physically execute `PARTITION BY` in a distributed engine like Spark SQL or Redshift, and what performance bottlenecks should you watch out for?"*

#### Expected Senior DE Answer:
* **Execution Mechanics:** `PARTITION BY` forces a **shuffle exchange** across the cluster. Data sharing the same partition key (e.g., `account_id` or `branch_id`) is hashed and sent over the network to the same worker node.
* **Bottlenecks (Data Skew):** If one partition key contains 80% of all data (e.g., a massive corporate account with millions of transactions), that single worker node will suffer an Out-Of-Memory (OOM) error while other worker nodes remain idle (Straggler problem).
* **Mitigation:** Two-stage window aggregation or salting partition keys (`PARTITION BY account_id, salt_id`).

---

### Question 2: ROW_NUMBER() vs RANK() vs DENSE_RANK()
**Interviewer:** *"You are writing a query for Citi's top trader bonus distribution. The requirement states that traders with equal sales performance get the same rank, and the next top performer receives the immediate next consecutive rank number (e.g., 1, 1, 2). Which window function must you use?"*

#### Expected Senior DE Answer:
* **Answer:** `DENSE_RANK()`.
* **Explanation:**
  * `ROW_NUMBER()` assigns sequential `1, 2, 3` regardless of ties.
  * `RANK()` assigns `1, 1, 3` (skips rank 2).
  * `DENSE_RANK()` assigns `1, 1, 2` (preserves ties and leaves **no gaps**).

---

### Follow-up Question 1: Why can't you use `WHERE ROW_NUMBER() OVER (...) = 1` directly?
* **Answer:** In SQL Logical Query Processing, `WHERE` evaluates at Step 2, while Window Functions evaluate at Step 6 (after `FROM`, `WHERE`, `GROUP BY`, and `HAVING`). At the time `WHERE` executes, the window function hasn't been computed yet.
* **Solution:** Wrap the window function query inside a Common Table Expression (CTE) or subquery, then filter in the outer query's `WHERE` clause.

---

### Follow-up Question 2: How does `ROWS BETWEEN` differ from `RANGE BETWEEN`?
* **Answer:** `ROWS` treats offset boundaries by physical row counts (e.g., 2 physical rows preceding). `RANGE` treats offset boundaries logically based on values in the `ORDER BY` clause (e.g., date ranges or numeric value ranges). `ROWS` is much faster because it does not require calculating duplicate range value bounds.
