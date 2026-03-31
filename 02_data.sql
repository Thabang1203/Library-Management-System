USE LibraryManagementSystem;

-- Insert Books
INSERT INTO Books (title, author, isbn, publisher, publication_year, category, total_copies, available_copies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Scribner', 1925, 'Fiction', 5, 5),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'HarperCollins', 1960, 'Fiction', 3, 3),
('1984', 'George Orwell', '9780451524935', 'Signet', 1949, 'Dystopian', 4, 4),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 'Penguin', 1813, 'Romance', 2, 2),
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Houghton Mifflin', 1937, 'Fantasy', 6, 6);

-- Insert Members
INSERT INTO Members (name, email, phone, address, membership_type, max_books_allowed) VALUES
('John Doe', 'john@email.com', '1234567890', '123 Main St, NY', 'Premium', 10),
('Jane Smith', 'jane@email.com', '0987654321', '456 Oak Ave, CA', 'Regular', 5),
('Bob Wilson', 'bob@email.com', '5551234567', '789 Pine Rd, TX', 'Regular', 5);

-- Insert Users (password_hash uses SHA2 for demo)
INSERT INTO Users (member_id, username, password_hash, role) VALUES
(1, 'john_doe', SHA2('password123', 256), 'Member'),
(2, 'jane_smith', SHA2('password456', 256), 'Member'),
(NULL, 'admin', SHA2('admin123', 256), 'Admin');

-- Insert Sample Loans
INSERT INTO Loans (book_id, member_id, loan_date, due_date, status) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Borrowed'),
(3, 2, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), 'Borrowed'),
(5, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), 'Borrowed');

-- Insert a returned book (to test fines)
INSERT INTO Loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(2, 1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Returned');

-- This will trigger a fine automatically if you have triggers set up
-- If not, manually insert a fine:

INSERT INTO Fines (loan_id, member_id, amount, fine_date, paid_status) VALUES
(4, 1, 1.50, DATE_SUB(CURDATE(), INTERVAL 3 DAY), FALSE);
