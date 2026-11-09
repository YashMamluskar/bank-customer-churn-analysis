-- ======================================================================
-- 05_python_sql_validation.sql
-- Purpose: compare SQL results with the Phase 4 Python results.
-- Run after: 01_database_setup.sql and 04_priority_segments.sql
--
-- How it works:
-- 1. A temporary table holds the Python results, copied from Phase 4.
-- 2. The sql_results CTE calculates the same measures in SQL.
-- 3. A JOIN lines them up by measure name, and CASE WHEN marks each as
--    MATCH or DIFFERENT.
--
-- Temporary tables disappear when the connection closes, so this script
-- leaves nothing behind in the database.
-- ======================================================================

USE bank_churn_analysis;

DROP TEMPORARY TABLE IF EXISTS python_results;
DROP TEMPORARY TABLE IF EXISTS validation_results;

CREATE TEMPORARY TABLE python_results (
    measure_no    INT            NOT NULL AUTO_INCREMENT PRIMARY KEY,
    measure       VARCHAR(50)    NOT NULL,
    python_value  DECIMAL(15,2)  NOT NULL
);

INSERT INTO python_results (measure, python_value) VALUES
    ('Total customers', 10000),
    ('Churned customers', 2037),
    ('Retained customers', 7963),
    ('Overall churn rate', 20.37),
    ('Overall retention rate', 79.63),
    ('Churn rate: France', 16.15),
    ('Churn rate: Germany', 32.44),
    ('Churn rate: Spain', 16.67),
    ('Churn rate: Age Under 30', 7.56),
    ('Churn rate: Age 30 to 39', 10.88),
    ('Churn rate: Age 40 to 49', 30.79),
    ('Churn rate: Age 50 to 59', 56.04),
    ('Churn rate: Age 60 and above', 27.95),
    ('Churn rate: Inactive', 26.85),
    ('Churn rate: Active', 14.27),
    ('Churn rate: 1 product', 27.71),
    ('Churn rate: 2 products', 7.58),
    ('Churn rate: 3 products', 82.71),
    ('Churn rate: 4 products', 100.00),
    ('Balance held by churned customers', 185588094.63),
    ('Balance held by all customers', 764858892.88),
    ('Combination segments checked', 162),
    ('Combination segments under 100 customers', 29),
    ('Priority segments', 8);

-- Save the comparison in a second temporary table, so that it can be
-- both listed and summarised below.
CREATE TEMPORARY TABLE validation_results AS
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
),
sql_results AS (
    SELECT 'Total customers' AS measure, COUNT(*) AS sql_value FROM bank_customers
    UNION ALL
    SELECT 'Churned customers', SUM(churn) FROM bank_customers
    UNION ALL
    SELECT 'Retained customers', COUNT(*) - SUM(churn) FROM bank_customers
    UNION ALL
    SELECT 'Overall churn rate', ROUND(SUM(churn) * 100.0 / COUNT(*), 2) FROM bank_customers
    UNION ALL
    SELECT 'Overall retention rate', ROUND((COUNT(*) - SUM(churn)) * 100.0 / COUNT(*), 2) FROM bank_customers
    UNION ALL
    SELECT CONCAT('Churn rate: ', country), ROUND(SUM(churn) * 100.0 / COUNT(*), 2)
    FROM bank_customers GROUP BY country
    UNION ALL
    SELECT CONCAT('Churn rate: Age ', age_group), ROUND(SUM(churn) * 100.0 / COUNT(*), 2)
    FROM bank_customers GROUP BY age_group
    UNION ALL
    SELECT CASE WHEN active_member = 1 THEN 'Churn rate: Active' ELSE 'Churn rate: Inactive' END,
           ROUND(SUM(churn) * 100.0 / COUNT(*), 2)
    FROM bank_customers GROUP BY active_member
    UNION ALL
    SELECT CONCAT('Churn rate: ', products_number, IF(products_number = 1, ' product', ' products')),
           ROUND(SUM(churn) * 100.0 / COUNT(*), 2)
    FROM bank_customers GROUP BY products_number
    UNION ALL
    SELECT 'Balance held by churned customers', SUM(CASE WHEN churn = 1 THEN balance ELSE 0 END) FROM bank_customers
    UNION ALL
    SELECT 'Balance held by all customers', SUM(balance) FROM bank_customers
    UNION ALL
    SELECT 'Combination segments checked', COUNT(*) FROM pair_segments
    UNION ALL
    SELECT 'Combination segments under 100 customers', SUM(CASE WHEN customers < 100 THEN 1 ELSE 0 END) FROM pair_segments
    UNION ALL
    SELECT 'Priority segments', COUNT(*)
    FROM pair_segments
    CROSS JOIN overall
    WHERE customers >= 100
      AND churned * 100.0 / customers >= overall_rate * 2
      AND churned * 100.0 / all_churned >= 10
)
-- LEFT JOIN keeps every Python measure, even if SQL fails to produce it.
SELECT
    p.measure_no,
    p.measure,
    p.python_value,
    s.sql_value,
    s.sql_value - p.python_value AS difference,
    CASE WHEN s.sql_value = p.python_value THEN 'MATCH' ELSE 'DIFFERENT' END AS result
FROM python_results AS p
LEFT JOIN sql_results AS s
    ON p.measure = s.measure;


-- Every measure, side by side
SELECT measure, python_value, sql_value, difference, result
FROM validation_results
ORDER BY measure_no;


-- Summary: expect 24 matches and 0 differences
SELECT
    COUNT(*) AS measures_compared,
    SUM(CASE WHEN result = 'MATCH' THEN 1 ELSE 0 END) AS matches,
    SUM(CASE WHEN result = 'DIFFERENT' THEN 1 ELSE 0 END) AS differences
FROM validation_results;
