# Bank Customer Churn Analysis: Complete Project Documentation

**Last updated:** 7 November 2026

This file explains the whole project: what was done, how it was done, what was found and how the results were checked. Each phase also has its own detailed report, linked below.

---

## 1. Project at a Glance

| Item | Details |
|---|---|
| **Goal** | Understand customer churn patterns, find groups with higher churn and recommend ways to improve retention |
| **Project type** | Descriptive data analysis, with no machine learning or predictive modelling |
| **Data** | Kaggle's [Bank Customer Churn Dataset](https://www.kaggle.com/datasets/gauravtopre/bank-customer-churn-dataset): 10,000 customers and 12 columns |
| **Tools** | Python (Pandas, NumPy, Matplotlib, Seaborn), MySQL, Power BI |
| **Main result** | 2,037 customers churned (20.37%), and 7,963 were retained (79.63%) |

### Phase status

| Phase | Name | Status | Report |
|---|---|---|---|
| 1 | Business Understanding | Approved | [Report](Phase_1_Business_Understanding.md) |
| 2 | Data Understanding | Approved | [Report](Phase_2_Dataset_Understanding.md) |
| 3 | Data Cleaning and Preparation | Approved | [Report](Phase_3_Data_Cleaning.md) |
| 4 | Exploratory Data Analysis | Approved | [Report](Phase_4_Exploratory_Data_Analysis.md) |
| 5 | SQL Business Analysis | Approved | [Report](Phase_5_SQL_Business_Analysis.md) |
| 6 | Advanced Business Analysis | Intentionally skipped | None |
| 7 | Power BI Dashboard | Approved | [Report](Phase_7_Power_BI_Dashboard.md) |
| 8 | Recommendations and Storytelling | Complete, not yet reviewed | [Report](Phase_8_Business_Recommendations.md) |
| 9 | Final Validation and GitHub Portfolio | Not started, paused for now | None |

### How the work flowed

```text
Original CSV (never changed)
    |
    |  Phase 2: inspect the data
    |  Phase 3: check it and add 5 group columns
    v
Cleaned CSV (10,000 customers, 17 columns)
    |
    |-- Phase 4: Python analysis and 11 charts
    |-- Phase 5: MySQL analysis, checked against Python
    |-- Phase 7: Power BI dashboard, checked against the CSV
    v
Phase 8: recommendations and business story
```

---

## 2. Project Folder

```text
Project_03_Customer_Churn_Analysis_Bank/
|-- Bank Customer Churn Prediction.csv     Original dataset (never changed)
|-- data/processed/
|   `-- bank_churn_cleaned.csv             Cleaned dataset used for all analysis
|-- docs/
|   |-- Complete_Project_Documentation.md  This file
|   |-- PROJECT_CONTEXT.md                 Short handoff file for future sessions
|   |-- Data_Dictionary.md                 Meaning of every column
|   `-- Phase_*.md                         One report per phase
|-- notebooks/
|   |-- phase_3_data_cleaning.ipynb        Cleaning, with saved results
|   `-- phase_4_exploratory_data_analysis.ipynb
|-- scripts/
|   `-- phase_2_data_inspection.py         Read-only data inspection
|-- sql/
|   |-- 01_database_setup.sql              Creates the table and imports the CSV
|   |-- 02_overall_churn_analysis.sql      Overall KPIs and averages
|   |-- 03_customer_segmentation.sql       Churn across 10 characteristics
|   |-- 04_priority_segments.sql           Combinations and the priority rule
|   `-- 05_python_sql_validation.sql       Compares SQL with Python
|-- outputs/
|   |-- phase_2_inspection_output.txt      Saved inspection output
|   `-- phase_5_sql_results.txt            Saved SQL output
|-- powerbi/
|   |-- Bank_Customer_Churn_Dashboard.pbix The dashboard file
|   `-- Bank_Customer_Churn_Dashboard.pbip Text-based version of the same project
`-- reports/
    |-- eda_charts/                        11 Python charts
    `-- dashboard_screenshots/             3 dashboard pages and a slicer test
