# Data Dictionary: Bank Customer Churn Dataset

**File:** `Bank Customer Churn Prediction.csv` · **Size:** 10,000 rows and 12 columns · **Missing values:** none

**How the meanings were sourced**

- **Kaggle:** stated in the Kaggle dataset description.
- **Inferred:** our interpretation from the column name and values. Kaggle lists these columns but does not explain them.

| Column | Type | Meaning | Values in the data | Meaning source | Notes |
|---|---|---|---|---|---|
| `customer_id` | Whole number | Unique customer identifier | 10,000 different values | Inferred | Kaggle calls it an "unused variable". Use it for identifying and counting only |
| `credit_score` | Whole number | Customer's credit score | 350 to 850 | Inferred | The scale is not documented. 233 customers score exactly 850 |
| `country` | Text | Customer's country | France, Germany, Spain | Inferred | |
| `gender` | Text | Customer's gender | Female, Male | Inferred | |
| `age` | Whole number | Customer's age, assumed to be in years | 18 to 92 | Inferred | |
| `tenure` | Whole number | Length of the customer's relationship with the bank, assumed to be in years | 0 to 10 | Inferred | The unit is not documented |
| `balance` | Decimal | Customer's account balance | 0 to 250,898.09 | Inferred | Currency is not documented. 3,617 customers have 0 |
| `products_number` | Whole number | Number of bank products held | 1, 2, 3, 4 | Inferred | Unclear whether it includes a credit card. Only 60 customers hold 4 |
| `credit_card` | Whole number | Whether the customer has a credit card (assumed 1 = yes, 0 = no) | 0, 1 | Inferred | |
| `active_member` | Whole number | Whether the customer is an active member (assumed 1 = yes, 0 = no) | 0, 1 | Inferred | The definition of "active" is not documented |
| `estimated_salary` | Decimal | Customer's estimated salary | 11.58 to 199,992.48 | Inferred | Currency and pay period are not documented. Use with caution |
| `churn` | Whole number | Whether the customer left the bank (1 = left during some period, 0 = did not) | 0, 1 | Kaggle | The time period is not defined |

Kaggle's listing also marks `churn` as the "target" and the other columns (apart from `customer_id`) as "input". Those labels are for prediction modelling, which is out of scope for this project.

## Columns Added in Phase 3

**File:** `data/processed/bank_churn_cleaned.csv` · **Size:** 10,000 rows and 17 columns (the 12 columns above, plus these 5)

These columns were created by this project, and they are listed with their groups in the correct order. The exact rules are in [Phase_3_Data_Cleaning.md](Phase_3_Data_Cleaning.md).

| Column | Type | Created from | Groups, in order |
|---|---|---|---|
| `age_group` | Text | `age` | Under 30, 30 to 39, 40 to 49, 50 to 59, 60 and above |
| `tenure_group` | Text | `tenure` | 0 to 2, 3 to 5, 6 to 8, 9 to 10 |
| `credit_score_band` | Text | `credit_score` | Below 580, 580 to 669, 670 to 739, 740 to 799, 800 and above |
| `salary_band` | Text | `estimated_salary` | Under 50,000; 50,000 to under 100,000; 100,000 to under 150,000; 150,000 and above |
| `balance_band` | Text | `balance` | Zero; Above 0 to 100,000; Above 100,000 to 150,000; Above 150,000 |
