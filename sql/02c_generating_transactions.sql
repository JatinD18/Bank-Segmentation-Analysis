(SELECT account_id FROM accounts ORDER BY RAND() LIMIT 1);

USE bank_segmentation;

CALL generate_transactions(100000, 10000);

SELECT COUNT(*) AS total_transactions FROM transactions;

USE bank_segmentation;

SET SESSION cte_max_recursion_depth = 20000;
SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE transactions;
SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) AS total_transactions FROM transactions;

SELECT account_id FROM accounts ORDER BY RAND() LIMIT 1;

DROP TEMPORARY TABLE IF EXISTS tmp_accounts;

CREATE TEMPORARY TABLE tmp_accounts (
    rn INT NOT NULL PRIMARY KEY,
    account_id INT NOT NULL
);

INSERT INTO tmp_accounts
SELECT 
    ROW_NUMBER() OVER (ORDER BY account_id) AS rn,
    account_id
FROM accounts;

SELECT COUNT(*) AS mapped_accounts FROM tmp_accounts;

SELECT * FROM tmp_accounts LIMIT 10;


DROP PROCEDURE IF EXISTS generate_transactions;

DELIMITER $$

CREATE PROCEDURE generate_transactions(
    IN p_total_rows INT,
    IN p_batch_size INT
)
BEGIN
    DECLARE v_inserted INT DEFAULT 0;
    DECLARE v_batch_rows INT DEFAULT 0;

    SELECT COUNT(*) INTO @max_rn
    FROM tmp_accounts;

    IF @max_rn = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'tmp_accounts is empty. Please run the account mapping step first.';
    END IF;

    WHILE v_inserted < p_total_rows DO

        SET @batch_limit = LEAST(p_batch_size, p_total_rows - v_inserted);

        INSERT INTO transactions (
            account_id,
            transaction_date,
            amount,
            transaction_type,
            service
        )
        WITH RECURSIVE seq AS (
            SELECT 1 AS n
            UNION ALL
            SELECT n + 1
            FROM seq
            WHERE n < @batch_limit
        )
        SELECT
            ta.account_id,

            DATE_SUB(
                CURDATE(),
                INTERVAL FLOOR(RAND() * 1095) DAY
            ) AS transaction_date,

            ROUND(50 + RAND() * 50000, 2) AS amount,

            CASE 
                WHEN RAND() < 0.5 THEN 'credit'
                ELSE 'debit'
            END AS transaction_type,

            CASE FLOOR(RAND() * 8)
                WHEN 0 THEN 'Salary Credit'
                WHEN 1 THEN 'UPI Transfer'
                WHEN 2 THEN 'Utility Bill Payment'
                WHEN 3 THEN 'Airtime Recharge'
                WHEN 4 THEN 'Online Shopping'
                WHEN 5 THEN 'ATM Withdrawal'
                WHEN 6 THEN 'Loan EMI'
                ELSE 'Interest Credit'
            END AS service

        FROM seq
        JOIN tmp_accounts ta
            ON ta.rn = FLOOR(1 + RAND() * @max_rn);

        SET v_batch_rows = ROW_COUNT();

        IF v_batch_rows = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insert returned 0 rows. Check accounts and tmp_accounts tables.';
        END IF;

        SET v_inserted = v_inserted + v_batch_rows;

        COMMIT;

    END WHILE;

    SELECT v_inserted AS total_rows_inserted;

END$$

DELIMITER ;


CALL generate_transactions(100000, 10000);


SELECT COUNT(*) AS total_transactions FROM transactions;

SELECT * FROM transactions LIMIT 20;

SELECT 
    MIN(transaction_date) AS earliest_transaction,
    MAX(transaction_date) AS latest_transaction
FROM transactions;

SELECT 
    transaction_type,
    COUNT(*) AS total_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_volume
FROM transactions
GROUP BY transaction_type;

SELECT 
    service,
    COUNT(*) AS total_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_volume
FROM transactions
GROUP BY service
ORDER BY total_count DESC;

USE bank_segmentation;

SET SESSION cte_max_recursion_depth = 20000;

CALL generate_transactions(100000, 10000);

SELECT COUNT(*) AS total_transactions FROM transactions;