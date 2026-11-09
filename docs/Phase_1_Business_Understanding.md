# Phase 1: Business Understanding

## Business Requirements Document (BRD): Bank Customer Churn Analysis

| Item | Details |
|---|---|
| **Project** | Bank Customer Churn Analysis (Data Analyst portfolio project) |
| **Phase** | 1 of 9: Business Understanding and Problem Definition |
| **Date** | 7 November 2026 |
| **Status** | Awaiting approval |
| **Tools** | Python (Pandas, NumPy, Matplotlib, Seaborn), MySQL, Power BI, GitHub |
| **Data source** | `Bank Customer Churn Prediction.csv` (downloaded from Kaggle) |

> **Note:** This phase contains no analysis results. The dataset was opened only to see its structure, so no churn rates or customer patterns have been calculated yet.

---

## 1. Project Purpose

This project studies a bank's customer data to find out **who is leaving, which groups leave most often, and what the bank could do to keep more of them**.

The bank here is a portfolio scenario: we are using the downloaded dataset, not working with an actual bank team. The goal is to work the way a Data Analyst would, turning a raw CSV file into clear findings, a dashboard and practical recommendations.

**This is a descriptive analysis project.** We explain what the data shows using tables, charts, SQL and a dashboard. We do not build machine learning or prediction models, even though the CSV filename includes the word "Prediction".

---

## 2. What Customer Churn Means in Banking

**Customer churn** means a customer stops doing business with the bank, for example by closing their account and moving to a competitor.

**Simple example:** if a bank has 1,000 customers and 150 of them leave during a period, the churn rate is 150 ÷ 1,000 = 15%. *(These numbers only illustrate the formula and do not come from our dataset.)*

Churn matters to a bank for three main reasons:

- **Lost income:** departing customers take their deposits and product relationships with them.
- **Replacement cost:** winning a new customer means spending on marketing and onboarding, and it is generally accepted that keeping an existing customer costs less than winning a new one.
- **Lost future growth:** a customer who leaves can no longer be offered further products.

**How churn is measured in this project:** a customer counts as churned when the `churn` column equals `1` (see the assumptions in Section 9).

---

## 3. Business Problem

> **The bank needs to understand which customers are leaving and which groups carry the greatest risk. Without this view, retention effort and budget cannot be aimed at the customers who need it most.**

Treating all customers the same is an inefficient way to retain them: money gets spent on customers who were going to stay anyway, while higher-risk groups may be missed. A clear picture of churn by customer group lets the bank focus its effort.

---

## 4. Analysis Objectives

1. **Measure churn:** calculate how many customers left and the overall churn rate.
2. **Compare customer groups:** look at churn by country, gender, age, tenure, activity level, products and financial profile.
3. **Identify priority segments:** find groups that have both high churn and enough customers to matter.
4. **Estimate the balance affected:** calculate the account balance held by churned customers.
5. **Recommend actions:** turn the findings into practical retention recommendations.
6. **Communicate clearly:** present the results in an interactive Power BI dashboard and well-documented GitHub project.

---

## 5. Dataset Overview

**File inspected:** `Bank Customer Churn Prediction.csv`, located in the main project folder.

**Size:** 10,000 customer rows and 12 columns. `customer_id` has 10,000 distinct values, which suggests one row per customer.

| Column | Stored as | Values seen | Likely meaning |
|---|---|---|---|
| `customer_id` | Whole number | 10,000 distinct | Unique customer identifier |
| `credit_score` | Whole number | 460 distinct | Customer's credit score |
| `country` | Text | France, Germany, Spain | Customer's country |
| `gender` | Text | Female, Male | Customer's gender |
| `age` | Whole number | 70 distinct | Customer's age |
| `tenure` | Whole number | 0 to 10 | Length of relationship with the bank |
| `balance` | Decimal | 6,382 distinct | Account balance |
| `products_number` | Whole number | 1, 2, 3, 4 | Number of bank products held |
| `credit_card` | Whole number | 0, 1 | Whether the customer has a credit card |
| `active_member` | Whole number | 0, 1 | Whether the customer is an active member |
| `estimated_salary` | Decimal | 9,999 distinct | Customer's estimated salary |
| `churn` | Whole number | 0, 1 | Whether the customer left the bank |

