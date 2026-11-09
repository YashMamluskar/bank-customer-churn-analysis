-- ======================================================================
-- 02_overall_churn_analysis.sql
-- Purpose: calculate the overall churn KPIs and compare churned customers
--          with retained customers.
-- Run after: 01_database_setup.sql
--
-- How churn is counted: churn = 1 means the customer left, so SUM(churn)
-- adds up the number of churned customers.
--
-- Why "* 100.0" comes before the division: MySQL keeps only a few decimals
-- when it divides, so multiplying first keeps the percentage accurate.
-- ======================================================================

USE bank_churn_analysis;


-- ----------------------------------------------------------------------
-- A. Overall customer KPIs
-- ----------------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    COUNT(*) - SUM(churn) AS retained_customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND((COUNT(*) - SUM(churn)) * 100.0 / COUNT(*), 2) AS retention_rate_pct,
    ROUND(SUM(active_member) * 100.0 / COUNT(*), 2) AS active_member_rate_pct,
    ROUND(AVG(products_number), 2) AS avg_products_per_customer
FROM bank_customers;


-- ----------------------------------------------------------------------
-- B. Average values: churned and retained customers side by side
-- ----------------------------------------------------------------------
-- CASE WHEN turns churn (0 or 1) into a readable label.
SELECT
    CASE WHEN churn = 1 THEN 'Churned' ELSE 'Retained' END AS customer_status,
    COUNT(*) AS customers,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(tenure), 2) AS avg_tenure,
    ROUND(AVG(balance), 2) AS avg_balance,
    ROUND(AVG(estimated_salary), 2) AS avg_estimated_salary,
    ROUND(AVG(products_number), 2) AS avg_products
FROM bank_customers
GROUP BY churn
ORDER BY churn DESC;


-- ----------------------------------------------------------------------
-- C. Average balance for customers with a balance above zero
-- ----------------------------------------------------------------------
-- Zero balances pull the overall average down, so we also compare without them.
SELECT
    CASE WHEN churn = 1 THEN 'Churned' ELSE 'Retained' END AS customer_status,
    COUNT(*) AS customers_with_balance,
    ROUND(AVG(balance), 2) AS avg_balance_above_zero
FROM bank_customers
WHERE balance > 0
GROUP BY churn
ORDER BY churn DESC;


-- ----------------------------------------------------------------------
-- D. Percentage of each status with a zero balance
-- ----------------------------------------------------------------------
SELECT
    CASE WHEN churn = 1 THEN 'Churned' ELSE 'Retained' END AS customer_status,
    SUM(CASE WHEN balance = 0 THEN 1 ELSE 0 END) AS zero_balance_customers,
    ROUND(SUM(CASE WHEN balance = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS zero_balance_pct
FROM bank_customers
GROUP BY churn
ORDER BY churn DESC;


-- ----------------------------------------------------------------------
-- E. Total balance held by churned customers
-- ----------------------------------------------------------------------
-- This is an account amount. It is NOT lost revenue or profit.
-- The currency is not documented, so no currency symbol is used.
SELECT
    SUM(CASE WHEN churn = 1 THEN balance ELSE 0 END) AS balance_held_by_churned,
    SUM(balance) AS balance_held_by_all,
    ROUND(SUM(CASE WHEN churn = 1 THEN balance ELSE 0 END) * 100.0 / SUM(balance), 2) AS churned_share_of_balance_pct
FROM bank_customers;
