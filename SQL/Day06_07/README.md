# 🏦 SQL for Data Engineering — Day 06 & 07 (Combined Special Module)
## Topics: Subqueries, Correlated Subqueries, EXISTS, ANY/ALL, CASE WHEN, COALESCE, NULLIF, String & Date Functions

**Mentor:** Senior Data Engineer @ Citi Bank  
**Prerequisites:** Day 04 (Aggregates & GROUP BY) & Day 05 (JOINs) ✅  
**Goal:** Master intermediate-to-advanced data manipulation, conditional logic, complex filtering, and string/date transformations for banking ETL pipelines and Citi Data Engineering interviews.

---

## 📚 What You Will Learn Today

| # | Topic / Function | Primary Purpose & Banking Use Case |
|---|------------------|------------------------------------|
| 1 | **Scalar & Multi-row Subqueries** | Nesting queries for dynamic filtering (e.g., accounts with balances > branch average) |
| 2 | **Correlated Subqueries** | Outer-inner row dependency queries (e.g., highest transaction per account) |
| 3 | **`EXISTS` / `NOT EXISTS`** | Efficient boolean membership check in large datasets (e.g., customers with fraud alerts) |
| 4 | **`ANY` / `ALL`** | Quantified comparison operators against subquery result sets |
| 5 | **`CASE WHEN`** | Conditional logic & feature engineering (e.g., risk scoring, transaction categorizing) |
| 6 | **`COALESCE` & `NULLIF`** | NULL handling & zero-division protection in financial metrics |
| 7 | **String Functions** | Data cleaning & text transformations (`CONCAT`, `SUBSTRING`, `REPLACE`, `TRIM`, `UPPER`, `LOWER`) |
| 8 | **Date Functions** | Date arithmetic, truncation, and windowing (`DATEADD`, `DATEDIFF`, `DATE_TRUNC`, `EXTRACT`) |

---

## 📁 Files in This Folder

| File | Purpose |
|------|---------|
| [`README.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/README.md) | Module overview & checklist |
| [`notes.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/notes.md) | Comprehensive mentor breakdown (Concepts, Syntax, Visuals, Revision) |
| [`queries.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/queries.sql) | Production-ready banking SQL scripts with line-by-line explanations |
| [`practice.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/practice.sql) | 8 Hands-on interview challenges (3 Easy, 3 Medium, 2 Hard) |
| [`solutions.sql`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/solutions.sql) | Solutions space (Attempt practice first!) |
| [`interview_questions.md`](file:///c:/Users/Haji%20Shaikh/Desktop/ML/ai-ml-engineering/SQL/Day06_07/interview_questions.md) | Citi Bank Senior DE Interview Questions & Answers |

---

## ✅ Day 06 & 07 Checklist

- [ ] Study `notes.md` thoroughly (Parts 1 - 4 & Part 10 Coding Style)
- [ ] Execute & analyze all queries in `queries.sql`
- [ ] Complete 8 practice problems in `practice.sql`
- [ ] Review Citi Interview Q&A in `interview_questions.md`
- [ ] Push updates to your GitHub repository

---

> 💡 **Mentor Tip:** At Citi Bank, financial pipelines process millions of transactions daily. You will frequently combine `CASE WHEN` inside `SUM()` for conditional aggregation, and use `EXISTS` instead of `IN` for high-performance fraud detection pipelines. Master these patterns today!
