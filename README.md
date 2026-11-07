# Bank Database Management System

A comprehensive relational database project designed and implemented using **PostgreSQL**, covering the complete database development lifecycle, from conceptual modeling and ER diagrams to SQL implementation, advanced database objects, and Python integration.

This project was developed as part of a university Database course.

## Overview

The goal of this project is to design and implement a relational database for a banking system that manages customers, bank branches, employees, accounts, cards, transactions, loans, installments, guarantors, and cheques.

The project follows a structured database development process, including entity identification, relationship modeling, relational schema design, normalization, SQL implementation, and database programming.

## Key Features

- **Database Design:** Conceptual modeling using Entity-Relationship (ER) diagrams.
- **Relational Schema:** Implementation of 12 relational tables with primary keys, foreign keys, and appropriate constraints.
- **Database Normalization:** Schema design based on Third Normal Form (3NF).
- **Data Management:** Table creation and sample data insertion using SQL scripts.
- **SQL Queries:** Basic, JOIN, aggregate, and nested queries.
- **Views:** Predefined views for customer account information and overdue installments.
- **Functions:** Scalar and table-valued functions implemented in PostgreSQL.
- **Stored Procedures:** Money transfer procedure with transaction management.
- **Triggers:** Automatic account balance updates in response to successful transactions.
- **Python Integration:** Database connectivity and interaction using `psycopg2`.

## Database Architecture

The database consists of 10 main entities and 2 junction tables to handle many-to-many relationships.

### Database Tables

| Table | Description |
|---|---|
| `branch` | Bank branch information |
| `customer` | Customer personal information |
| `employee` | Bank employee information |
| `account` | Customer bank accounts |
| `card` | Bank cards associated with accounts |
| `transaction_log` | Financial transaction records |
| `loan` | Customer loans and loan details |
| `installment` | Loan installment information |
| `guarantor` | Loan guarantor information |
| `cheque` | Cheques issued from bank accounts |
| `account_owners` | Junction table for joint account ownership |
| `loan_guarantors` | Junction table for loan-guarantor relationships |

### Entity Relationships

The database models several relationships, including:

- Branches and employees (One-to-Many)
- Branches and accounts (One-to-Many)
- Customers and accounts (Many-to-Many)
- Accounts and cards (One-to-Many)
- Accounts and transactions (One-to-Many)
- Customers and loans (One-to-Many)
- Loans and installments (One-to-Many)
- Loans and guarantors (Many-to-Many)
- Accounts and cheques (One-to-Many)

The complete ER diagram is available in the project files.

## Database Objects

### 1. Views

Two views are implemented to simplify data retrieval:

- **`view_customer_accounts`:** Retrieves customer information alongside account numbers, account types, balances, and branch names.
- **`view_overdue_installments`:** Retrieves information about customers with overdue and unpaid loan installments.

### 2. Functions

Two PostgreSQL functions are implemented:

- **`fn_get_total_successful_transactions`:** Accepts an account number and returns the total amount of its successful transactions.
- **`fn_get_branch_employees`:** Accepts a branch ID and returns the employees working at that branch.

### 3. Stored Procedure

- **`sp_transfer_money`:** Implements a money transfer operation between two bank accounts. It checks the source account balance, performs the transfer, and records the corresponding transactions.

Transaction management is used to maintain data consistency and prevent incomplete transfers.

### 4. Triggers

An automatic trigger is implemented to update account balances when successful transactions are inserted.

This helps maintain consistency between transaction records and account balances without requiring manual balance updates.

## SQL Query Examples

The project includes different categories of SQL queries:

- Basic SELECT queries
- Filtering and conditional queries
- JOIN operations across related tables
- Aggregate functions such as `COUNT`, `AVG`, and `MAX`
- GROUP BY and HAVING clauses
- Nested queries and subqueries

Some example use cases include:

- Retrieving customers with multiple accounts.
- Counting accounts associated with each branch.
- Calculating the average account balance per branch.
- Finding customers who have not received any loans.
- Identifying the branch with the highest number of accounts.
- Retrieving transaction and loan information for customers.

## Python Integration

The database is connected to Python using **`psycopg2`**, the PostgreSQL adapter for Python.

This integration demonstrates how an external application can establish a database connection and execute SQL operations programmatically.

## Project Structure

```text
bank-database-management-system/
│
├── README.md
│
├── er-diagram.png
│
├── create.sql
├── insert.sql
├── views.sql
├── functions.sql
├── trigger_and_procedure.sql
├── queries.sql
│
└── connect_to_python.py
```

## Technologies Used

| Technology | Purpose |
|---|---|
| PostgreSQL | Relational database management system |
| SQL | Database definition and querying |
| PL/pgSQL | Database functions and procedural logic |
| Python | Database connectivity |
| psycopg2 | PostgreSQL adapter for Python |
| pgAdmin 4 | Database administration and SQL execution |

## Getting Started

### Prerequisites

Make sure you have the following installed:

- PostgreSQL
- pgAdmin 4
- Python 3.x

### 1. Clone the Repository

```bash
git clone https://github.com/VahhabBM/bank-database-management-system.git

cd bank-database-management-system
```

### 2. Create the Database

Create a new PostgreSQL database named:

```sql
CREATE DATABASE "BankSystem";
```

### 3. Execute SQL Scripts

Run the SQL scripts in the following order using pgAdmin 4 Query Tool:

1. `create.sql` – Creates the database tables and constraints.
2. `insert.sql` – Inserts sample records into the tables.
3. `views.sql` – Creates the database views.
4. `functions.sql` – Defines the database functions.
5. `trigger_and_procedure.sql` – Creates the trigger and stored procedure.
6. `queries.sql` – Executes the required SQL queries.

### 4. Configure Python Connectivity

Install the required Python package:

```bash
pip install psycopg2-binary
```

Update the database connection parameters in `connect_to_python.py` according to your PostgreSQL configuration.

Run the Python script:

```bash
python connect_to_python.py
```

## Implementation Notes

- The project was initially designed with SQL Server concepts in mind but implemented using PostgreSQL.
- PostgreSQL-specific syntax and features were adopted where necessary, including `GENERATED ALWAYS AS IDENTITY`, `CURRENT_DATE`, `CURRENT_TIMESTAMP`, and `OVERRIDING SYSTEM VALUE`.
- The table name `transaction` was replaced with `transaction_log` to avoid reserved keyword conflicts.
- Sample data is provided through SQL insertion scripts to demonstrate database functionality.

## Academic Context

**Course:** Database Systems (SQL)

**University:** K. N. Toosi University of Technology

**Project Type:** Academic Database Design and Implementation

---

*This project demonstrates the practical application of relational database design, SQL programming, database constraints, procedural SQL, and application-level database connectivity.*
