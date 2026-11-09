# Project Context and Handoff

**Last updated:** 7 November 2026, at the end of Phase 8

**Project folder:** `C:\TYDSDA\Data_Analyst_Projects\Project_03_Customer_Churn_Analysis_Bank`

## 1. Project and Objective

**Bank Customer Churn Analysis** is an end-to-end Data Analyst portfolio project. It analyses bank customer data to understand churn patterns, identify customer groups with higher churn and recommend ways to improve retention.

## 2. Phase Status

| Phase | Name | Status |
|---|---|---|
| 1 | Business Understanding and Problem Definition | Complete and approved |
| 2 | Dataset Collection and Data Understanding | Complete and approved |
| 3 | Data Cleaning and Preparation using Python | Complete and approved |
| 4 | Exploratory Data Analysis (EDA) | Complete and approved |
| 5 | SQL-Based Business Analysis | Complete and approved. Validated on a temporary test server; the user has not confirmed a run on their own MySQL server |
| 6 | Advanced Business Analysis and Insights | **Intentionally skipped by the user**, because the Python EDA and SQL analysis give enough findings for the dashboard. Do not restart it |
| 7 | Power BI Dashboard Development | Complete and approved. `.pbix` saved |
| 8 | Business Recommendations and Storytelling | **Complete, not yet reviewed by the user** |
| 9 | Final Validation, Documentation and GitHub Portfolio | Not started. The user said Phase 8 is the last phase for now |

## 3. Files

| Location | Purpose | Status |
|---|---|---|
| `Bank Customer Churn Prediction.csv` | Original dataset | **Never modify or delete** |
| `data/processed/bank_churn_cleaned.csv` | Cleaned dataset: **use this for all analysis** | Created in Phase 3 |
| `notebooks/phase_3_data_cleaning.ipynb` | Cleaning notebook, with saved outputs | Created in Phase 3 |
| `notebooks/phase_4_exploratory_data_analysis.ipynb` | EDA notebook, with saved outputs | Created in Phase 4 |
| `reports/eda_charts/` | 11 EDA charts (PNG) | Created in Phase 4 |
| `docs/Phase_1_Business_Understanding.md` | BRD: 10 business questions, 13 KPIs and scope | Created in Phase 1 |
| `docs/Phase_2_Dataset_Understanding.md` | Full data inspection report | Created in Phase 2 |
| `docs/Phase_3_Data_Cleaning.md` | Cleaning decisions, band rules and validation | Created in Phase 3 |
| `docs/Phase_4_Exploratory_Data_Analysis.md` | Full EDA results and answers to the 10 questions | Created in Phase 4 |
| `docs/Phase_5_SQL_Business_Analysis.md` | SQL setup steps, findings and Python comparison | Created in Phase 5 |
| `docs/Phase_7_Power_BI_Dashboard.md` | Dashboard pages, DAX, design, validation and user steps | Created in Phase 7 |
| `docs/Phase_8_Business_Recommendations.md` | 8 recommendations, business story and interview preparation | Created in Phase 8 |
| `docs/Project_Report.docx` | Word version of the project report (14 pages, with charts and dashboard screenshots) | Created after Phase 8 |
| `docs/Project_Report.md` | Simple-language report of the whole project, the 10 questions with answers, charts and recommendations | Created after Phase 8 |
| `docs/Complete_Project_Documentation.md` | Detailed account of the whole project: what was done and how | Created in Phase 8 |
| `docs/Data_Dictionary.md` | Column meanings and value ranges | Created in Phase 2, new columns added in Phase 3 |
| `docs/PROJECT_CONTEXT.md` | This handoff file | Update after every phase |
| `scripts/phase_2_data_inspection.py` | Read-only inspection script | Created in Phase 2 |
| `outputs/phase_2_inspection_output.txt` | Saved output of the inspection script | Created in Phase 2 |
| `sql/01_database_setup.sql` | Creates the database and table, imports the CSV and checks the import | Created in Phase 5 |
| `sql/02_overall_churn_analysis.sql` | Overall KPIs, averages and balance totals | Created in Phase 5 |
| `sql/03_customer_segmentation.sql` | Churn across 10 characteristics | Created in Phase 5 |
| `sql/04_priority_segments.sql` | Combinations, the `pair_segments` view and the priority rule | Created in Phase 5 |
| `sql/05_python_sql_validation.sql` | Compares 24 measures with Phase 4 | Created in Phase 5 |
| `outputs/phase_5_sql_results.txt` | Full output of all five scripts from the test server | Created in Phase 5 |
| `powerbi/Bank_Customer_Churn_Dashboard.pbix` | Power BI report file, saved by the user | Created in Phase 7 |
| `powerbi/Bank_Customer_Churn_Dashboard.pbip` | Power BI Project: open this. Its `.Report` and `.SemanticModel` folders sit beside it | Created in Phase 7 |
| `powerbi/Bank_Customer_Churn_Dashboard.Report/StaticResources/RegisteredResources/Dark_Charcoal_Emerald.json` | Dashboard theme | Created in Phase 7 |
| `reports/dashboard_screenshots/` | Screenshots of 3 pages and the Germany slicer test | Created in Phase 7 |

