-- ۱. جدول شعبه
CREATE TABLE branch (
    branch_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255)
);

-- ۲. جدول مشتری
CREATE TABLE customer (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(15) UNIQUE,
    address VARCHAR(255)
);

-- ۳. جدول کارمند
CREATE TABLE employee (
    employee_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL CHECK (salary > 0),
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    branch_id INT NOT NULL,
    CONSTRAINT FK_employee_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- ۴. جدول حساب
CREATE TABLE account (
    account_number INT GENERATED ALWAYS AS IDENTITY (START WITH 1000) PRIMARY KEY,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    open_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Blocked', 'Closed')),
    branch_id INT NOT NULL,
    CONSTRAINT FK_account_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- ۵. جدول کارت بانکی
CREATE TABLE card (
    card_number CHAR(16) PRIMARY KEY,
    pin VARCHAR(4) NOT NULL,
    cvv2 VARCHAR(4) NOT NULL,
    expiry_date DATE NOT NULL,
    daily_limit DECIMAL(18,2) NOT NULL DEFAULT 50000000 CHECK (daily_limit > 0),
    account_number INT NOT NULL,
    CONSTRAINT FK_card_account FOREIGN KEY (account_number) REFERENCES account(account_number)
);

-- ۶. جدول تراکنش
CREATE TABLE transaction_log (
    transaction_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    amount DECIMAL(18,2) NOT NULL CHECK (amount > 0),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Success' CHECK (status IN ('Success', 'Failed', 'Pending')),
    account_number INT NOT NULL,
    CONSTRAINT FK_transaction_account FOREIGN KEY (account_number) REFERENCES account(account_number)
);

-- ۷. جدول وام
CREATE TABLE loan (
    loan_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    loan_type VARCHAR(50) NOT NULL,
    total_amount DECIMAL(18,2) NOT NULL CHECK (total_amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    total_installments INT NOT NULL CHECK (total_installments > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    customer_id INT NOT NULL,
    CONSTRAINT FK_loan_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- ۸. جدول قسط
CREATE TABLE installment (
    installment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    installment_number INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL CHECK (amount > 0),
    due_date DATE NOT NULL,
    payment_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Unpaid' CHECK (status IN ('Paid', 'Unpaid', 'Overdue')),
    loan_id INT NOT NULL,
    CONSTRAINT FK_installment_loan FOREIGN KEY (loan_id) REFERENCES loan(loan_id)
);

-- ۹. جدول ضامن
CREATE TABLE guarantor (
    guarantor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    guarantee_type VARCHAR(50) NOT NULL
);

-- ۱۰. جدول چک
CREATE TABLE cheque (
    cheque_number VARCHAR(50) PRIMARY KEY,
    amount DECIMAL(18,2) NOT NULL CHECK (amount > 0),
    due_date DATE NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    account_number INT NOT NULL,
    CONSTRAINT FK_cheque_account FOREIGN KEY (account_number) REFERENCES account(account_number)
);

-- ۱۱. جدول واسط صاحبان حساب (M:N Owns)
CREATE TABLE account_owners (
    customer_id INT NOT NULL,
    account_number INT NOT NULL,
    PRIMARY KEY (customer_id, account_number),
    CONSTRAINT FK_owners_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT FK_owners_account FOREIGN KEY (account_number) REFERENCES account(account_number)
);

-- ۱۲. جدول واسط ضامنین وام (M:N Secured_By)
CREATE TABLE loan_guarantors (
    loan_id INT NOT NULL,
    guarantor_id INT NOT NULL,
    PRIMARY KEY (loan_id, guarantor_id),
    CONSTRAINT FK_table_loan FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
    CONSTRAINT FK_table_guarantor FOREIGN KEY (guarantor_id) REFERENCES guarantor(guarantor_id)
);