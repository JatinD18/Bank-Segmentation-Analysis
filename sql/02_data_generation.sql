-- Step 2: Generate Simulated Data

SET SESSION cte_max_recursion_depth = 1000000;			-- For increaing the recursion depth limit --
SELECT @@SESSION.cte_max_recursion_depth;

-- Step 2a: Generate 10,000 Customers

-- Generate 10,000 customers with random names, cities, and signup dates
-- Generate 10,000 customers with random names, cities, and signup dates
INSERT INTO customers (first_name, last_name, city, signup_date, email)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 10000
),
first_names AS (
    SELECT 'Aarav' AS name UNION ALL SELECT 'Vivaan' UNION ALL SELECT 'Aditya'
    UNION ALL SELECT 'Arjun' UNION ALL SELECT 'Reyansh' UNION ALL SELECT 'Krishna'
    UNION ALL SELECT 'Priya' UNION ALL SELECT 'Ananya' UNION ALL SELECT 'Sneha'
    UNION ALL SELECT 'Kavya' UNION ALL SELECT 'Riya' UNION ALL SELECT 'Meera'
    UNION ALL SELECT 'Rohan' UNION ALL SELECT 'Karan' UNION ALL SELECT 'Amit'
    UNION ALL SELECT 'Neha' UNION ALL SELECT 'Pooja' UNION ALL SELECT 'Divya'
    UNION ALL SELECT 'Rahul' UNION ALL SELECT 'Vikram'
),
last_names AS (
    SELECT 'Sharma' AS name UNION ALL SELECT 'Patel' UNION ALL SELECT 'Gupta'
    UNION ALL SELECT 'Singh' UNION ALL SELECT 'Kumar' UNION ALL SELECT 'Reddy'
    UNION ALL SELECT 'Mehta' UNION ALL SELECT 'Joshi' UNION ALL SELECT 'Verma'
    UNION ALL SELECT 'Nair' UNION ALL SELECT 'Iyer' UNION ALL SELECT 'Rao'
    UNION ALL SELECT 'Das' UNION ALL SELECT 'Chatterjee' UNION ALL SELECT 'Mukherjee'
    UNION ALL SELECT 'Banerjee' UNION ALL SELECT 'Choudhury' UNION ALL SELECT 'Bhat'
    UNION ALL SELECT 'Pillai' UNION ALL SELECT 'Menon'
),
cities AS (
    SELECT 'Mumbai' AS city UNION ALL SELECT 'Delhi' UNION ALL SELECT 'Bangalore'
    UNION ALL SELECT 'Chennai' UNION ALL SELECT 'Hyderabad' UNION ALL SELECT 'Pune'
    UNION ALL SELECT 'Kolkata' UNION ALL SELECT 'Ahmedabad' UNION ALL SELECT 'Jaipur'
    UNION ALL SELECT 'Lucknow'
)
SELECT 
    (SELECT name FROM first_names ORDER BY RAND() LIMIT 1),
    (SELECT name FROM last_names ORDER BY RAND() LIMIT 1),
    (SELECT city FROM cities ORDER BY RAND() LIMIT 1),
    DATE_ADD('2019-01-01', INTERVAL FLOOR(RAND() * 2000) DAY),
    CONCAT('user', n, '@bankmail.com')
FROM seq;

SELECT COUNT(*) AS total_customers FROM customers;
-- Expected: 10,000
SELECT * FROM customers LIMIT 10;

------------------------------------------------------
 
 -- Step 2b: Generate Accounts (1-3 accounts per customer)
 
 -- Each customer gets 1-3 accounts
INSERT INTO accounts (customer_id, account_type, open_date, status)
SELECT 
    c.customer_id,
    CASE 
        WHEN RAND() < 0.5 THEN 'Savings'
        WHEN RAND() < 0.8 THEN 'Current'
        ELSE 'Fixed Deposit'
    END AS account_type,
    DATE_ADD(c.signup_date, INTERVAL FLOOR(RAND() * 365) DAY) AS open_date,
    CASE 
        WHEN RAND() < 0.15 THEN 'Dormant'
        ELSE 'Active'
    END AS status
FROM customers c;

-- Give ~40% of customers a second account
INSERT INTO accounts (customer_id, account_type, open_date, status)
SELECT 
    c.customer_id,
    CASE 
        WHEN RAND() < 0.5 THEN 'Savings'
        WHEN RAND() < 0.8 THEN 'Current'
        ELSE 'Fixed Deposit'
    END,
    DATE_ADD(c.signup_date, INTERVAL FLOOR(RAND() * 500 + 365) DAY),
    'Active'
FROM customers c
WHERE RAND() < 0.4;

-- Give ~10% of customers a third account
INSERT INTO accounts (customer_id, account_type, open_date, status)
SELECT 
    c.customer_id,
    'Fixed Deposit',
    DATE_ADD(c.signup_date, INTERVAL FLOOR(RAND() * 700 + 500) DAY),
    'Active'
FROM customers c
WHERE RAND() < 0.1;

SELECT COUNT(*) AS total_accounts FROM accounts;
-- Expected: ~14,000-15,000

SELECT account_type, COUNT(*) AS cnt 
FROM accounts 
GROUP BY account_type;

SELECT status, COUNT(*) AS cnt 
FROM accounts 
GROUP BY status;

------------------------------------------------------

-- 2c: Generate Transactions (~500,000 rows)

-- IT HAS A SEPERATE SQL SCRIPT NAMED AS: "02c_generating_transactions.sql"
