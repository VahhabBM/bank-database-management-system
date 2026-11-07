CREATE OR REPLACE VIEW view_customer_accounts AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone_number,
    a.account_number,
    a.account_type,
    a.balance,
    a.status AS account_status,
    b.branch_name,
    b.city AS branch_city
FROM customer c
JOIN account_owners ao ON c.customer_id = ao.customer_id
JOIN account a ON ao.account_number = a.account_number
JOIN branch b ON a.branch_id = b.branch_id;



CREATE OR REPLACE VIEW view_overdue_installments AS
SELECT 
    i.installment_id,
    l.loan_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone_number AS customer_phone,
    l.loan_type,
    i.installment_number,
    i.amount AS installment_amount,
    i.due_date,
    i.status AS installment_status
FROM installment i
JOIN loan l ON i.loan_id = l.loan_id
JOIN customer c ON l.customer_id = c.customer_id
WHERE i.status IN ('Overdue', 'Unpaid') AND i.due_date < CURRENT_DATE;