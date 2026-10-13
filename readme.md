
<div align="center">

<a href="https://www.postgresql.org/">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/postgresql/postgresql-original.svg" alt="PostgreSQL logo" width="88" />
</a>

# PostgreSQL Learning

**From SQL fundamentals to advanced querying and real-world database design.**

A structured, hands-on learning journey focused on writing clean SQL, understanding how relational databases work, and using **PostgreSQL** confidently in practical applications.

<p>
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/SQL-Learning-0F172A?style=for-the-badge&logo=databricks&logoColor=white" alt="SQL Learning" />
  <img src="https://img.shields.io/badge/Status-In%20Progress-F59E0B?style=for-the-badge" alt="Status: In Progress" />
  <img src="https://img.shields.io/badge/Approach-Hands--On-16A34A?style=for-the-badge" alt="Hands-on approach" />
</p>

[Overview](#-overview) · [Learning Roadmap](#-learning-roadmap) · [Repository Structure](#-repository-structure) · [Practice](#-practice-plan) · [Project](#-capstone-project) · [Resources](#-learning-resources)

</div>

---

## 📖 Overview

This repository documents my **PostgreSQL and SQL practice**, starting with core relational database concepts and progressing to complex queries, reusable query patterns, and performance fundamentals.

My earlier [Data Science learning repository](https://github.com/ggauravky/Data-Science-Learning/tree/main/008%20Databases) already includes notes on **MySQL, SQL basics, CRUD, joins, constraints, transactions, subqueries, and indexes**. This repository builds on that foundation with a **PostgreSQL-first approach** and more executable practice.

| Focus | What you'll find |
| :--- | :--- |
| **Concept Notes** | Short Markdown notes with clear explanations and syntax |
| **SQL Examples** | Small, runnable queries for each major topic |
| **Query Practice** | Easy, medium, and hard exercises with solutions |
| **Database Design** | Tables, keys, constraints, and relationships |
| **Advanced SQL** | CTEs, window functions, subqueries, and set operations |
| **Performance** | Indexes, query plans, and optimization basics |
| **Projects** | A practical relational database capstone |

> [!NOTE]
> **Learning status:** This is an evolving repository. The roadmap and directory tree below describe the intended scope; not every note, exercise, or project file has been added yet.

## 🗺️ Learning Roadmap

| Module | Topics | Progress |
| :--- | :--- | :---: |
| **01 · Fundamentals** | What is SQL?, RDBMS, tables, rows, columns, PostgreSQL setup | 🟡 Started |
| **02 · DDL & DML** | `CREATE`, `ALTER`, `DROP`, data types, constraints, `INSERT`, `UPDATE`, `DELETE` | ⬜ Planned |
| **03 · Queries & Joins** | `SELECT`, `WHERE`, `DISTINCT`, `ORDER BY`, `LIMIT`, `OFFSET`, all major joins | ⬜ Planned |
| **04 · Aggregations** | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `HAVING` | ⬜ Planned |
| **05 · Subqueries & CTEs** | Nested queries, correlated subqueries, `WITH` clauses | ⬜ Planned |
| **06 · Advanced Querying** | Window functions, `PARTITION BY`, `UNION`, `UNION ALL` | ⬜ Planned |
| **07 · Optimization** | Single/composite indexes, query plans, `EXPLAIN ANALYZE` | ⬜ Planned |
| **08 · PostgreSQL Essentials** | `UUID`, `JSONB`, `RETURNING`, `ON CONFLICT`, transactions | ⬜ Planned |

**Current checkpoint**

- [x] Draft notes for **What is SQL?**
- [ ] Set up a reusable PostgreSQL practice database
- [ ] Work through each module with executable queries
- [ ] Solve at least **30–50 SQL practice problems**
- [ ] Build and document the capstone database
- [ ] Review query performance with real execution plans

> **Progress tracking:** Checkpoints will be updated as topics are practiced and files are committed, rather than marking previously known concepts as completed in this new repository.

## 🗂️ Repository Structure

*Planned organization; directories will be created as learning progresses.*

```text
PostgreSQL-Learning/
│
├── README.md
│
├── 01-Fundamentals/
│   └── 01-What-is-SQL.md
│
├── 02-DDL-and-DML/
├── 03-Queries-and-Joins/
├── 04-Aggregations/
├── 05-Subqueries-and-CTEs/
├── 06-Window-Functions-and-Set-Operations/
├── 07-Indexes-and-Optimization/
├── 08-PostgreSQL-Essentials/
│
├── Practice/
│   ├── Easy/
│   ├── Medium/
│   └── Hard/
│
└── Projects/
    └── E-Commerce-Database/
        ├── 01-schema.sql
        ├── 02-seed.sql
        ├── 03-queries.sql
        └── README.md
```

**File convention:** Use `.md` for explanations and `.sql` for queries that can be executed in PostgreSQL. Keep example data and project instructions with their related SQL files.

## 💻 SQL in Practice

A small example using **joins, aggregation, sorting, and limiting results**:

```sql
-- Find the top 5 customers by total spending.
-- Assumes customers(id, name) and orders(id, customer_id, total_amount).
SELECT
    c.name,
    COUNT(o.id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.id
GROUP BY c.id, c.name
ORDER BY total_spent DESC
LIMIT 5;
```

This query demonstrates how several SQL concepts work together in a real reporting scenario.

## 🎯 Practice Plan

For every topic:

1. **Understand** the concept in simple language.
2. **Write** the syntax and a small example.
3. **Execute** the query in PostgreSQL and check its result.
4. **Solve** practice questions without copying the answer.
5. **Revisit** mistakes and improve the query when possible.

| Level | Practice goal |
| :--- | :--- |
| 🟢 **Easy** | Filtering, sorting, basic CRUD, aggregate functions |
| 🟡 **Medium** | Multi-table joins, grouping, nested queries, CTEs |
| 🔴 **Hard** | Window functions, complex reporting, optimization |

Existing SQL problem-solving practice: [LeetCode solutions in problem-solving](https://github.com/ggauravky/problem-solving/tree/main/LeetCode). This repository will focus on **PostgreSQL-specific practice and runnable SQL files**, avoiding unnecessary duplication.

## 🛍️ Capstone Project

### E-Commerce Database — Planned

Design a small but realistic database for an online store.

**Core tables:** `customers`, `products`, `categories`, `orders`, `order_items`, and `payments`.

**What the project will demonstrate:**

- Relational schema design with primary and foreign keys.
- Constraints to protect data quality.
- Seed data for realistic testing.
- Queries for revenue, popular products, customer orders, and sales trends.
- CTEs and window functions for advanced reports.
- Indexes and `EXPLAIN ANALYZE` for query performance comparisons.

**Target deliverables:** schema, seed script, practice queries, and a short project-specific README with instructions and example outputs.

## ⚙️ Getting Started

**Requirements:** PostgreSQL installed locally (or access to a PostgreSQL instance) and a SQL client such as `psql` or pgAdmin.

Check that the PostgreSQL command-line tools are available:

```bash
psql --version
```

Create and open a local practice database (using a PostgreSQL role configured on your machine):

```bash
createdb postgresql_learning
psql -d postgresql_learning
```

Once the capstone files are added, its schema and seed data can be loaded with:

```bash
psql -d postgresql_learning -f Projects/E-Commerce-Database/01-schema.sql
psql -d postgresql_learning -f Projects/E-Commerce-Database/02-seed.sql
```

> [!TIP]
> Local connection details differ by OS and PostgreSQL installation. If your environment requires a username or host, pass `-U` and/or `-h` to the commands above.

## 📚 Learning Resources

| Resource | Why it's useful |
| :--- | :--- |
| [PostgreSQL Documentation](https://www.postgresql.org/docs/current/) | Official reference for PostgreSQL features and commands |
| [PostgreSQL Tutorial](https://www.postgresql.org/docs/current/tutorial.html) | Guided introduction to PostgreSQL and SQL |
| [PostgreSQL Exercises](https://pgexercises.com/) | Practice SQL using progressively harder problems |
| [LeetCode SQL 50](https://leetcode.com/studyplan/top-sql-50/) | Query-based interview practice |
| [SQLBolt](https://sqlbolt.com/) | Short interactive SQL lessons |

## 🔗 Related Work

- [Data-Science-Learning — Databases](https://github.com/ggauravky/Data-Science-Learning/tree/main/008%20Databases): earlier relational database and MySQL notes.
- [problem-solving](https://github.com/ggauravky/problem-solving): SQL and algorithm practice.
- [InstaX](https://github.com/ggauravky/InstaX): application-level PostgreSQL with Prisma.
- [SmartMess](https://github.com/ggauravky/SmartMess): PostgreSQL schema and relational database usage.

---

<div align="center">

**Learn the concept · Write the query · Understand the result · Build with it**

Maintained by [**@ggauravky**](https://github.com/ggauravky)

</div>