```

---

## 3. What Was Done in Each Phase

### Phase 1: Business Understanding

**Goal:** agree on the problem before touching the data.

**What was done:**
- Defined churn as a customer leaving the bank.
- Defined the business problem: without knowing which groups carry the most risk, retention effort cannot be well aimed.
- Wrote 10 business questions and 13 KPIs in a Business Requirements Document.
- Recorded scope, assumptions and limitations. For example, no dates means no time trends.

**How:** the CSV's structure was opened to see which questions the data could answer, but no results were calculated.

### Phase 2: Data Understanding

**Goal:** learn what the data contains, without changing it.

**How:** a read-only Python script checked file details, data types, missing values, duplicates, value lists, numerical ranges and unusual values. Counts were then re-checked using Python's basic `csv` tool. Kaggle's dataset details were read through its public API, because the web page would not load for automated tools.

**Results:**
- 10,000 rows, 12 columns, 0 missing values, 0 duplicate rows and 0 duplicate customer IDs.
- Kaggle confirms that `churn` = 1 means the client left "during some period", and it lists the original source as "Unknown".
- Germany has no zero-balance customers (France 2,418, Spain 1,199).
- Salaries look unusual: the lowest is 11.58, and they are spread very evenly.

### Phase 3: Data Cleaning and Preparation

**Goal:** create an analysis-ready copy while keeping all 10,000 customers.

**How:** a notebook repeated the quality checks, removed any extra spaces from text values (0 values changed) and added five group columns using `pd.cut()`:

```python
cleaned["age_group"] = pd.cut(
    cleaned["age"],
    bins=[0, 30, 40, 50, 60, no_upper_limit],
    labels=["Under 30", "30 to 39", "40 to 49", "50 to 59", "60 and above"],
    right=False,
)
```

`right=False` means an edge value belongs to the higher group, so age 30 goes into "30 to 39".

| New column | Groups |
|---|---|
| `age_group` | Under 30, 30 to 39, 40 to 49, 50 to 59, 60 and above |
| `tenure_group` | 0 to 2, 3 to 5, 6 to 8, 9 to 10 |
| `credit_score_band` | Below 580, 580 to 669, 670 to 739, 740 to 799, 800 and above |
| `salary_band` | Under 50,000; 50,000 to under 100,000; 100,000 to under 150,000; 150,000 and above |
| `balance_band` | Zero; Above 0 to 100,000; Above 100,000 to 150,000; Above 150,000 |

**Results:** no customers were removed, no values were corrected and no data types were changed. Outliers and very low salaries were kept because nothing proved they were wrong.

### Phase 4: Exploratory Data Analysis

**Goal:** answer the business questions using Python.

**How:** one reusable function calculated the same measures for every characteristic, so the denominators stayed consistent:

```python
def churn_table(column):
    table = df.groupby(column)["churn"].agg(total_customers="count", churned="sum")
    table = table.reindex(GROUP_ORDER[column])  # put the groups in their correct order

    table["retained"] = table["total_customers"] - table["churned"]
    table["churn_rate_pct"] = table["churned"] / table["total_customers"] * 100
    table["share_of_total_churn_pct"] = table["churned"] / churned_customers * 100
    table["share_of_customers_pct"] = table["total_customers"] / total_customers * 100
    table["gap_to_overall_pts"] = table["churn_rate_pct"] - overall_churn_rate
    table["small_group"] = table["total_customers"] < 100
    return table.round(2)
