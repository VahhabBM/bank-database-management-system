-- stored procedure for transferring money between accounts

CREATE OR REPLACE PROCEDURE sp_transfer_money(
    p_source_account INT,
    p_target_account INT,
    p_amount DECIMAL(18,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- ۱. چک کردن موجودی حساب مبدا
    IF (SELECT balance FROM account WHERE account_number = p_source_account) < p_amount THEN
        RAISE EXCEPTION 'موجودی حساب مبدا کافی نیست!';
    END IF;
    
    -- ۲. چک کردن فعال بودن حساب مقصد
    IF (SELECT status FROM account WHERE account_number = p_target_account) != 'Active' THEN
        RAISE EXCEPTION 'حساب مقصد فعال نیست و امکان واریز وجود ندارد!';
    END IF;

    -- ۳. کسر مبلغ از حساب مبدا
    UPDATE account 
    SET balance = balance - p_amount 
    WHERE account_number = p_source_account;

    -- ۴. اضافه کردن مبلغ به حساب مقصد
    UPDATE account 
    SET balance = balance + p_amount 
    WHERE account_number = p_target_account;

    -- ۵. ثبت لاگ تراکنش برای حساب مبدا (برداشت)
    INSERT INTO transaction_log (type, amount, status, account_number)
    VALUES ('برداشت (کارت به کارت)', p_amount, 'Success', p_source_account);

    -- ۶. ثبت لاگ تراکنش برای حساب مقصد (واریز)
    INSERT INTO transaction_log (type, amount, status, account_number)
    VALUES ('واریز (کارت به کارت)', p_amount, 'Success', p_target_account);

    COMMIT;
END;
$$;

-- Trigger for updating account balance after a transaction is inserted

CREATE OR REPLACE FUNCTION trg_update_account_balance_func()
RETURNS TRIGGER AS $$
BEGIN
    -- اگر تراکنش موفق بود موجودی را تغییر بده
    IF NEW.status = 'Success' THEN
        IF NEW.type = 'واریز' OR NEW.type LIKE 'واریز%' THEN
            UPDATE account 
            SET balance = balance + NEW.amount 
            WHERE account_number = NEW.account_number;
        ELSIF NEW.type = 'برداشت' OR NEW.type LIKE 'برداشت%' THEN
            UPDATE account 
            SET balance = balance - NEW.amount 
            WHERE account_number = NEW.account_number;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for after insert on transaction_log 

CREATE TRIGGER trg_after_transaction_insert
AFTER INSERT ON transaction_log
FOR EACH ROW
EXECUTE FUNCTION trg_update_account_balance_func();

