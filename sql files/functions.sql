-- Function to calculate the total amount of successful transactions for a given account number

CREATE OR REPLACE FUNCTION fn_get_total_successful_transactions(p_account_number INT)
RETURNS DECIMAL(18,2) AS $$
DECLARE
    v_total DECIMAL(18,2);
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO v_total
    FROM transaction_log
    WHERE account_number = p_account_number AND status = 'Success';
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;



-- Function to retrieve employees of a specific branch

CREATE OR REPLACE FUNCTION fn_get_branch_employees(p_branch_id INT)
RETURNS TABLE (
    employee_id INT,
    full_name TEXT,
    emp_position VARCHAR(50),
    salary DECIMAL(18,2),
    hire_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name)::TEXT,
        e.position,
        e.salary,
        e.hire_date
    FROM employee e
    WHERE e.branch_id = p_branch_id;
END;
$$ LANGUAGE plpgsql;