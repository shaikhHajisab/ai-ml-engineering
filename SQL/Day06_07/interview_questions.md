# 🏦 Citi Bank Data Engineering SQL Interview Questions — Day 06 & 07

---

### Question 1: Subqueries vs JOIN Performance in Distributed Databases
**Interviewer:** *"In a large scale financial database with hundreds of millions of rows, when would you choose an `EXISTS` correlated subquery over an `INNER JOIN` with `DISTINCT`?"*

#### Expected Senior DE Answer:
* **`INNER JOIN` with `DISTINCT`:** Forces the database optimizer to perform a join, create an intermediate combined result set, and then run a hash aggregate or sort-unique operation to deduplicate rows.
* **`EXISTS` Subquery:** Evaluates semi-join logic. As soon as the first matching inner record is satisfied for an outer row, evaluation for that outer row **stops immediately** (short-circuiting). It does not produce duplicate outer rows, eliminating the expensive `DISTINCT` deduplication pass.
* **Verdict:** In Citi's high-throughput ETL pipelines auditing tables like `customers` against `transactions`, `WHERE EXISTS (...)` significantly outperforms `JOIN` + `DISTINCT`.

---

### Question 2: Defensive SQL & NULL Pointer Bugs in Financial ETLs
**Interviewer:** *"Why does `NOT IN (subquery)` return 0 rows if any row returned by the subquery is `NULL`? How do you fix it?"*

#### Expected Senior DE Answer:
* **The `NULL` Trapping Mechanics:** In SQL 3-valued logic (`TRUE`, `FALSE`, `UNKNOWN`), `val NOT IN (1, 2, NULL)` expands to:
  `val <> 1 AND val <> 2 AND val <> NULL`.
  Since any comparison with `NULL` yields `UNKNOWN`, the whole expression evaluates to `UNKNOWN`, resulting in zero rows returned.
* **The Fix:**
  1. Use `WHERE NOT EXISTS (...)`, which handles `NULL` values safely because it checks for row existence, not value equivalence.
  2. Filter `NULL`s explicitly in the subquery: `WHERE col IS NOT NULL`.

---

### Follow-up Question 1: Conditional Aggregation vs Filter Clauses
**Interviewer:** *"How do `CASE WHEN` inside `SUM()` compare with the SQL standard `FILTER (WHERE ...)` clause in PostgreSQL/Spark SQL?"*

#### Expected Answer:
* Both compute conditional aggregates in a single table scan. `SUM(CASE WHEN status = 'APPROVED' THEN amount ELSE 0 END)` is standard across all database engines (Oracle, DB2, Teradata, Postgres, Spark SQL). `SUM(amount) FILTER (WHERE status = 'APPROVED')` is cleaner ANSI SQL:2003 syntax supported in modern engines like Postgres and PySpark SQL. At Citi, `CASE WHEN` is widely used for cross-platform engine compatibility.

---

### Follow-up Question 2: SARGability and Function Wrappers on Indexes
**Interviewer:** *"Why should you never write `WHERE UPPER(email) = 'USER@CITI.COM'` in a production search query?"*

#### Expected Answer:
* Wrapping a database column in a function (`UPPER(email)`) makes the predicate **non-SARGable** (Search Argument Able). The engine cannot utilize a standard B-Tree index on `email` and is forced to execute a full table scan, evaluating `UPPER()` on every single row.
* **Solution:** Standardize casing upon ingestion in the ETL pipeline, or create an expression-based functional index (`CREATE INDEX idx_upper_email ON customers (UPPER(email))`).