The "Likely meaning" column is based on the column names, because the project folder contains no official data dictionary. Full data quality checks (missing values, duplicates, unusual values) belong to Phases 2 and 3.

---

## 6. Business Questions

| # | Business question | Columns used | Why it matters |
|---|---|---|---|
| 1 | How many customers have churned, and what is the overall churn rate? | `churn` | Sets the baseline for every other comparison |
| 2 | Which countries have the highest churn? | `country`, `churn` | Shows where regional retention effort may be needed |
| 3 | Does churn differ between female and male customers? | `gender`, `churn` | Shows whether retention approaches need review, without treating gender as a cause |
| 4 | Which age groups are most likely to leave? | `age`, `churn` | Supports age-appropriate products and communication |
| 5 | Are newer customers more likely to leave than long-standing customers? | `tenure`, `churn` | Shows whether to focus on onboarding or long-term loyalty |
| 6 | Do inactive members churn more than active members? | `active_member`, `churn` | Tests whether low engagement could be an early warning sign |
| 7 | How does churn change with the number of products held, and with credit card ownership? | `products_number`, `credit_card`, `churn` | Shows whether holding more products goes with staying or leaving |
| 8 | Do customers with higher balances leave more often, and how much balance is held by churned customers? | `balance`, `churn` | Sizes the financial side of churn |
| 9 | Does churn differ by credit score band or salary band? | `credit_score`, `estimated_salary`, `churn` | Shows whether financial profile separates leavers from stayers |
| 10 | Which combinations of characteristics form the highest-priority segments? | Several, such as `country`, `age`, `active_member`, `balance` | Tells the bank where to act first |

### Proposed customer groups

Some columns contain too many different values to compare directly, so we will group them into bands. These bands are a starting proposal, to be checked against the actual data ranges in Phase 2.

| Group | Proposed bands |
|---|---|
| **Age** | Under 30, 30–39, 40–49, 50–59, 60+ |
| **Tenure** | 0–2, 3–5, 6–8, 9–10 |
| **Balance** | Zero, 1–50,000, 50,001–100,000, 100,001–150,000, above 150,000 |
| **Credit score** | Below 580, 580–669, 670–739, 740–799, 800+ |
| **Estimated salary** | Under 50,000, 50,000–99,999, 100,000–149,999, 150,000+ |

---

## 7. Key Performance Indicators (KPIs)

### Core churn KPIs

| KPI | How it is calculated | What it tells us |
|---|---|---|
| **Total Customers** | Count of all customers | Size of the customer base analysed |
| **Churned Customers** | Count where `churn` = 1 | Number of customers lost |
| **Retained Customers** | Count where `churn` = 0 | Number of customers kept |
| **Churn Rate (%)** | Churned Customers ÷ Total Customers × 100 | Main measure of customer loss |
| **Retention Rate (%)** | Retained Customers ÷ Total Customers × 100 | Share of customers kept (100% minus Churn Rate) |

### Segment KPIs

| KPI | How it is calculated | What it tells us |
|---|---|---|
| **Segment Churn Rate (%)** | Churned in segment ÷ Customers in segment × 100 | How likely customers in a group are to leave |
| **Share of Total Churn (%)** | Churned in segment ÷ All churned customers × 100 | How much of the total loss comes from a group |
| **Churn Rate Gap (percentage points)** | Segment Churn Rate − Overall Churn Rate | How far a group is above or below the average |

### Financial and engagement KPIs

| KPI | How it is calculated | What it tells us |
|---|---|---|
| **Balance Held by Churned Customers** | Sum of `balance` where `churn` = 1 | Total recorded balance linked to churned customers |
| **Share of Balance Held by Churned Customers (%)** | Balance of churned customers ÷ Total balance × 100 | Financial size of churn relative to all balances |
| **Average Balance: Churned vs Retained** | Average `balance` for each group | Whether leavers tend to hold more or less |
| **Active Member Rate (%)** | Customers where `active_member` = 1 ÷ Total Customers × 100 | Overall engagement level |
| **Average Products per Customer** | Average of `products_number` | How many products customers typically hold |

**Reading rule:** a high churn rate in a very small group can be misleading. We will always show the number of customers beside each percentage, and any group with fewer than 100 customers will be flagged as a small group.

---

## 8. Expected Business Value

This analysis is designed to help the bank:

