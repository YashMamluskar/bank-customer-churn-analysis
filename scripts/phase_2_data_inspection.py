# Phase 2: Dataset Understanding
# ------------------------------
# Purpose: look at the raw CSV and record what is in it.
# This script only READS the CSV. It does not clean or change anything.
#
# How to run it (from the main project folder):
#     python scripts/phase_2_data_inspection.py
#
# How the saved output file was created:
#     python scripts/phase_2_data_inspection.py > outputs/phase_2_inspection_output.txt

import csv
import hashlib
import os

import pandas as pd

CSV_FILE = "Bank Customer Churn Prediction.csv"

# Show every column and row of our small summary tables
pd.set_option("display.max_columns", None)
pd.set_option("display.width", 120)
pd.set_option("display.float_format", "{:,.2f}".format)


def print_heading(title):
    print()
    print("=" * 70)
    print(title)
    print("=" * 70)


def get_file_fingerprint(file_path):
    # A SHA-256 fingerprint changes if even one character of the file changes.
    # Comparing it before and after our work proves the CSV stayed the same.
    with open(file_path, "rb") as file:
        return hashlib.sha256(file.read()).hexdigest()


# ----------------------------------------------------------------------
# 1. File name and location
# ----------------------------------------------------------------------
print_heading("1. FILE NAME AND LOCATION")

fingerprint_at_start = get_file_fingerprint(CSV_FILE)

print("File name:", CSV_FILE)
print("File found:", os.path.exists(CSV_FILE))
print("File size (bytes):", os.path.getsize(CSV_FILE))
print("SHA-256 fingerprint:", fingerprint_at_start)

df = pd.read_csv(CSV_FILE)

# ----------------------------------------------------------------------
# 2. Rows and columns
# ----------------------------------------------------------------------
print_heading("2. ROWS AND COLUMNS")

print("Rows:", df.shape[0])
print("Columns:", df.shape[1])
print("Column names:", list(df.columns))
print()
print("First 5 rows:")
print(df.head())

# ----------------------------------------------------------------------
# 3. Data types
# ----------------------------------------------------------------------
print_heading("3. DATA TYPES")

print(df.dtypes)

# ----------------------------------------------------------------------
# 4. Missing values
# ----------------------------------------------------------------------
print_heading("4. MISSING VALUES")

print("Empty cells per column (as read by pandas):")
print(df.isnull().sum())
print()
print("Total empty cells:", df.isnull().sum().sum())

# Pandas can miss text that only looks empty, such as a space or "N/A".
# So we also check the text columns for these values directly.
text_columns = ["country", "gender"]
placeholders = ["", "na", "n/a", "nan", "null", "none", "unknown", "?", "-"]

print()
print("Blank or placeholder text in the text columns:")
for column in text_columns:
    cleaned_text = df[column].astype(str).str.strip().str.lower()
    print(" ", column, ":", cleaned_text.isin(placeholders).sum())

# ----------------------------------------------------------------------
# 5. Duplicate records and duplicate customer IDs
# ----------------------------------------------------------------------
print_heading("5. DUPLICATES")

columns_without_id = [column for column in df.columns if column != "customer_id"]

print("Fully duplicated rows:", df.duplicated().sum())
print("Duplicated customer IDs:", df["customer_id"].duplicated().sum())
print("Same details under a different customer ID:",
      df.duplicated(subset=columns_without_id).sum())

# ----------------------------------------------------------------------
# 6. Unique values in categorical and binary columns
# ----------------------------------------------------------------------
print_heading("6. UNIQUE VALUES IN CATEGORICAL AND BINARY COLUMNS")

# These are raw counts to confirm which values exist. No rates are calculated.
for column in ["country", "gender", "credit_card", "active_member", "churn"]:
    print()
    print(df[column].value_counts().sort_index())

print()
print("Text with extra spaces at the start or end:")
for column in text_columns:
    extra_spaces = df[column] != df[column].str.strip()
    print(" ", column, ":", extra_spaces.sum())

