# 🏦 SQL for Data Engineering — Day 08
## Topic: Window Functions — ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, FIRST_VALUE, LAST_VALUE, NTILE

**Mentor:** Senior Data Engineer @ Citi Bank  
**Prerequisites:** Day 04 (Aggregates & GROUP BY), Day 05 (JOINs), Day 06 & 07 (Subqueries & Built-ins) ✅  
**Goal:** Master SQL Window (Analytic) Functions for ranking, trend analysis, running totals, and moving averages — the most heavily tested SQL concept in Data Engineering interviews at top financial institutions like Citi Bank.

---

## 📚 What You Will Learn Today

| # | Window Function | Primary Purpose & Banking Use Case |
|---|-----------------|------------------------------------|
| 1 | **`ROW_NUMBER()`** | Sequential row numbering per partition (e.g., deduplicating transaction records) |
| 2 | **`RANK()`** | Rank rows with gaps for ties (e.g., top account balances by branch) |
| 3 | **`DENSE_RANK()`** | Rank rows without gaps for ties (e.g., top 3 loan performers) |
| 4 | **`LEAD()` & `LAG()`** | Access next/previous row values within a partition (e.g., time-delta between consecutive card transactions) |
| 5 | **`FIRST_VALUE()` & `LAST_VALUE()`** | Retrieve boundary values in a frame (e.g., initial deposit vs latest balance) |
| 6 | **`NTILE(N)`** | Distribute rows into N buckets/percentiles (e.g., customer credit risk quartile bucketing) |
| 7 | **Window Frames (`ROWS BETWEEN`)** | Running totals and moving averages over rolling time windows |

---

## 📁 Files in This Folder

| File | Purpose |
|------|---------|
| [`README.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/README.md) | Overview & checklist |
| [`notes.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/notes.md) | Comprehensive mentor breakdown (Concepts, Syntax, Visuals, Cheat Sheet) |
| [`queries.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/queries.sql) | Production-ready banking SQL scripts with line-by-line explanations |
| [`practice.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/practice.sql) | 8 Hands-on interview challenges (3 Easy, 3 Medium, 2 Hard) |
| [`solutions.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/solutions.sql) | Answer key (Attempt practice first!) |
| [`interview_questions.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day08/interview_questions.md) | Citi Bank Senior DE Interview Questions & Answers |

---

## ✅ Day 08 Checklist

- [ ] Read `notes.md` — understand `PARTITION BY` vs `GROUP BY`
- [ ] Run all queries in `queries.sql`
- [ ] Solve 8 practice problems in `practice.sql`
- [ ] Study `interview_questions.md`
- [ ] Commit and push to GitHub

---

> 💡 **Mentor Tip:** In almost EVERY Senior Data Engineering interview at Citi, you will be asked to compute a running sum or find the N-th highest transaction using `DENSE_RANK()` vs `ROW_NUMBER()`. Master these window constructs today!