- **Target retention spending** at the groups with the highest churn and the largest number of customers.
- **Protect balances** by showing where churn affects the most money.
- **Spot warning signs** by showing which customer characteristics are linked to leaving.
- **Improve products and engagement** using evidence about activity levels and product holdings.
- **Track churn regularly** through a dashboard that managers can filter and explore themselves.

We will not estimate savings or profit, because the dataset contains no revenue, cost or campaign data.

### Scope

| In scope | Out of scope |
|---|---|
| Data understanding, cleaning and preparation | Machine learning and predictive modelling |
| Exploratory analysis and visualisation | Customer-level churn risk scores |
| SQL business analysis in MySQL | Revenue, profit and return-on-investment calculations |
| Segment analysis and insights | Trends over time |
| Power BI dashboard | Testing retention campaigns on real customers |
| Recommendations and GitHub documentation | Combining with outside data sources |

### Success criteria

The project will be considered successful when:

1. All 10 business questions are answered using the actual dataset.
2. Key figures match across Python, SQL and Power BI.
3. The original CSV file remains unchanged.
4. Every recommendation can be traced back to a finding in the data.
5. Someone new to the project can follow the documentation on GitHub.

---

## 9. Assumptions and Limitations

### Assumptions (to be confirmed)

| # | Assumption | Why it is needed |
|---|---|---|
| 1 | `churn` = 1 means the customer left, and 0 means they stayed | The folder has no data dictionary to confirm this |
| 2 | In `credit_card` and `active_member`, 1 means yes and 0 means no | Same reason |
| 3 | `tenure` is measured in years | The unit is not stated in the data |
| 4 | `balance` and `estimated_salary` use one shared currency | No currency is stated, so amounts will be reported without a currency symbol |
| 5 | `balance` shows the amount recorded for the customer before they left | The data does not say when the balance was recorded |
| 6 | Each row represents one customer | Supported by the 10,000 distinct `customer_id` values |
| 7 | Credit scores follow a common scale of about 300 to 850, used for the proposed bands | The scale is not stated, and the range will be checked in Phase 2 |

### Limitations

| Limitation | What it means for the project |
|---|---|
| **No dates** | We cannot show monthly or yearly churn trends, seasonality or when a customer left. The churn rate covers the dataset as a whole, not a specific time period. |
| **No reasons for leaving** | The data shows who left, not why. It also cannot separate customers who chose to leave from accounts closed by the bank. |
| **Patterns are not proof of cause** | If a group has higher churn, that does not prove the characteristic caused it. Recommendations should be tested before a full rollout. |
| **No revenue or profit data** | Balance is used as a rough indicator of financial importance, not as a measure of money lost by the bank. |
| **No behaviour or service data** | There are no transactions, complaints, fees, competitor offers or service records, all of which could influence churn. |
| **"Active member" is undefined** | The data does not explain how the bank decides that a customer is active. |
| **Unknown data origin** | We do not know whether the data is from a real bank, or how it was sampled, so findings may not apply to banks in general. |

---

## 10. Project Roadmap

| Phase | Name | Main output | Status |
|---|---|---|---|
| 1 | Business Understanding and Problem Definition | This BRD | Awaiting approval |
| 2 | Dataset Collection and Data Understanding | Data understanding report | Not started |
| 3 | Data Cleaning and Preparation using Python | Cleaned dataset (separate from the original) | Not started |
| 4 | Exploratory Data Analysis | Charts and initial findings | Not started |
| 5 | SQL-Based Business Analysis | MySQL queries and results | Not started |
| 6 | Advanced Business Analysis and Insights | Priority segments and insights | Not started |
| 7 | Power BI Dashboard Development | Interactive dashboard | Not started |
| 8 | Business Recommendations and Storytelling | Recommendations and business story | Not started |
| 9 | Final Validation, Documentation and GitHub Portfolio | Final checks and published project | Not started |

Each phase starts only after the previous one has been approved.

---

## 11. Phase 1 Approval

| Check | Status |
|---|---|
| Project purpose and churn definition documented | Complete |
| Business problem and objectives defined | Complete |
| 10 business questions defined | Complete |
| KPIs defined | Complete |
| Business value, scope and limitations documented | Complete |
| Original dataset left unchanged | Complete |
| **Approval to begin Phase 2** | **Pending** |
