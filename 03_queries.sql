-- Library Management System - Complex Queries
USE LibraryDB;

-- Top 10 Most Borrowed Books
SELECT b.title, COUNT(l.loan_id) as borrow_count
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id
ORDER BY borrow_count DESC
LIMIT 10;