```

The notebook also compared averages for churned and retained customers, looked at country and balance together, checked 162 two-characteristic combinations and created 11 charts.

**Key idea:** churn rate and share of churn answer different questions. Ages 50 to 59 have the highest rate (56.04%), but ages 40 to 49 are the largest source of churn (39.57%).

**Priority rule introduced here:** at least 100 customers, a churn rate at least 2 times overall (40.74%), and at least 10% of all churned customers. This found 8 segments.

### Phase 5: SQL Business Analysis

**Goal:** reproduce the findings in MySQL and show SQL skills.

**How:** five scripts create the `bank_churn_analysis` database and `bank_customers` table, import the CSV and run the analysis. A typical query looks like this:

```sql
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
```

**SQL concepts used:** `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`, `AVG`, `CASE WHEN`, `ROUND`, subqueries, CTEs, `JOIN`, `UNION ALL`, a view and temporary tables.

**Where it ran:** on an isolated MySQL 8.0.40 test server with the same version and `sql_mode` as the main local server. The setup steps for running them on any MySQL 8 server are in the Phase 5 report.

**Results:** script 05 matched all 24 key measures with Python. A wider comparison also found 0 differences across 170,000 imported cells.

### Phase 6: Skipped

You chose to skip this phase because the Python and SQL analysis gave enough findings for the dashboard. So the priority groups have not been studied in greater depth.

### Phase 7: Power BI Dashboard

**Goal:** build an interactive, professional dashboard.

**How:** the report was generated as a Power BI Project (text files describing the data model, measures, pages and visuals) and then opened in Power BI Desktop. You saved the `.pbix` file from there. It was not built by dragging fields in the Power BI interface, so practise those steps yourself if you may be asked to demonstrate them.

| Page | Contents |
|---|---|
| **Executive Overview** | 5 KPI cards, churned and retained donut, churn by country, customers by country, churn by age, churn by membership and key findings |
| **Customer Churn Analysis** | 8 churn rate bar charts across customer characteristics |
| **Customer Segments & Risk** | 4 two-way charts, the priority segments table and the rule note |

**Measures:**

```dax
Total Customers = COUNTROWS(bank_customers)
Churned Customers = SUM(bank_customers[churn])
Retained Customers = [Total Customers] - [Churned Customers]
Churn Rate = DIVIDE([Churned Customers], [Total Customers])
Retention Rate = DIVIDE([Retained Customers], [Total Customers])
Churn Contribution % = DIVIDE([Churned Customers], CALCULATE([Churned Customers], ALL(bank_customers)))
Total Customer Balance = SUM(bank_customers[balance])
Churned Customer Balance = CALCULATE([Total Customer Balance], bank_customers[churn] = 1)
```

`ALL(bank_customers)` keeps the Churn Contribution denominator at all 2,037 churned customers. Without it, a selected group would be divided by itself and always show 100%.

**Design:** Palette 3, Dark Charcoal & Emerald. Coral marks churn warnings and emerald marks positive or selected items.

**Results:** 380 of 380 checks passed against a fresh calculation from the cleaned CSV.

### Phase 8: Recommendations and Storytelling

**Goal:** turn the findings into practical next steps.

**How:** each recommendation states what the data shows, why it matters, a suggested action, how to measure it and a caution. Actions are framed as ideas to test against a comparison group, because the data does not explain why customers left.

---

## 4. Main Findings

| Finding | Result | Customers |
|---|---:|---:|
| **Overall churn rate** | 20.37% | 10,000 |
| **Germany** | 32.44% | 2,509 |
| **France and Spain** | 16.15% and 16.67% | 5,014 and 2,477 |
| **Ages 50 to 59** | 56.04% | 869 |
| **Under 30** | 7.56% | 1,641 |
| **Inactive and active members** | 26.85% and 14.27% | 4,849 and 5,151 |
| **Female and male customers** | 25.07% and 16.46% | 4,543 and 5,457 |
| **1 product and 2 products** | 27.71% and 7.58% | 5,084 and 4,590 |
| **3 products and 4 products** | 82.71% and 100% | 266 and 60 (small group) |
| **Germany, balance above 100,000 to 150,000** | 39.10% | 1,652 |

**Also important:**
- **Largest contribution:** inactive customers with one product have 45.36% of all churn.
- **Balance:** churned customers hold 185,588,094.63, or 24.26% of all balances. This is not lost revenue or profit.
- **Balance averages:** above zero, they are almost equal (120,746.97 for churned customers, 119,535.86 for retained customers).
- **Little difference:** tenure, credit card, credit score and salary each stay within 3.40 points.

### Priority segments

| Segment | Customers | Churn rate | Share of churn |
|---|---:|---:|---:|
| Age 50 to 59 + Inactive | 373 | 81.23% | 14.87% |
| Age 50 to 59 + 1 product | 537 | 64.06% | 16.89% |
| Female + Age 50 to 59 | 421 | 62.95% | 13.01% |
| Age 50 to 59 + Balance above 100,000 to 150,000 | 375 | 60.80% | 11.19% |
| Male + Age 50 to 59 | 448 | 49.55% | 10.90% |
| Germany + Age 40 to 49 | 740 | 45.14% | 16.40% |
| Germany + 1 product | 1,349 | 42.85% | 28.38% |
| Germany + Inactive | 1,261 | 41.08% | 25.43% |

These groups overlap, so their shares must not be added together.

### Recommendations

1. Start recording why and when customers leave.
2. Pilot re-engagement for inactive customers with one product.
3. Review German customers with balances above 100,000 to 150,000.
4. Research the needs of customers aged 40 to 59.
5. Review customers with 3 or 4 products before any promotion.
6. Test whether a useful second product helps one-product customers.
7. Research the gap between female and male customers.
8. Track results using the dashboard with dated data.

---

## 5. How the Results Were Checked

| Phase | Check | Result |
|---|---|---|
| **2** | Counts re-checked with Python's `csv` tool | Matched |
| **3** | Notebook checks on the saved file | 24 of 24 passed |
| **3** | Cell-by-cell comparison with the original file | 0 values changed |
| **4** | Notebook checks on totals, shares and denominators | 42 of 42 passed |
| **5** | Python and SQL comparison in script 05 | 24 of 24 matched |
| **5** | Imported cells compared with the CSV | 0 of 170,000 differ |
| **7** | Power BI measures compared with pandas | 380 of 380 passed |
| **8** | Figures in the Phase 8 report and this file compared with the data and earlier reports | Passed |

**File fingerprints:** a SHA-256 fingerprint changes if a file changes in any way, so these confirm that both data files are unchanged.
- **Original CSV:** `90f6625c31bdfcb0cde3b94c4f3004e43795e382921d0a5be67c4bd490b38818`
- **Cleaned CSV:** `3cf6eb4542f2c520f7f6a0831e6f0a1a31db9807abb21a12cc4266ee8bf13005`

### Not confirmed

- **Dashboard clicks:** clicking slicers, navigation buttons and hover tooltips. A saved Germany slicer selection did filter page 1 correctly, but you have not reported click results.
- **Your MySQL server:** whether the scripts were run there.
- **Kaggle page:** whether it is where you downloaded the CSV. Its file name, size and columns all match.

---

## 6. Key Decisions

| Decision | Reason |
|---|---|
| Keep all 10,000 customers | Nothing proved any record wrong |
| Keep outliers and very low salaries | Unusual is not the same as invalid, so they were flagged instead |
| Give zero balances their own band | They are a large group (3,617) that distorts averages |
| Merge the 75-customer balance group into "Above 0 to 100,000" | It was below the 100-customer limit. You approved this |
| Write labels as "3 to 5", not "3-5" | Spreadsheets can turn "3-5" into a date |
| Flag groups under 100 customers | Their percentages can be unreliable |
| Use a 2 times rate rule, not 1.5 times | The 1.5 times version gave 20 segments, too many to be useful |
| Use `DECIMAL(12,2)` for money in MySQL | Stores amounts exactly |
| Use the CSV as the Power BI source | It doesn't depend on a local database |
| Use one calculated table for priority segments | Combining two characteristics per row needs it |
| Skip Phase 6 | You decided that existing findings were enough |
| Estimate no savings or profit | The data has no revenue or cost information |

---

## 7. Problems Found and How They Were Solved

| Problem | Solution |
|---|---|
| The Kaggle web page would not load for automated tools | Read the details through Kaggle's public API |
| The average balance suggested that churned customers hold more | Compared balances above zero, and found the averages almost equal |
| The balance band results looked like a general pattern | Split them by country, and found the high rate concentrated in Germany |
| MySQL can lose accuracy when dividing first | Multiplied by 100.0 before dividing |
| The scripts needed testing without touching the main database server | Tested them on an isolated MySQL server and documented the setup steps |
| Power BI reported a circular dependency on the group order columns | Moved those columns to Power Query |
| Navigation buttons were blank | Corrected their settings in the report file |
| Slicers and titles were clipped, and long labels were cut off | Adjusted the layout and label space |
| Data labels overlapped on three-country charts | Removed the labels and added a value axis, with exact values in tooltips |
| A script capturing the dashboard stalled for about 38 minutes | Stopped it and restarted with time limits. The dashboard itself was not affected |

---

## 8. How to Reproduce the Project

**Requirements:** Python with Pandas, NumPy, Matplotlib, Seaborn and Jupyter, MySQL 8.0 and Power BI Desktop.

1. **Inspect the data** from the main project folder:

```bash
python scripts/phase_2_data_inspection.py
```

2. **Run the notebooks** from the `notebooks` folder, in order: `phase_3_data_cleaning.ipynb`, then `phase_4_exploratory_data_analysis.ipynb`.
3. **Run the SQL:** copy the cleaned CSV into `C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\`, then run the five scripts in `sql/` in order using MySQL Workbench. Script 05 should show 24 matches.
4. **Open the dashboard:** open `powerbi/Bank_Customer_Churn_Dashboard.pbix`. If the project has moved, select **Home > Transform data > Edit parameters**, update `ProjectFolder`, then refresh.

**Not in the project folder:** the temporary scripts used for the separate cross-checks, the test server and the script that generated the Power BI files. Their results are recorded in the reports.

---

## 9. Limitations and Open Items

### Limitations

- **No causes:** the analysis shows patterns, not reasons for leaving.
- **No time information:** there are no dates, and the churn period is undefined, so 20.37% is not monthly or annual.
- **No financial results:** there is no revenue, profit or campaign cost data.
- **Unverified meanings:** 1 = yes in `credit_card` and `active_member`, `tenure` in years and one shared currency are not confirmed by Kaggle.
- **Other undefined items:** "active member" has no definition, and it is unclear whether `products_number` includes a credit card.
- **Unknown source:** Kaggle lists the original source as "Unknown", so findings may not apply to banks in general.
- **Salary caution:** very low values and an even spread limit confidence in salary findings.
- **Fixed priority list:** the dashboard's 8 segments were chosen from Phase 4 and 5 results, so they need reviewing if the data changes.

### Open items

| Item | What is needed |
|---|---|
| **Dashboard clicks** | Click the slicers, Ctrl+click the navigation buttons, and hover for tooltips |
| **Your MySQL server** | Run the scripts, or note that they were validated on a test server |
| **Kaggle page** | Confirm where the CSV was downloaded from |
| **Licence (Phase 9)** | Kaggle gives no clear terms, so decide whether to link to Kaggle instead of uploading the CSVs. The `.pbix` also holds the data, so include it in that decision |
| **GitHub (Phase 9)** | Write a README and publish the project when you resume |
| **Phase 1 report** | It still shows "Awaiting approval" and an out-of-date roadmap, to be updated in Phase 9 |
