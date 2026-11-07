-- 1. the customers information 

SELECT * FROM customer ;

-- 2. customers with multiple accounts

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(ao.account_number) AS account_count
FROM customer c
JOIN account_owners ao ON c.customer_id = ao.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(ao.account_number) > 1;

-- 3. accounts with balance greater than 100000

SELECT * 
FROM account 
WHERE balance > 100000;

-- 4. branches with their total accounts

SELECT 
    b.branch_id,
    b.branch_name,
    COUNT(a.account_number) AS total_accounts
FROM branch b
LEFT JOIN account a ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name;

-- 5. customers with their account numbers

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ao.account_number
FROM customer c
JOIN account_owners ao ON c.customer_id = ao.customer_id;

-- 6. transactions for each customer

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    t.transaction_id,
    t.type AS transaction_type,
    t.amount,
    t.timestamp,
    t.status
FROM customer c
JOIN account_owners ao ON c.customer_id = ao.customer_id
JOIN transaction_log t ON ao.account_number = t.account_number
ORDER BY c.customer_id, t.timestamp DESC;

-- 7. customers with loans

SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone_number
FROM customer c
JOIN loan l ON c.customer_id = l.customer_id;

-- 8. average balance per branch

SELECT 
    b.branch_id,
    b.branch_name,
    ROUND(AVG(a.balance), 2) AS average_balance
FROM branch b
JOIN account a ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name;

-- 9. maximum transaction amount per branch

SELECT 
    b.branch_id,
    b.branch_name,
    MAX(t.amount) AS max_transaction_amount
FROM branch b
JOIN account a ON b.branch_id = a.branch_id
JOIN transaction_log t ON a.account_number = t.account_number
GROUP BY b.branch_id, b.branch_name;

-- 10. customers with their total loans

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(l.loan_id) AS total_loans
FROM customer c
LEFT JOIN loan l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 11. customers with accounts above average balance

SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.balance
FROM customer c
JOIN account_owners ao ON c.customer_id = ao.customer_id
JOIN account a ON ao.account_number = a.account_number
WHERE a.balance > (SELECT AVG(balance) FROM account);

-- 12. branch with the highest number of accounts

SELECT 
    branch_id,
    branch_name,
    account_count
FROM (
    SELECT 
        b.branch_id,
        b.branch_name,
        COUNT(a.account_number) AS account_count
    FROM branch b
    LEFT JOIN account a ON b.branch_id = a.branch_id
    GROUP BY b.branch_id, b.branch_name
) AS branch_counts
ORDER BY account_count DESC
LIMIT 1;

--- 13. customers without loans

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    phone_number
FROM customer
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM loan 
    WHERE customer_id IS NOT NULL
);