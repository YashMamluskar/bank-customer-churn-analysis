-- ======================================================================
-- 03_customer_segmentation.sql
-- Purpose: compare churn across 10 customer characteristics.
-- Run after: 01_database_setup.sql
--
-- Every query uses the same pattern and returns:
--   total_customers    customers in the group
--   churned            customers in the group who left
--   retained           customers in the group who stayed
--   churn_rate_pct     churned / customers IN THE GROUP
--   share_of_churn_pct churned / ALL churned customers
--
-- The small query in brackets, (SELECT SUM(churn) FROM bank_customers), is
-- a subquery. It finds all churned customers (the denominator for the share).
--
-- Groups with fewer than 100 customers should be read with caution.
-- ======================================================================

USE bank_churn_analysis;


-- 1. Country
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY country
ORDER BY churn_rate_pct DESC;


-- 2. Gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY gender
ORDER BY churn_rate_pct DESC;


-- 3. Age group
-- Groups are text, so sorting by name would put them in the wrong order.
-- MIN(age) sorts them from youngest to oldest instead.
SELECT
    age_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY age_group
ORDER BY MIN(age);


-- 4. Tenure group
SELECT
    tenure_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY tenure_group
ORDER BY MIN(tenure);


-- 5. Active membership
-- CASE WHEN gives 0 and 1 readable names. This relies on the project
-- assumption that 1 = active, which Kaggle does not confirm.
SELECT
    CASE WHEN active_member = 1 THEN 'Active' ELSE 'Inactive' END AS membership_status,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY active_member
ORDER BY churn_rate_pct DESC;


-- 6. Number of products
-- The extra CASE WHEN column flags any group with fewer than 100 customers.
SELECT
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct,
    CASE WHEN COUNT(*) < 100 THEN 'Small group' ELSE '' END AS caution
FROM bank_customers
GROUP BY products_number
ORDER BY products_number;


-- 7. Credit card ownership
-- This relies on the project assumption that 1 = has a card.
SELECT
    CASE WHEN credit_card = 1 THEN 'Has credit card' ELSE 'No credit card' END AS card_status,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY credit_card
ORDER BY credit_card;


-- 8. Credit score band
SELECT
    credit_score_band,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY credit_score_band
ORDER BY MIN(credit_score);


-- 9. Balance band
SELECT
    balance_band,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY balance_band
ORDER BY MIN(balance);


-- 10. Salary band
SELECT
    salary_band,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    COUNT(*) - SUM(churn) AS retained,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / (SELECT SUM(churn) FROM bank_customers), 2) AS share_of_churn_pct
FROM bank_customers
GROUP BY salary_band
ORDER BY MIN(estimated_salary);
