# 🏦 SQL for Data Engineering — Day 05
## Topic: JOINs — INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS

**Mentor:** Senior Data Engineer @ Citi Bank
**Prerequisite:** Day 04 — Aggregate Functions ✅
**Goal:** Combine data from multiple banking tables — the real power of relational databases

---

## 📚 What You Will Learn Today

| # | JOIN Type | Returns |
|---|-----------|---------|
| 1 | `INNER JOIN` | Only rows that match in BOTH tables |
| 2 | `LEFT JOIN` | ALL rows from left + matching rows from right (NULLs for no match) |
| 3 | `RIGHT JOIN` | ALL rows from right + matching rows from left (NULLs for no match) |
| 4 | `FULL OUTER JOIN` | ALL rows from BOTH tables (NULLs where no match) |
| 5 | `SELF JOIN` | A table joined with itself |
| 6 | `CROSS JOIN` | Every row from left × every row from right (cartesian product) |

---

## 📁 Files in This Folder

| File | Purpose |
|------|---------|
| `README.md` | Overview |
| `notes.md` | Full lesson — concept, syntax, visuals, cheat sheet |
| `queries.sql` | All working SQL JOIN examples |
| `practice.sql` | YOUR practice space |
| `solutions.sql` | Open ONLY after attempting |
| `interview_questions.md` | Citi Interview Q&A |

---

## ✅ Day 05 Checklist

- [ ] Read `notes.md` — understand the Venn diagram mentally
- [ ] Run all queries in `queries.sql`
- [ ] Attempt all 8 practice questions (no autocomplete!)
- [ ] Review `solutions.sql`
- [ ] Study `interview_questions.md`

---

> 💡 **Mentor Tip:** In every Citi interview, you will get at least one question like:
> *"Write a query to find customers who have NO transactions."*
> That's a LEFT JOIN with a NULL check — today you'll master this completely.
