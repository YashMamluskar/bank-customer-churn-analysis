# Phase 5: SQL Business Analysis (MySQL)

| Item | Details |
|---|---|
| **Project** | Bank Customer Churn Analysis |
| **Phase** | 5 of 9 |
| **Date** | 7 November 2026 |
| **Status** | Complete and approved |
| **Data used** | [`data/processed/bank_churn_cleaned.csv`](../data/processed/bank_churn_cleaned.csv) (unchanged) |
| **Database and table** | `bank_churn_analysis`, `bank_customers` |
| **Full query output** | [`outputs/phase_5_sql_results.txt`](../outputs/phase_5_sql_results.txt) |

> **How to read this report:** these results show patterns, not causes. Balance is an account amount, not revenue or profit. Retention recommendations belong to Phase 8.

---

## 1. Execution Status

**All five scripts have been executed and validated on an isolated MySQL test server.**

| Environment | Status | Details |
|---|---|---|
| **Temporary test server** | **Executed and validated** | A separate MySQL 8.0.40 instance with its own empty data folder, on a separate port |
| **Main local server (`MySQL80`)** | **Run with the steps below** | Same MySQL version and `sql_mode` as the test server |

The test server used the same MySQL version and the same `sql_mode` setting as the main server. The only difference in the scripts was the CSV path in `LOAD DATA`, which pointed at a test copy of the file. So the results are the same on any MySQL 8 server that follows the steps below.

### What was found on this computer

| Component | Status |
|---|---|
| MySQL Server 8.0.40 | Installed, with the `MySQL80` service running on port 3306 |
| MySQL Workbench 8.0.40 | Installed |
| Upload folder for imports (`secure-file-priv`) | `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads` |

---

## 2. How to Run the Scripts

