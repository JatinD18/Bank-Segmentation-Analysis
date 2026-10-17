-- Step 1: Create Database & Schema

-- Create the database
CREATE DATABASE IF NOT EXISTS bank_segmentation;
USE bank_segmentation;

-- =============================================
-- TABLE 1: Customers
-- =============================================
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL,
    email VARCHAR(100)
);

-- =============================================
-- TABLE 2: Accounts
-- =============================================
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type ENUM('Savings', 'Current', 'Fixed Deposit') NOT NULL,
    open_date DATE NOT NULL,
    status ENUM('Active', 'Dormant') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =============================================
-- TABLE 3: Transactions
-- =============================================
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type ENUM('credit', 'debit') NOT NULL,
    service VARCHAR(100) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

SHOW TABLES;
-- Should show: accounts, customers, transactions