## 4. Key Facts and Results

**Cleaned dataset:** 10,000 customers and 17 columns. The data was already clean, so no customers were removed and no values were corrected.
- **Original 12:** `customer_id`, `credit_score`, `country`, `gender`, `age`, `tenure`, `balance`, `products_number`, `credit_card`, `active_member`, `estimated_salary`, `churn`.
- **New 5:** `age_group`, `tenure_group`, `credit_score_band`, `salary_band`, `balance_band`.

**Overall KPIs:** 2,037 churned and 7,963 retained. Churn rate 20.37%, retention rate 79.63%, active member rate 51.51%, average products per customer 1.53. Churned customers hold 185,588,094.63 in balances, 24.26% of the 764,858,892.88 total (not lost revenue or profit, and no currency is documented).

**Churn by group, in correct group order (customers, churn rate, share of total churn):**

| Column | Groups |
|---|---|
| `country` | France (5,014, 16.15%, 39.76%) · Germany (2,509, 32.44%, 39.96%) · Spain (2,477, 16.67%, 20.27%) |
| `gender` | Female (4,543, 25.07%, 55.92%) · Male (5,457, 16.46%, 44.08%) |
| `age_group` | Under 30 (1,641, 7.56%, 6.09%) · 30 to 39 (4,346, 10.88%, 23.22%) · 40 to 49 (2,618, 30.79%, 39.57%) · 50 to 59 (869, 56.04%, 23.91%) · 60 and above (526, 27.95%, 7.22%) |
| `tenure_group` | 0 to 2 (2,496, 21.15%, 25.92%) · 3 to 5 (3,010, 20.76%, 30.68%) · 6 to 8 (3,020, 18.87%, 27.98%) · 9 to 10 (1,474, 21.30%, 15.41%) |
| `active_member` | 0 (4,849, 26.85%, 63.92%) · 1 (5,151, 14.27%, 36.08%) |
| `products_number` | 1 (5,084, 27.71%, 69.17%) · 2 (4,590, 7.58%, 17.08%) · 3 (266, 82.71%, 10.80%) · 4 (60, 100%, 2.95%, **small group**) |
| `credit_card` | 0 (2,945, 20.81%, 30.09%) · 1 (7,055, 20.18%, 69.91%) |
| `credit_score_band` | Below 580 (2,362, 22.02%, 25.53%) · 580 to 669 (3,331, 20.56%, 33.63%) · 670 to 739 (2,428, 18.62%, 22.19%) · 740 to 799 (1,224, 20.59%, 12.37%) · 800 and above (655, 19.54%, 6.28%) |
| `balance_band` | Zero (3,617, 13.82%, 24.55%) · Above 0 to 100,000 (1,584, 20.58%, 16.00%) · Above 100,000 to 150,000 (3,830, 25.77%, 48.45%) · Above 150,000 (969, 23.12%, 11.00%) |
| `salary_band` | Under 50,000 (2,453, 19.93%, 24.01%) · 50,000 to under 100,000 (2,537, 19.87%, 24.74%) · 100,000 to under 150,000 (2,555, 20.23%, 25.38%) · 150,000 and above (2,455, 21.47%, 25.87%) |

