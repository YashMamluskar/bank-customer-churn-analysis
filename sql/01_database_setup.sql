-- ======================================================================
-- 01_database_setup.sql
-- Purpose: create the database and table, import the cleaned CSV,
--          and confirm that everything arrived correctly.
--
-- BEFORE RUNNING
-- 1. Copy data/processed/bank_churn_cleaned.csv into MySQL's upload folder:
--    C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/
--    MySQL only reads server files from this folder. To check the folder on
--    your own server, run: SHOW VARIABLES LIKE 'secure_file_priv';
-- 2. Check that this project's database does not already hold other work:
--    SHOW DATABASES LIKE 'bank_churn_analysis';
--
-- This script affects only the bank_churn_analysis database. It replaces the
-- bank_customers table each time it runs, so it can be run again safely.
-- ======================================================================

CREATE DATABASE IF NOT EXISTS bank_churn_analysis;
USE bank_churn_analysis;

DROP TABLE IF EXISTS bank_customers;

-- Why these data types:
-- * DECIMAL(12,2) stores money amounts exactly, without rounding errors.
-- * TINYINT is enough for the 0/1 columns.
-- * VARCHAR holds the text groups. The longest label has 24 characters.
-- * NOT NULL makes the import fail if a value is unexpectedly missing.
-- * PRIMARY KEY makes MySQL reject duplicate customer IDs.
CREATE TABLE bank_customers (
    customer_id        INT            NOT NULL,
    credit_score       SMALLINT       NOT NULL,
    country            VARCHAR(20)    NOT NULL,
    gender             VARCHAR(10)    NOT NULL,
    age                TINYINT        NOT NULL,
    tenure             TINYINT        NOT NULL,
    balance            DECIMAL(12,2)  NOT NULL,
    products_number    TINYINT        NOT NULL,
    credit_card        TINYINT        NOT NULL,
    active_member      TINYINT        NOT NULL,
    estimated_salary   DECIMAL(12,2)  NOT NULL,
    churn              TINYINT        NOT NULL,
    age_group          VARCHAR(30)    NOT NULL,
    tenure_group       VARCHAR(30)    NOT NULL,
    credit_score_band  VARCHAR(30)    NOT NULL,
    salary_band        VARCHAR(30)    NOT NULL,
    balance_band       VARCHAR(30)    NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Import the CSV.
-- OPTIONALLY ENCLOSED BY '"' is the important line. Labels such as
-- "100,000 to under 150,000" contain commas, and the quotes tell MySQL
-- that those commas are part of the value and do not start a new column.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank_churn_cleaned.csv'
INTO TABLE bank_customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ----------------------------------------------------------------------
-- Import checks
-- ----------------------------------------------------------------------

-- Check 1: expect 10,000 rows
SELECT COUNT(*) AS rows_imported
FROM bank_customers;

-- Check 2: expect 17 columns
SELECT COUNT(*) AS columns_imported
FROM information_schema.columns
WHERE table_schema = 'bank_churn_analysis'
  AND table_name = 'bank_customers';

-- Check 3: expect 10,000 different customer IDs
SELECT COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM bank_customers;

-- Check 4: labels containing commas must stay whole.
-- Expect 4 salary bands and 4 balance bands, with complete labels.
SELECT salary_band, COUNT(*) AS customers
FROM bank_customers
GROUP BY salary_band
ORDER BY MIN(estimated_salary);

SELECT balance_band, COUNT(*) AS customers
FROM bank_customers
GROUP BY balance_band
ORDER BY MIN(balance);

-- Check 5: expect 0 in every column.
-- A leftover carriage return or an empty label would be counted here.
SELECT
    SUM(balance_band LIKE '%\r%') AS labels_with_line_break,
    SUM(TRIM(country) = '') AS blank_countries,
    SUM(TRIM(gender) = '') AS blank_genders,
    SUM(TRIM(age_group) = '') AS blank_age_groups,
    SUM(TRIM(tenure_group) = '') AS blank_tenure_groups,
    SUM(TRIM(credit_score_band) = '') AS blank_credit_bands,
    SUM(TRIM(salary_band) = '') AS blank_salary_bands,
    SUM(TRIM(balance_band) = '') AS blank_balance_bands
FROM bank_customers;

-- Check 6: a quick look at the first five customers
SELECT *
FROM bank_customers
ORDER BY customer_id
LIMIT 5;
