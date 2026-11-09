-- ======================================================================
-- 04_priority_segments.sql
-- Purpose: find customer segments that combine two characteristics, and
--          apply the priority rule agreed in Phase 4.
-- Run after: 01_database_setup.sql
--
-- PRIORITY RULE (all three must be true)
--   1. At least 100 customers.
--   2. Churn rate at least 2 times the overall churn rate.
--   3. At least 10% of all churned customers.
--
-- Segments overlap, because one customer belongs to many segments.
-- Their shares of churn must never be added together.
-- ======================================================================

USE bank_churn_analysis;


-- ----------------------------------------------------------------------
-- Part A: the three requested combinations, shown in full
-- ----------------------------------------------------------------------
-- The WITH block is a Common Table Expression (CTE): a named, temporary
-- result used by the main query. Here, it holds the overall figures once
-- so that the rule does not have to recalculate them.
--
-- CROSS JOIN attaches the single row of overall figures to every segment.

-- A1. Age group and active membership
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    age_group,
    CASE WHEN active_member = 1 THEN 'Active' ELSE 'Inactive' END AS membership_status,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / overall.all_churned, 2) AS share_of_churn_pct,
    CASE
        WHEN COUNT(*) >= 100
         AND SUM(churn) * 100.0 / COUNT(*) >= overall.overall_rate * 2
         AND SUM(churn) * 100.0 / overall.all_churned >= 10
        THEN 'Priority' ELSE ''
    END AS priority_flag
FROM bank_customers
CROSS JOIN overall
GROUP BY age_group, active_member, overall.all_churned, overall.overall_rate
ORDER BY MIN(age), active_member;


-- A2. Country and balance band
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    country,
    balance_band,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / overall.all_churned, 2) AS share_of_churn_pct,
    CASE
        WHEN COUNT(*) >= 100
         AND SUM(churn) * 100.0 / COUNT(*) >= overall.overall_rate * 2
         AND SUM(churn) * 100.0 / overall.all_churned >= 10
        THEN 'Priority' ELSE ''
    END AS priority_flag
FROM bank_customers
CROSS JOIN overall
GROUP BY country, balance_band, overall.all_churned, overall.overall_rate
ORDER BY country, MIN(balance);


-- A3. Active membership and number of products
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    CASE WHEN active_member = 1 THEN 'Active' ELSE 'Inactive' END AS membership_status,
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(churn) * 100.0 / overall.all_churned, 2) AS share_of_churn_pct,
    CASE WHEN COUNT(*) < 100 THEN 'Small group'
         WHEN SUM(churn) * 100.0 / COUNT(*) >= overall.overall_rate * 2
          AND SUM(churn) * 100.0 / overall.all_churned >= 10
         THEN 'Priority' ELSE ''
    END AS priority_flag
FROM bank_customers
CROSS JOIN overall
GROUP BY active_member, products_number, overall.all_churned, overall.overall_rate
ORDER BY active_member, products_number;


-- ----------------------------------------------------------------------
-- Part B: every pair of characteristics, as in Phase 4
-- ----------------------------------------------------------------------
-- Phase 4 checked every pair of six characteristics, which makes 15 pairs.
-- A VIEW saves this long query under a name, so the short queries below can
-- use it like a table. It stores no extra data and changes no customer records.
--
-- UNION ALL stacks the results of each pair into one list.
-- IF(condition, a, b) is a shorter way to write a simple CASE WHEN.