**Average, churned vs retained:** age 44.84 vs 37.41; credit score 645.35 vs 651.85; tenure 4.93 vs 5.03; balance 91,108.54 vs 72,745.30; salary 101,465.68 vs 99,738.39; products 1.48 vs 1.54.

**Important findings:**
- **Germany and balance overlap:** the 100,000 to 150,000 band has a 39.10% rate in Germany (1,652 customers, 31.71% of all churn), but 16.12% in France and 14.67% in Spain. Other German customers have a 19.60% rate.
- **Balance average:** above zero, averages are almost equal (120,746.97 churned, 119,535.86 retained). The overall gap mainly reflects fewer zero balances among churned customers (24.55% vs 39.14%).
- **Little difference:** tenure, credit card, credit score and salary each stay within 3.40 points. There is no clear pattern of newer customers leaving more.
- **Priority segments (Question 10, first screening):** of 162 two-characteristic combinations, 8 meet the working rule, forming two clusters: age 50 to 59 and Germany. The highest rate is Age 50 to 59 + Inactive (373 customers, 81.23%, 14.87% of churn).
- **Largest contribution, with a lower rate:** Inactive + 1 product (2,521 customers, 36.65%, 45.36% of churn).
- **Small segments:** 29 of the 162 combinations have fewer than 100 customers, and 16 of those involve 4 products.

**SQL database details:**
- **Database and objects:** `bank_churn_analysis`, containing the `bank_customers` table (10,000 rows, 17 columns, `customer_id` primary key, `DECIMAL(12,2)` for money) and the `pair_segments` view.
- **Environment found:** MySQL Server and Workbench 8.0.40 are installed, and the `MySQL80` service runs on port 3306. Its upload folder is `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads`.
- **Where the scripts ran:** on an isolated MySQL 8.0.40 test server with the same `sql_mode` as `MySQL80`. Setup steps for running them on any MySQL 8 server are in the Phase 5 report.

**New SQL findings (Phase 5):**
- **Age and active membership:** inactive members have a higher rate in every age group. The widest gap is at 60 and above (Inactive 85.59% of 111, Active 12.53% of 415). At 50 to 59 it is 81.23% of 373 against 37.10% of 496.
- **Active membership and products:** 1 product: Inactive 36.65%, Active 18.92%. 2 products: 9.89%, 5.56%. 3 products: 88.24%, 75.22%.
- **Priority rule:** the same 8 segments as Phase 4. Germany + Balance above 100,000 to 150,000 (39.10%) and Age 40 to 49 + 1 product (40.10%) fall just below the 40.74% rate needed.
- **Large contributors that miss the rule:** 13 segments have a rate above overall and at least 25% of churn, led by Inactive + 1 product (45.36%). The 25% figure is a project choice for this list only.

**Power BI dashboard (Phase 7):**
- **Format:** a Power BI Project (`.pbip`) generated as text files. It opens in Power BI Desktop 2.148, which is installed alongside Store version 2.159. It stores no data, so it needs a refresh on first open. Source: the cleaned CSV, through the `ProjectFolder` parameter.
- **Page 1, Executive Overview:** 5 KPI cards, churned and retained donut, churn rate by country, customers by country, churn rate by age group, churn rate by active membership, and a fixed Key findings text box.
- **Page 2, Customer Churn Analysis:** 8 bar charts of churn rate by age, gender, tenure, products, credit score, salary, balance and credit card.
- **Page 3, Customer Segments & Risk:** age by country, age by membership, products by membership, balance by country, the 8-row priority table and a rule note.
- **All pages:** 4 synced slicers (Country, Gender, Age group, Active membership) and navigation buttons.
- **DAX measures:** Total Customers, Churned Customers, Retained Customers, Churn Rate, Retention Rate, Churn Contribution % (denominator uses `ALL`, so always all 2,037 churned customers), Total Customer Balance, Churned Customer Balance.
- **Model additions, report only:** 5 hidden order columns (Power Query, because DAX versions caused a circular dependency), 4 label columns (DAX) and the `Priority Segments` calculated table. Its values are calculated, but its 8-segment list is fixed from Phases 4 and 5, and slicers do not affect it.
- **Design:** Palette 3, Dark Charcoal & Emerald. `#17212B` background, `#263746` visuals, `#159D75` positive or selected, `#E76F6F` churn and warning, `#F5F7FA` main text, `#B8C4CE` secondary text, `#34495E` secondary elements. `#39C69A` is in the theme but unused.

