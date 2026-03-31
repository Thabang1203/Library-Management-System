CREATE DATABASE IF NOT EXISTS LibraryManagementSystem;
USE LibraryManagementSystem;

-- Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    publisher VARCHAR(100),
    publication_year INT,
    category VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    membership_date DATE DEFAULT (CURRENT_DATE),
    membership_type ENUM('Regular', 'Premium') DEFAULT 'Regular',
    status ENUM('Active', 'Suspended') DEFAULT 'Active',
    max_books_allowed INT DEFAULT 5
);

-- Loans Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed',
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Fines Table
CREATE TABLE Fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    fine_date DATE NOT NULL,
    paid_status BOOLEAN DEFAULT FALSE,
    payment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Users Table (for role differentiation)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Librarian', 'Member') DEFAULT 'Member',
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
