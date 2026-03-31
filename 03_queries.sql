USE LibraryManagementSystem;

-- QUERY 1: Top 5 Most Borrowed Books

SELECT 
    b.title, 
    b.author, 
    COUNT(l.loan_id) as times_borrowed
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id
ORDER BY times_borrowed DESC
LIMIT 5;

-- QUERY 2: Members with Overdue Books

SELECT 
    m.name, 
    m.email, 
    b.title, 
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) as days_overdue
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.status = 'Borrowed' 
  AND l.due_date < CURDATE();

-- QUERY 3: Monthly Fine Collection Report

SELECT 
    DATE_FORMAT(fine_date, '%Y-%m') as month,
    COUNT(*) as number_of_fines,
    SUM(amount) as total_fine_amount,
    SUM(CASE WHEN paid_status = TRUE THEN amount ELSE 0 END) as amount_collected
FROM Fines
WHERE fine_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(fine_date, '%Y-%m')
ORDER BY month DESC;

-- QUERY 4: Members Who Never Borrowed Any Book

SELECT 
    m.member_id, 
    m.name, 
    m.email, 
    m.membership_date
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL;

-- QUERY 5: Most Popular Book Category by Member Type

SELECT 
    m.membership_type,
    b.category,
    COUNT(l.loan_id) as loan_count
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
JOIN Books b ON l.book_id = b.book_id
GROUP BY m.membership_type, b.category
ORDER BY m.membership_type, loan_count DESC;

-- QUERY 6: Books That Have Never Been Borrowed

SELECT 
    b.title, 
    b.author, 
    b.isbn, 
    b.category
FROM Books b
WHERE b.book_id NOT IN (
    SELECT DISTINCT book_id 
    FROM Loans
);

-- QUERY 7: Average Loan Duration by Book Category

SELECT 
    b.category,
    AVG(DATEDIFF(l.return_date, l.loan_date)) as avg_days_borrowed,
    COUNT(l.loan_id) as total_loans
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
WHERE l.return_date IS NOT NULL
GROUP BY b.category
HAVING total_loans > 1
ORDER BY avg_days_borrowed DESC;

-- QUERY 8: Current Borrowing Status with Member Details

SELECT 
    b.title as book_title,
    m.name as member_name,
    m.email,
    l.loan_date,
    l.due_date,
    CASE 
        WHEN l.due_date < CURDATE() THEN 'OVERDUE'
        WHEN l.due_date = CURDATE() THEN 'DUE TODAY'
        ELSE 'Active'
    END as status_description
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.status = 'Borrowed'
ORDER BY l.due_date;

-- QUERY 9: Members with Multiple Active Loans

SELECT 
    m.name,
    m.email,
    COUNT(l.loan_id) as active_loans,
    GROUP_CONCAT(b.title SEPARATOR ', ') as books_borrowed
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.status = 'Borrowed'
GROUP BY m.member_id
HAVING active_loans > 1;

-- QUERY 10: Daily Borrowing Trend (Last 30 Days)

SELECT 
    DATE(loan_date) as borrow_date,
    COUNT(loan_id) as number_of_loans,
    COUNT(DISTINCT member_id) as unique_members
FROM Loans
WHERE loan_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DATE(loan_date)
ORDER BY borrow_date DESC;

-- QUERY 11: Complete Member Activity Summary

SELECT 
    m.member_id,
    m.name,
    m.membership_type,
    COUNT(DISTINCT l.loan_id) as total_borrows,
    SUM(CASE WHEN l.status = 'Borrowed' THEN 1 ELSE 0 END) as current_borrows,
    COUNT(DISTINCT f.fine_id) as number_of_fines,
    COALESCE(SUM(f.amount), 0) as total_fine_amount,
    COALESCE(SUM(CASE WHEN f.paid_status = FALSE THEN f.amount ELSE 0 END), 0) as pending_fines
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
LEFT JOIN Fines f ON m.member_id = f.member_id
GROUP BY m.member_id
ORDER BY total_borrows DESC;

-- QUERY 12: Premium Members Most Active

SELECT 
    m.name,
    m.email,
    COUNT(l.loan_id) as total_loans,
    ROUND(AVG(DATEDIFF(COALESCE(l.return_date, CURDATE()), l.loan_date)), 1) as avg_loan_duration_days
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
WHERE m.membership_type = 'Premium'
GROUP BY m.member_id
ORDER BY total_loans DESC
LIMIT 5;

-- QUERY 13: Admin Dashboard Statistics

SELECT 
    (SELECT COUNT(*) FROM Books) as total_books,
    (SELECT COUNT(*) FROM Members WHERE status = 'Active') as active_members,
    (SELECT COUNT(*) FROM Loans WHERE status = 'Borrowed') as books_on_loan,
    (SELECT COUNT(*) FROM Loans WHERE status = 'Borrowed' AND due_date < CURDATE()) as overdue_books,
    (SELECT COALESCE(SUM(amount), 0) FROM Fines WHERE paid_status = FALSE) as pending_fine_revenue;