**Recommendations (Phase 8, ideas to test, in priority order):**
1. Record why and when customers leave.
2. Pilot re-engagement for Inactive + 1 product (2,521 customers, 36.65%, 45.36% of churn, 1,597 retained).
3. Review German customers with balances above 100,000 to 150,000 (1,652 customers, 39.10%, 1,006 retained).
4. Research the needs of ages 40 to 59 (34.87% of customers, 63.48% of churn, 2,194 retained).
5. Review 3- and 4-product customers before any promotion.
6. Test a useful second product for 1-product customers (3,675 retained), because customers planning to stay may simply hold more products.
7. Research the female and male gap, without gender-based offers.
8. Track results using the dashboard with dated data.

The order is a judgement, because there is no cost data. No savings, targets or causes are claimed.

**Data values to watch (all kept, none proven wrong):**
- Germany has no zero-balance customers (France 2,418, Spain 1,199).
- 59 customers have an `estimated_salary` under 1,000, and salaries are spread unusually evenly, so treat salary findings with caution.
- 233 customers have a `credit_score` of exactly 850, which suggests a possible cap.
- `tenure` values 0 (413) and 10 (490) hold about half as many customers as the other values.

**Kaggle source:** [Bank Customer Churn Dataset](https://www.kaggle.com/datasets/gauravtopre/bank-customer-churn-dataset) by Gaurav Topre, version 1, released 30 August 2022. Its file name, 561,600-byte size and column list all match our original file. Details came from Kaggle's public API because the web page did not render for automated tools.

**Validation completed:**
- **Phase 2:** counts were re-checked with Python's `csv` tool and matched pandas.
- **Phase 3:** 24 of 24 notebook checks passed. A separate cross-check found 0 changed values and 0 customers in the wrong group. 3,809 cells differ only in how the number is written (for example `0` became `0.0`).
- **Phase 4:** 42 of 42 notebook checks passed, covering segment totals, shares, denominators and Phase 3 counts. A separate `csv`-based recalculation confirmed that the KPIs, group tables, averages and priority segments appear correctly in the report.
- **Phase 5 (test server):** script 05 matched 24 of 24 measures with Python, with 0 differences. A separate comparison found 0 differences across 170,000 imported cells, 35 group results, 12 averages, 162 combination segments and the 8 priority segment names. Script 01 also ran a second time cleanly.
- **Phase 7:** 380 of 380 checks passed, comparing DAX from the running model with pandas: all 8 measures across 37 groups and 7 filter combinations, plus the priority table against the rule applied to all 162 combinations. A saved Germany slicer selection filtered page 1 correctly (2,509 customers, 814 churned, 32.44%).
- **Phase 7, not tested:** clicking slicers and syncing across pages, clicking navigation buttons, hover tooltips, and the Store version of Power BI. Computer-use tools were not available in that session.
- **Phase 8:** every number in the Phase 8 report and the complete documentation was found in earlier reports, saved outputs or a fresh calculation from the cleaned CSV, and all internal links work.
- **Original CSV SHA-256 (unchanged):** `90f6625c31bdfcb0cde3b94c4f3004e43795e382921d0a5be67c4bd490b38818`
- **Cleaned CSV SHA-256 (unchanged):** `3cf6eb4542f2c520f7f6a0831e6f0a1a31db9807abb21a12cc4266ee8bf13005`

## 5. Decisions and Assumptions

**Decisions made:**
- The project is descriptive only, with no machine learning or predictive modelling.
- Groups with fewer than 100 customers are flagged as small, and customer counts are shown beside percentages.
- No savings or profit estimates, because there is no revenue or cost data. Balance is never described as lost revenue or profit.
- All 10,000 customers are kept, and outliers and very low salaries remain unchanged.
- **User approved:** the 75-customer balance group was merged to form "Above 0 to 100,000", and zero balances have their own band.
- Group labels use "to" rather than hyphens, so spreadsheets cannot turn them into dates. These labels replace the Phase 1 wording.
- Binary columns stay as 0 and 1 in the CSV. Readable labels exist only in memory in the Phase 4 notebook.
- **Working rule for a priority segment (set in Phase 4, can be revisited in Phase 6):** at least 100 customers, a churn rate at least 2 times overall (40.74% or higher) and at least 10% of all churned customers. Segments overlap, so their shares must not be added.
- Chart colours: orange always means churned, and blue always means retained.

**Assumption status:**

| Assumption | Status |
|---|---|
| `churn` = 1 means left, 0 means stayed | Verified by Kaggle; the period is undefined |
| Each row is one customer | Verified by the data |
| `balance` recorded before the customer left | Supported, not confirmed (1,537 of 2,037 churned customers have a balance above 0) |
| Credit score scale of about 300 to 850 | Supported, not confirmed (actual range 350 to 850) |
| `credit_card` and `active_member`: 1 = yes, 0 = no | Not verified; Phase 4 labels rely on this |
| `tenure` is in years | Not verified |
| `balance` and `estimated_salary` share one currency | Not verified |

**Awaiting the user:**
1. Review the Phase 8 report and the complete documentation.
2. Report the results of clicking slicers, navigation buttons and tooltips. The user approved Phase 7 without stating these results, so they remain unconfirmed.
3. Confirm the Kaggle page above is where the CSV was downloaded from.
4. Say whether the SQL scripts were run on the user's own MySQL server (24 matches expected).

## 6. Issues, Limitations and Pending Tasks

**Limitations:**
- No dates, so no time trends, and the churn period is undefined.
- No reasons for leaving, and patterns do not prove cause.
- No revenue, transaction, complaint or service data.
- Kaggle lists the original source as "Unknown", and most column meanings are inferred from their names.
- "Active member" is undefined, and it is unclear whether `products_number` includes a credit card.
- Every 4-product customer churned (60 of 60), which is unusual and rests on a small group.

**Pending tasks:**
- **Skipped work:** the two priority clusters and the Germany and balance overlap were not studied further, because Phase 6 was skipped.
- **Phase 9:** Kaggle gives no clear licence terms. Decide whether to link to Kaggle instead of uploading the original or cleaned CSV to GitHub.
- **Phase 9:** `docs/Phase_1_Business_Understanding.md` still shows its status as "Awaiting approval" and its roadmap as not started. Update these for the final documentation.

## 7. Next Steps: Phase 9 Final Validation and GitHub (Start Only When the User Asks)

The user paused the project after Phase 8, so do nothing further unless asked.

1. Read this file and `docs/Complete_Project_Documentation.md`.
2. Ask for the open items under "Awaiting the user", and fix any dashboard or Phase 8 issues first.
3. Decide with the user whether to publish the CSVs and `.pbix` (which contains the data), or link to Kaggle, because the licence terms are unclear.
4. Update the out-of-date status and roadmap in `docs/Phase_1_Business_Understanding.md`.
5. Write a `README.md` with the project summary, findings, screenshots and how to run the work.
6. Confirm that no local paths or private details will be published. The Power BI `ProjectFolder` parameter holds a local path.
7. Run final checks, and create the GitHub repository only with the user's approval.
8. Update this file and stop for approval.

## 8. Working Instructions

**Tools:** Python (Pandas, NumPy, Matplotlib, Seaborn), MySQL, Power BI and GitHub.

**Principles:**
- Keep the work simple and beginner-friendly, and easy to explain in a Data Analyst interview.
- Explain what each important step does and why.
- Use only the actual data, and never invent data or results.
- Do not modify or delete the original dataset.
- Keep all work in the organised project folder.
- Validate results before considering any task complete.
- Clearly separate verified information from assumptions, and do not claim causes.
- Ask the user if any decision is unclear, and do not change the dataset silently.
- Do not skip phases or start the next phase without the user's approval.

**End of every phase:** update this file without duplicating summaries or marking incomplete tasks as complete, give a short handoff summary and ask the user to start the next session by sharing `docs/PROJECT_CONTEXT.md`.
