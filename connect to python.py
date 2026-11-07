import psycopg2
import pandas as pd

# Configure pandas to display clean decimal numbers (avoid scientific notation)
pd.options.display.float_format = '{:,.0f}'.format

# ==========================================
# 1. Database Connection (Task 28)
# ==========================================
DB_HOST = "localhost"
DB_NAME = "BankSystem"       # Your database name
DB_USER = "postgres"
DB_PASS = "postgres"
DB_PORT = "5432"

try:
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        port=DB_PORT
    )
    cursor = conn.cursor()
    print("✅ Successfully connected to PostgreSQL!\n")
except Exception as e:
    print(f"❌ Connection error: {e}")
    exit()

# ==========================================
# 2. Executing Queries (Tasks 29 & 30)
# ==========================================
print("--- [ Executing Phase 5 Queries ] ---")

# Query 1: Fetch first 5 customers
cursor.execute("SELECT customer_id, first_name, last_name, phone_number FROM customer LIMIT 5;")
print("\n📌 Top 5 Customers:")
for row in cursor.fetchall():
    print(row)

# Query 2: Call Scalar Function
cursor.execute("SELECT fn_get_total_successful_transactions(1000);")
total_amount = cursor.fetchone()[0] or 0
print(f"\n📌 Total successful transactions for account 1000: {total_amount:,.0f} IRR")

# Query 3: Call Table-valued Function
cursor.execute("SELECT * FROM fn_get_branch_employees(1);")
employees = cursor.fetchall()
print("\n📌 Employees of Branch 1:")
for emp in employees:
    print(emp)

# Query 4: Querying a Database View
cursor.execute("SELECT customer_name, account_number, balance FROM view_customer_accounts LIMIT 5;")
print("\n📌 Top 5 Accounts (from View):")
for view_row in cursor.fetchall():
    print(view_row)

# Query 5: Average balance per branch using Pandas
df_avg_balance = pd.read_sql("""
    SELECT b.branch_name, ROUND(AVG(a.balance), 2) AS avg_balance
    FROM branch b JOIN account a ON b.branch_id = a.branch_id
    GROUP BY b.branch_name;
""", conn)
print("\n📌 Average Balance Per Branch:")
print(df_avg_balance)

# ==========================================
# 3. INSERT Operation (Task 31)
# ==========================================
print("\n--- [ INSERT Operation ] ---")
new_id = None
try:
    insert_query = """
    INSERT INTO customer (first_name, last_name, date_of_birth, phone_number, address)
    VALUES (%s, %s, %s, %s, %s) RETURNING customer_id;
    """
    new_customer = ('Saeed', 'Rad', '1998-05-20', '09129998877', 'Tehran, Azadi St')
    cursor.execute(insert_query, new_customer)
    new_id = cursor.fetchone()[0]
    conn.commit()
    print(f"✅ New customer inserted successfully with ID: {new_id}")
except Exception as e:
    conn.rollback()
    print(f"❌ Error during INSERT: {e}")

# ==========================================
# 4. UPDATE Operation (Task 32)
# ==========================================
print("\n--- [ UPDATE Operation ] ---")
if new_id:
    try:
        update_query = "UPDATE customer SET phone_number = %s WHERE customer_id = %s;"
        cursor.execute(update_query, ('09121112233', new_id))
        conn.commit()
        print(f"✅ Phone number updated successfully for Customer ID: {new_id}")
    except Exception as e:
        conn.rollback()
        print(f"❌ Error during UPDATE: {e}")
else:
    print("⚠️ UPDATE skipped due to previous INSERT failure.")

# ==========================================
# 5. Stored Procedure Execution
# ==========================================
print("\n--- [ Executing Stored Procedure ] ---")
try:
    conn.autocommit = True  # Enable autocommit for procedures containing COMMIT statements
    cursor.execute("CALL sp_transfer_money(%s, %s, %s);", (1000, 1003, 100000))
    conn.autocommit = False # Restore default transaction management
    print("✅ Stored Procedure 'sp_transfer_money' executed successfully.")
except Exception as e:
    conn.autocommit = False
    print(f"❌ Error executing Stored Procedure: {e}")

# ==========================================
# 6. DELETE Operation (Task 33)
# ==========================================
print("\n--- [ DELETE Operation ] ---")
if new_id:
    try:
        delete_query = "DELETE FROM customer WHERE customer_id = %s;"
        cursor.execute(delete_query, (new_id,))
        conn.commit()
        print(f"✅ Test customer with ID {new_id} deleted successfully.")
    except Exception as e:
        conn.rollback()
        print(f"❌ Error during DELETE: {e}")
else:
    print("⚠️ DELETE skipped due to previous INSERT failure.")

# ==========================================
# Close Database Connection
# ==========================================
cursor.close()
conn.close()
print("\n🔒 Database connection closed successfully.")