# ----------------------------------------------------------------------
# 7. Minimum, maximum, mean and median
# ----------------------------------------------------------------------
print_heading("7. NUMERICAL SUMMARY")

numeric_columns = ["credit_score", "age", "tenure", "balance",
                   "products_number", "estimated_salary"]

summary = df[numeric_columns].agg(["min", "max", "mean", "median"]).T
print(summary)

print()
print("Number of different values in each numerical column:")
print(df[numeric_columns].nunique())

print()
print("Values in small whole-number columns:")
print(df["tenure"].value_counts().sort_index())
print()
print(df["products_number"].value_counts().sort_index())

# ----------------------------------------------------------------------
# 8. Unusual or potentially invalid values
# ----------------------------------------------------------------------
print_heading("8. UNUSUAL OR POTENTIALLY INVALID VALUES")

print("A. Rule checks (count of rows that break each rule)")
print("  credit_score outside 300-850:",
      ((df["credit_score"] < 300) | (df["credit_score"] > 850)).sum())
print("  age under 18:", (df["age"] < 18).sum())
print("  age over 100:", (df["age"] > 100).sum())
print("  negative tenure:", (df["tenure"] < 0).sum())
print("  tenure not shorter than age:", (df["tenure"] >= df["age"]).sum())
print("  negative balance:", (df["balance"] < 0).sum())
print("  zero or negative estimated_salary:", (df["estimated_salary"] <= 0).sum())
print("  products_number outside 1-4:",
      ((df["products_number"] < 1) | (df["products_number"] > 4)).sum())
for column in ["credit_card", "active_member", "churn"]:
    print(" ", column, "not 0 or 1:", (~df[column].isin([0, 1])).sum())

print()
print("B. Values worth a closer look")
print("  balance exactly 0:", (df["balance"] == 0).sum())
print("  smallest balance above 0:", df.loc[df["balance"] > 0, "balance"].min())
print("  estimated_salary under 1,000:", (df["estimated_salary"] < 1000).sum())
print("  estimated_salary under 100:", (df["estimated_salary"] < 100).sum())
print("  credit_score exactly 850:", (df["credit_score"] == 850).sum())
print("  age 80 or above:", (df["age"] >= 80).sum())
print("  tenure of 0:", (df["tenure"] == 0).sum())

print()
print("C. Statistical outliers (the 1.5 x IQR rule)")
print("   Outliers are unusually far from most values. They are not always errors.")
for column in numeric_columns:
    q1 = df[column].quantile(0.25)
    q3 = df[column].quantile(0.75)
    iqr = q3 - q1
    lower_limit = q1 - 1.5 * iqr
    upper_limit = q3 + 1.5 * iqr
    outliers = ((df[column] < lower_limit) | (df[column] > upper_limit)).sum()
    print(f"  {column}: {outliers} outside {lower_limit:,.2f} to {upper_limit:,.2f}")

print()
print("D. Customers with a zero balance, by country")
print(pd.crosstab(df["country"], df["balance"] == 0,
                  rownames=["country"], colnames=["balance is 0"]))

# ----------------------------------------------------------------------
# 9. Do the proposed Phase 1 bands work?
# ----------------------------------------------------------------------
print_heading("9. CUSTOMER COUNTS IN THE PROPOSED PHASE 1 BANDS")

# This only checks that each band has enough customers. Churn is not used here.
# right=False means the upper edge belongs to the next band (30 goes into 30-39).
age_bands = pd.cut(df["age"], bins=[0, 30, 40, 50, 60, 200], right=False,
                   labels=["Under 30", "30-39", "40-49", "50-59", "60+"])
tenure_bands = pd.cut(df["tenure"], bins=[0, 3, 6, 9, 11], right=False,
                      labels=["0-2", "3-5", "6-8", "9-10"])
