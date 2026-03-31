-- Sample Data for LibraryDB
USE LibraryDB;

INSERT INTO Books (title, author, isbn, total_copies, available_copies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 3, 3),
('1984', 'George Orwell', '9780451524935', 2, 2),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 4, 4);

INSERT INTO Members (name, email, phone, status) VALUES
('John Doe', 'john@email.com', '1234567890', 'Active'),
('Jane Smith', 'jane@email.com', '0987654321', 'Active');