1. **Copy the CSV** `data/processed/bank_churn_cleaned.csv` into `C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\`. Windows may ask for administrator permission. Leave the project copy in place.
2. **Open MySQL Workbench** and connect with your own login.
3. **Check the database name is free** by running `SHOW DATABASES LIKE 'bank_churn_analysis';`. If it already exists, check that it holds nothing you need, because script 01 replaces its `bank_customers` table.
4. **Run the scripts in order.** For each one, use File > Open SQL Script, then press the lightning bolt icon.

| Order | Script | What it does |
|---|---|---|
| 1 | [`sql/01_database_setup.sql`](../sql/01_database_setup.sql) | Creates the database and table, imports the CSV and runs the import checks |
| 2 | [`sql/02_overall_churn_analysis.sql`](../sql/02_overall_churn_analysis.sql) | Overall KPIs, churned and retained averages, and balance totals |
| 3 | [`sql/03_customer_segmentation.sql`](../sql/03_customer_segmentation.sql) | Churn across 10 customer characteristics |
| 4 | [`sql/04_priority_segments.sql`](../sql/04_priority_segments.sql) | Two-characteristic combinations and the priority rule |
| 5 | [`sql/05_python_sql_validation.sql`](../sql/05_python_sql_validation.sql) | Python and SQL comparison. Expect 24 matches and 0 differences |

5. **Check the results.** Script 01 should show 10,000 rows and 17 columns, and the last result of script 05 should show 24 matches.

Run script 05 in one go, because its temporary tables exist only for that connection.

---

## 3. Database Setup and Import

### Data types

| Columns | MySQL type | Why |
|---|---|---|
| `customer_id` | `INT`, primary key | Whole number, and MySQL rejects duplicates |
| `credit_score` | `SMALLINT` | Values fit between 350 and 850 |
| `age`, `tenure`, `products_number`, `credit_card`, `active_member`, `churn` | `TINYINT` | Small whole numbers |
| `balance`, `estimated_salary` | `DECIMAL(12,2)` | Stores money amounts exactly, without rounding errors |
| `country`, `gender` | `VARCHAR` | Short text |
| `age_group`, `tenure_group`, `credit_score_band`, `salary_band`, `balance_band` | `VARCHAR(30)` | The longest label has 24 characters |

All columns are `NOT NULL`, so a missing value would have stopped the import.

### Labels containing commas

Salary and balance labels such as `100,000 to under 150,000` contain commas. `OPTIONALLY ENCLOSED BY '"'` in the import tells MySQL that those commas belong to the label. The check below confirms that the labels arrived whole.

### Import results (test server)

| Check | Expected | Result |
|---|---|---|
| Rows | 10,000 | **10,000** |
| Columns | 17 | **17** |
| Unique customer IDs | 10,000 | **10,000** |
| Salary and balance bands | 4 of each, with complete labels | **4 of each** |
| Line-break characters or blank labels | 0 | **0** |
| Cells that differ from the CSV (all 170,000 compared) | 0 | **0** |

Script 04 also creates a view, `pair_segments`. It is a saved query that stores no extra data.

---

## 4. SQL Concepts Used

| Concept | Where | Simple explanation |
|---|---|---|
| `SELECT`, `FROM` | All scripts | Chooses the columns and the table |
| `WHERE` | 02, 04, 05 | Keeps only rows that meet a condition, such as balance above zero |
| `GROUP BY` | 02, 03, 04, 05 | Calculates results for each group |
| `ORDER BY` | All analysis scripts | Sorts the results. `ORDER BY MIN(age)` keeps text groups in their natural order |
| `COUNT`, `SUM`, `AVG` | All analysis scripts | Count, add up and average values |
| `CASE WHEN` | 02, 03, 04, 05 | Applies if-then logic, such as turning 1 and 0 into Active and Inactive |
| `ROUND` | All analysis scripts | Rounds results to 2 decimal places |
| Subquery | 03 | A small query inside another, used to find all churned customers |
| CTE (`WITH`) | 04, 05 | Gives a temporary name to a result, here the overall figures |
| `JOIN` | 04, 05 | `CROSS JOIN` attaches overall figures to each segment. `LEFT JOIN` lines up Python and SQL results |
| `UNION ALL` | 04, 05 | Stacks several results into one list |
| View | 04 | Saves a long query under a name, so later queries stay short |
| Temporary table | 05 | Holds validation data only until the connection closes |

**A detail worth explaining in an interview:** rates are written as `SUM(churn) * 100.0 / COUNT(*)`. MySQL keeps only a few extra decimals when it divides, so dividing first and then multiplying could lose accuracy.

---

## 5. Business Findings

All results below come from the test server run.

### Overall

| KPI | Result |
|---|---|
| **Total customers** | 10,000 |
| **Churned customers** | 2,037 |
| **Retained customers** | 7,963 |
| **Churn rate** | 20.37% |
| **Retention rate** | 79.63% |
| **Balance held by churned customers** | 185,588,094.63 (24.26% of all balances) |

### Churned and retained customers compared

| Average | Churned | Retained |
|---|---:|---:|
| **Age** | 44.84 | 37.41 |
| **Credit score** | 645.35 | 651.85 |
| **Tenure** | 4.93 | 5.03 |
| **Account balance** | 91,108.54 | 72,745.30 |
| **Estimated salary** | 101,465.68 | 99,738.39 |
| **Products owned** | 1.48 | 1.54 |

Above a zero balance, the averages are almost equal (120,746.97 and 119,535.86).

### Customer groups

All 35 group results across the 10 characteristics match Phase 4. The full tables are in the [Phase 4 report](Phase_4_Exploratory_Data_Analysis.md) and the [results file](../outputs/phase_5_sql_results.txt). The main results are:

| Characteristic | Highest churn rate | Largest share of churn |
|---|---|---|
| **Age group** | 50 to 59: 56.04% (869 customers) | 40 to 49: 39.57% |
| **Products** | 4 products: 100% (60 customers, **small group**) | 1 product: 69.17% |
| **Country** | Germany: 32.44% (2,509 customers) | Germany: 39.96% |
| **Active membership** | Inactive: 26.85% (4,849 customers) | Inactive: 63.92% |
| **Gender** | Female: 25.07% (4,543 customers) | Female: 55.92% |
| **Balance band** | Above 100,000 to 150,000: 25.77% (3,830 customers) | Same band: 48.45% |

### Age group and active membership

| Age group | Inactive: customers | Inactive: churn rate | Active: customers | Active: churn rate |
|---|---:|---:|---:|---:|
| Under 30 | 804 | 9.83% | 837 | 5.38% |
| 30 to 39 | 2,165 | 13.63% | 2,181 | 8.16% |
| 40 to 49 | 1,396 | 37.97% | 1,222 | 22.59% |
| 50 to 59 | 373 | **81.23%** | 496 | 37.10% |
| 60 and above | 111 | **85.59%** | 415 | 12.53% |

Inactive members have a higher churn rate in every age group. The gap is widest at 60 and above.

### Country and balance band

| Balance band | France | Germany | Spain |
|---|---:|---:|---:|
| Zero | 13.94% (2,418) | No customers | 13.59% (1,199) |
| Above 0 to 100,000 | 18.90% (688) | 19.89% (543) | 24.93% (353) |
| Above 100,000 to 150,000 | 16.12% (1,476) | **39.10% (1,652)** | 14.67% (702) |
| Above 150,000 | 24.31% (432) | 19.11% (314) | 26.46% (223) |

*Each cell shows the churn rate, with the number of customers in brackets.*

### Active membership and number of products

| Products | Inactive: customers | Inactive: churn rate | Active: customers | Active: churn rate |
|---|---:|---:|---:|---:|
| 1 | 2,521 | 36.65% | 2,563 | 18.92% |
| 2 | 2,144 | 9.89% | 2,446 | 5.56% |
| 3 | 153 | 88.24% | 113 | 75.22% |
| 4 **(small groups)** | 31 | 100.00% | 29 | 100.00% |

Inactive members with 1 product are the largest source of churn among these groups (924 churned customers, 45.36% of the total).

### Priority segments

**Rule (from Phase 4):** at least 100 customers, a churn rate at least 2 times overall (40.74% or higher), and at least 10% of all churned customers. SQL checked 162 combinations and found the same 8 segments as Python.

| Segment | Customers | Churned | Churn rate | Share of churn |
|---|---:|---:|---:|---:|
| Age 50 to 59 + Inactive | 373 | 303 | 81.23% | 14.87% |
| Age 50 to 59 + 1 product | 537 | 344 | 64.06% | 16.89% |
| Female + Age 50 to 59 | 421 | 265 | 62.95% | 13.01% |
| Age 50 to 59 + Balance above 100,000 to 150,000 | 375 | 228 | 60.80% | 11.19% |
| Male + Age 50 to 59 | 448 | 222 | 49.55% | 10.90% |
| Germany + Age 40 to 49 | 740 | 334 | 45.14% | 16.40% |
| Germany + 1 product | 1,349 | 578 | 42.85% | 28.38% |
| Germany + Inactive | 1,261 | 518 | 41.08% | 25.43% |

**Segments overlap, so their shares must not be added together.**

### Important segments that miss the rule

**Large contribution, with a rate below the rule.** This list has 13 segments that have a rate above overall and at least 25% of churn. The 25% figure is a project choice for this list only. The top 7 are:

| Segment | Customers | Churned | Churn rate | Share of churn |
|---|---:|---:|---:|---:|
| Inactive + 1 product | 2,521 | 924 | 36.65% | 45.36% |
| Female + 1 product | 2,296 | 762 | 33.19% | 37.41% |
| Female + Inactive | 2,259 | 725 | 32.09% | 35.59% |
| 1 product + Balance above 100,000 to 150,000 | 2,537 | 698 | 27.51% | 34.27% |
| Male + 1 product | 2,788 | 647 | 23.21% | 31.76% |
| Germany + Balance above 100,000 to 150,000 | 1,652 | 646 | 39.10% | 31.71% |
| Inactive + Balance above 100,000 to 150,000 | 1,872 | 627 | 33.49% | 30.78% |

Germany + Balance above 100,000 to 150,000 and Age 40 to 49 + 1 product (40.10%) fall only slightly below the 40.74% rate needed.

**High rate, but under 10% of churn.** These include 3 products + Balance above 100,000 to 150,000 (103 customers, 94.17%), Inactive + 3 products (153 customers, 88.24%) and Age 60 and above + Inactive (111 customers, 85.59%).

**Small segments.** 29 of the 162 combinations have fewer than 100 customers and are excluded from the priority list. They include 16 combinations involving 4 products, all showing 100% churn.

---

## 6. Python and SQL Validation

**Result: no differences were found, so no differences needed investigating.**

### Script 05: 24 of 24 measures match

| Measure | Python | SQL | Result |
|---|---:|---:|---|
| Total customers | 10,000 | 10,000 | Match |
| Churned customers | 2,037 | 2,037 | Match |
| Retained customers | 7,963 | 7,963 | Match |
| Overall churn rate | 20.37% | 20.37% | Match |
| Overall retention rate | 79.63% | 79.63% | Match |
| Churn rate: France | 16.15% | 16.15% | Match |
| Churn rate: Germany | 32.44% | 32.44% | Match |
| Churn rate: Spain | 16.67% | 16.67% | Match |
| Churn rate: Age Under 30 | 7.56% | 7.56% | Match |
| Churn rate: Age 30 to 39 | 10.88% | 10.88% | Match |
| Churn rate: Age 40 to 49 | 30.79% | 30.79% | Match |
| Churn rate: Age 50 to 59 | 56.04% | 56.04% | Match |
| Churn rate: Age 60 and above | 27.95% | 27.95% | Match |
| Churn rate: Inactive | 26.85% | 26.85% | Match |
| Churn rate: Active | 14.27% | 14.27% | Match |
| Churn rate: 1 product | 27.71% | 27.71% | Match |
| Churn rate: 2 products | 7.58% | 7.58% | Match |
| Churn rate: 3 products | 82.71% | 82.71% | Match |
| Churn rate: 4 products | 100.00% | 100.00% | Match |
| Balance held by churned customers | 185,588,094.63 | 185,588,094.63 | Match |
| Balance held by all customers | 764,858,892.88 | 764,858,892.88 | Match |
| Combination segments checked | 162 | 162 | Match |
| Combination segments under 100 customers | 29 | 29 | Match |
| Priority segments | 8 | 8 | Match |

### Wider comparison

A separate Python script connected to the test server and compared its results with a fresh pandas calculation from the CSV.

| Comparison | Compared | Differences |
|---|---:|---:|
| Cells in the imported table | 170,000 | 0 |
| Group results (customers, churned, retained, rate and share) | 35 groups | 0 |
| Churned and retained averages | 12 | 0 |
| Combination segments (name, customers and churned) | 162 | 0 |
| Names of the priority segments | 8 | 0 |

**Also confirmed:**
- Script 01 ran a second time without errors and still gave 10,000 rows.
- The cleaned CSV's SHA-256 fingerprint is unchanged.

---

## 7. Remaining Issues

- **Your server:** the scripts still need to be run there to create the real `bank_churn_analysis` database, as explained in Section 2.
- **Unverified meanings:** the Active and Inactive labels assume that 1 = active, which Kaggle does not confirm.
- **4-product customers:** all 60 churned, which is unusual and rests on a small group.
- **Data limits:** there are no dates or reasons for leaving, the original source is unknown, and salary findings need caution.
