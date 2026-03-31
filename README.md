# Library-Management-System
A relational database system for tracking books, members, and loans with 10+ complex SQL queries and role-based access.
# Library Management System 📚

A comprehensive relational database system for managing library operations including books, members, loans, and fines.

## 🚀 Features

- **Complete CRUD operations** for books, members, and loans
- **10+ complex SQL queries** with JOINs, subqueries, and aggregates
- **Role-based access** (Admin vs Standard User)
- **Automated fine calculation** for overdue books
- **Real-time availability tracking**

## 🛠️ Technologies

- MySQL 8.0+
- draw.io (ER Diagram)
- Git & GitHub

## 📁 Project Structure

```
Library-Management-System/
├── sql/
│   ├── 01_schema.sql      # Database schema
│   ├── 02_data.sql        # Sample data
│   └── 03_queries.sql     # Complex queries
├── docs/
│   └── ER_Diagram.drawio  # Entity relationship diagram
├── scripts/
│   └── backup.sh          # Backup script
└── README.md
```

## 🏃 Quick Start

1. Clone the repository
2. Import the database:
   ```bash
   mysql -u root -p < sql/01_schema.sql
   ```
3. Load sample data:
   ```bash
   mysql -u root -p < sql/02_data.sql
   ```
4. Run queries:
   ```sql
   USE LibraryDB;
   SELECT * FROM Books;
   ```

## 📊 Sample Queries

### Top 10 Most Borrowed Books
```sql
SELECT b.title, COUNT(l.loan_id) as borrow_count
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id
ORDER BY borrow_count DESC
LIMIT 10;
```