credit_bands = pd.cut(df["credit_score"], bins=[0, 580, 670, 740, 800, 1000], right=False,
                      labels=["Below 580", "580-669", "670-739", "740-799", "800+"])
salary_bands = pd.cut(df["estimated_salary"], bins=[0, 50000, 100000, 150000, 1000000],
                      right=False,
                      labels=["Under 50,000", "50,000-99,999", "100,000-149,999", "150,000+"])
# For balance, zero gets its own band and each band includes its upper edge.
balance_bands = pd.cut(df["balance"], bins=[-1, 0, 50000, 100000, 150000, 1000000],
                       labels=["Zero", "Above 0 to 50,000", "Above 50,000 to 100,000",
                               "Above 100,000 to 150,000", "Above 150,000"])

for name, bands in [("Age", age_bands), ("Tenure", tenure_bands),
                    ("Credit score", credit_bands), ("Estimated salary", salary_bands),
                    ("Balance", balance_bands)]:
    print()
    print(name)
    print(bands.value_counts(sort=False))
    print("Customers not placed in a band:", bands.isnull().sum())

print()
print("Balance values between 50,000 and 50,001:",
      ((df["balance"] > 50000) & (df["balance"] < 50001)).sum())
print("Balance values between 100,000 and 100,001:",
      ((df["balance"] > 100000) & (df["balance"] < 100001)).sum())
print("Balance values between 150,000 and 150,001:",
      ((df["balance"] > 150000) & (df["balance"] < 150001)).sum())

# ----------------------------------------------------------------------
# 10. Checking the Phase 1 balance assumption
# ----------------------------------------------------------------------
print_heading("10. BALANCE ASSUMPTION CHECK")

# If balance was recorded AFTER customers left, churned customers would
# probably all show zero. This count helps test that idea.
print("Rows with churn = 1 and balance above 0:",
      ((df["churn"] == 1) & (df["balance"] > 0)).sum())

# ----------------------------------------------------------------------
# 11. Cross-check using a second method
# ----------------------------------------------------------------------
print_heading("11. CROSS-CHECK WITHOUT PANDAS")

# Here we read the file again with Python's basic csv tool, then compare.
with open(CSV_FILE, newline="", encoding="utf-8") as file:
    all_rows = list(csv.reader(file))

header = all_rows[0]
data_rows = all_rows[1:]
row_lengths = set(len(row) for row in all_rows)
blank_cells = sum(cell.strip() == "" for row in data_rows for cell in row)
different_ids = len(set(row[header.index("customer_id")] for row in data_rows))
different_rows = len(set(tuple(row) for row in data_rows))

print("Data rows:", len(data_rows), "| matches pandas:", len(data_rows) == df.shape[0])
print("Columns:", len(header), "| matches pandas:", len(header) == df.shape[1])
print("Every row has the same number of columns:", row_lengths == {len(header)})
print("Blank cells:", blank_cells, "| matches pandas:", blank_cells == df.isnull().sum().sum())
print("Different customer IDs:", different_ids,
      "| matches pandas:", different_ids == df["customer_id"].nunique())
print("Different full rows:", different_rows,
      "| matches pandas:", different_rows == len(df) - df.duplicated().sum())

for column in ["country", "gender", "credit_card", "active_member", "churn"]:
    position = header.index(column)
    counts = {}
    for row in data_rows:
        counts[row[position]] = counts.get(row[position], 0) + 1
    pandas_counts = {str(key): int(value) for key, value in df[column].value_counts().items()}
    print(column, dict(sorted(counts.items())), "| matches pandas:", counts == pandas_counts)

# ----------------------------------------------------------------------
# 12. Confirm the original CSV did not change
# ----------------------------------------------------------------------
print_heading("12. ORIGINAL FILE CHECK")

fingerprint_at_end = get_file_fingerprint(CSV_FILE)
print("SHA-256 at end:", fingerprint_at_end)
print("File unchanged during this script:", fingerprint_at_start == fingerprint_at_end)
