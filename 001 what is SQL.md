
# What is SQL?

## 1. Meaning of SQL
- **SQL** stands for **Structured Query Language**.
- It is used to work with data stored in a **Relational Database Management System (RDBMS)**.
- SQL helps us **store, read, update, and delete** data.

## 2. What is a Relational Database?
- A relational database stores data in **tables**.
- Each table contains **rows** and **columns**.
- **Row:** One complete record (e.g., one student's details).
- **Column:** One type of information (e.g., name or age).
- Different tables can be connected using **relationships**.

**Example: Students table**

| id | name | age |
|---|---|---|
| 1 | Rahul | 20 |
| 2 | Priya | 21 |

## 3. Why Do We Use SQL?
SQL makes it easy to:
- **Add** new records.
- **Read** or search existing records.
- **Update** information.
- **Delete** unwanted records.
- **Filter and sort** large amounts of data.

**Example:**

```sql
SELECT name, age
FROM students
WHERE age > 20;
```

This query returns the names and ages of students older than 20.

## 4. SQL Works with Different Databases
- SQL is a **standard language**.
- Popular relational databases include **PostgreSQL**, **MySQL**, and **SQL Server**.
- Their basic SQL commands are similar, but some features and syntax differ.

## 5. How SQL Works
1. A user or application sends an SQL query.
2. The **database engine** reads and processes the query.
3. The engine accesses the stored data.
4. The database returns the result.

**Flow:** User / Application → SQL Query → Database Engine → Data → Result

## 6. Simple Real-Life Example
Think of a database as a **filing cabinet**:
- **Database:** The whole cabinet.
- **Table:** A folder containing similar records.
- **Row:** One record in that folder.
- **Column:** One detail in each record.
- **SQL:** The instructions used to find or change records.

## Quick Revision
- **SQL:** Language used to manage relational data.
- **RDBMS:** Software that stores and manages related tables.
- **Table:** Data arranged in rows and columns.
- **SQL query:** An instruction sent to a database.
- **Examples:** PostgreSQL, MySQL, SQL Server.
  