CREATE OR REPLACE VIEW pair_segments AS
SELECT CONCAT(country, ' + ', gender) AS segment, COUNT(*) AS customers, SUM(churn) AS churned
FROM bank_customers GROUP BY country, gender
UNION ALL
SELECT CONCAT(country, ' + Age ', age_group), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY country, age_group
UNION ALL
SELECT CONCAT(country, ' + ', IF(active_member = 1, 'Active', 'Inactive')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY country, active_member
UNION ALL
SELECT CONCAT(country, ' + ', products_number, IF(products_number = 1, ' product', ' products')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY country, products_number
UNION ALL
SELECT CONCAT(country, ' + Balance ', balance_band), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY country, balance_band
UNION ALL
SELECT CONCAT(gender, ' + Age ', age_group), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY gender, age_group
UNION ALL
SELECT CONCAT(gender, ' + ', IF(active_member = 1, 'Active', 'Inactive')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY gender, active_member
UNION ALL
SELECT CONCAT(gender, ' + ', products_number, IF(products_number = 1, ' product', ' products')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY gender, products_number
UNION ALL
SELECT CONCAT(gender, ' + Balance ', balance_band), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY gender, balance_band
UNION ALL
SELECT CONCAT('Age ', age_group, ' + ', IF(active_member = 1, 'Active', 'Inactive')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY age_group, active_member
UNION ALL
SELECT CONCAT('Age ', age_group, ' + ', products_number, IF(products_number = 1, ' product', ' products')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY age_group, products_number
UNION ALL
SELECT CONCAT('Age ', age_group, ' + Balance ', balance_band), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY age_group, balance_band
UNION ALL
SELECT CONCAT(IF(active_member = 1, 'Active', 'Inactive'), ' + ', products_number, IF(products_number = 1, ' product', ' products')), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY active_member, products_number
UNION ALL
SELECT CONCAT(IF(active_member = 1, 'Active', 'Inactive'), ' + Balance ', balance_band), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY active_member, balance_band
UNION ALL
SELECT CONCAT(products_number, IF(products_number = 1, ' product', ' products'), ' + Balance ', balance_band), COUNT(*), SUM(churn)
FROM bank_customers GROUP BY products_number, balance_band;


-- B1. How many combinations exist, and how many are small?
SELECT
    COUNT(*) AS segments_checked,
    SUM(CASE WHEN customers < 100 THEN 1 ELSE 0 END) AS segments_under_100_customers
FROM pair_segments;


-- B2. Priority segments: all three rules are met
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    segment,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2) AS churn_rate_pct,
    ROUND(churned * 100.0 / all_churned, 2) AS share_of_churn_pct
FROM pair_segments
CROSS JOIN overall
WHERE customers >= 100
  AND churned * 100.0 / customers >= overall_rate * 2
  AND churned * 100.0 / all_churned >= 10
ORDER BY churn_rate_pct DESC;


-- B3. Segments that miss the rule but contribute significantly.
-- "Significant" here means a churn rate above the overall rate and at least
-- 25% of all churned customers. This is a project choice for this list, and
-- it is not part of the priority rule.
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    segment,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2) AS churn_rate_pct,
    ROUND(churned * 100.0 / all_churned, 2) AS share_of_churn_pct
FROM pair_segments
CROSS JOIN overall
WHERE customers >= 100
  AND churned * 100.0 / customers < overall_rate * 2
  AND churned * 100.0 / customers > overall_rate
  AND churned * 100.0 / all_churned >= 25
ORDER BY share_of_churn_pct DESC;


-- B4. Very high rate, but under 10% of all churn.
-- These groups stand out but involve relatively few customers.
WITH overall AS (
    SELECT SUM(churn) AS all_churned,
           SUM(churn) * 100.0 / COUNT(*) AS overall_rate
    FROM bank_customers
)
SELECT
    segment,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2) AS churn_rate_pct,
    ROUND(churned * 100.0 / all_churned, 2) AS share_of_churn_pct
FROM pair_segments
CROSS JOIN overall
WHERE customers >= 100
  AND churned * 100.0 / customers >= overall_rate * 2
  AND churned * 100.0 / all_churned < 10
ORDER BY churn_rate_pct DESC
LIMIT 10;


-- B5. Small segments (under 100 customers) with the highest churn rates.
-- These are flagged for caution and are never treated as priorities.
SELECT
    segment,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2) AS churn_rate_pct
FROM pair_segments
WHERE customers < 100
ORDER BY churn_rate_pct DESC, customers DESC
LIMIT 10;
