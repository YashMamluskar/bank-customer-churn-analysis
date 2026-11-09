# Phase 3: Data Cleaning and Preparation

| Item | Details |
|---|---|
| **Project** | Bank Customer Churn Analysis |
| **Phase** | 3 of 9 |
| **Date** | 7 November 2026 |
| **Status** | Complete and approved |
| **Input** | `Bank Customer Churn Prediction.csv` (unchanged) |
| **Output** | [`data/processed/bank_churn_cleaned.csv`](../data/processed/bank_churn_cleaned.csv) |
| **Notebook** | [`notebooks/phase_3_data_cleaning.ipynb`](../notebooks/phase_3_data_cleaning.ipynb) |

> **Scope note:** This phase prepared the data only. No churn rates were calculated, no analysis was done and no business conclusions were drawn.

---

## 1. Summary

The data was already clean, so **no customer values needed correcting**. The main work was adding five customer group columns for later analysis.

| Measure | Original | Cleaned |
|---|---|---|
| **Customers** | 10,000 | 10,000 |
| **Columns** | 12 | 17 (12 original + 5 new) |
| **Missing values** | 0 | 0 |
| **Duplicate customer IDs** | 0 | 0 |

---

## 2. Quality Checks

| Check | Result |
|---|---|
| Original file fingerprint matches Phases 1 and 2 | Yes |
| Rows and columns | 10,000 and 12 |
| Missing values | 0 |
| Duplicate rows | 0 |
| Duplicate customer IDs | 0 |
| `country` values | France, Germany, Spain |
| `gender` values | Female, Male |
| `credit_card`, `active_member`, `churn` values | Only 0 and 1 |
| Rows breaking the numerical range rules from Phase 2 | 0 |

---

## 3. Cleaning Decisions

| Item | Decision | Reason | Effect |
|---|---|---|---|
| **Whitespace** in `country` and `gender` | Removed where present | Requested as a precaution | 0 values changed |
| **Data types** | No changes | All types are already suitable | 0 columns changed |
| **Missing values** | No action | None exist | 0 values filled in |
| **Duplicates** | No action | None exist | 0 rows removed |
| **Outliers** in `age` and `credit_score` | Kept | They are realistic and within valid ranges | 0 rows removed |
| **Zero balances** | Kept, with their own band | They are a large valid group (3,617 customers) | 0 rows removed |
| **Very low salaries** (59 under 1,000, lowest 11.58) | Kept unchanged | Unusual, but nothing proves they are wrong | 0 rows removed |

**Number format note:** saving through pandas changed how some numbers are written, but not their values. For example, a balance of `0` is now written as `0.0`. This affects 3,690 `balance` cells and 119 `estimated_salary` cells, and the validation confirmed that each still has the same numeric value as the original.

---

## 4. New Columns

The original `age`, `tenure`, `credit_score`, `estimated_salary` and `balance` columns are all still present and unchanged.

### `age_group` (from `age`)

| Group | Rule | Customers | Actual range |
|---|---|---|---|
| Under 30 | Below 30 | 1,641 | 18 to 29 |
| 30 to 39 | 30 to 39 | 4,346 | 30 to 39 |
| 40 to 49 | 40 to 49 | 2,618 | 40 to 49 |
| 50 to 59 | 50 to 59 | 869 | 50 to 59 |
| 60 and above | 60 or higher | 526 | 60 to 92 |

### `tenure_group` (from `tenure`)

| Group | Rule | Customers | Actual range |
|---|---|---|---|
| 0 to 2 | 0 to 2 | 2,496 | 0 to 2 |
| 3 to 5 | 3 to 5 | 3,010 | 3 to 5 |
| 6 to 8 | 6 to 8 | 3,020 | 6 to 8 |
| 9 to 10 | 9 or higher | 1,474 | 9 to 10 |

### `credit_score_band` (from `credit_score`)

| Group | Rule | Customers | Actual range |
|---|---|---|---|
| Below 580 | Below 580 | 2,362 | 350 to 579 |
| 580 to 669 | 580 to 669 | 3,331 | 580 to 669 |
| 670 to 739 | 670 to 739 | 2,428 | 670 to 739 |
| 740 to 799 | 740 to 799 | 1,224 | 740 to 799 |
| 800 and above | 800 or higher | 655 | 800 to 850 |

### `salary_band` (from `estimated_salary`)

| Group | Rule | Customers | Actual range |
|---|---|---|---|
| Under 50,000 | Below 50,000 | 2,453 | 11.58 to 49,978.67 |
| 50,000 to under 100,000 | 50,000 or higher, below 100,000 | 2,537 | 50,016.17 to 99,984.86 |
| 100,000 to under 150,000 | 100,000 or higher, below 150,000 | 2,555 | 100,015.79 to 149,991.32 |
| 150,000 and above | 150,000 or higher | 2,455 | 150,026.79 to 199,992.48 |

### `balance_band` (from `balance`)

| Group | Rule | Customers | Actual range |
|---|---|---|---|
| Zero | Exactly 0 | 3,617 | 0 |
| Above 0 to 100,000 | Above 0, up to and including 100,000 | 1,584 | 3,768.69 to 99,986.98 |
| Above 100,000 to 150,000 | Above 100,000, up to and including 150,000 | 3,830 | 100,013.51 to 149,995.72 |
| Above 150,000 | Above 150,000 | 969 | 150,005.38 to 250,898.09 |

As approved, "Above 0 to 100,000" combines the former "Above 0 to 50,000" group (75 customers) with "Above 50,000 to 100,000" (1,509 customers).

### Changes from the Phase 1 proposal

| Change | Reason |
|---|---|
| Balance has 4 bands instead of 5 | The approved merge of the small 75-customer group |
| Labels say "30 to 39" instead of "30–39" | Spreadsheet programs can turn text such as "3-5" into a date |
| "60+" and "800+" became "60 and above" and "800 and above" | Clearer wording, in the same style as the other labels |
| Salary labels say "under 100,000" instead of "99,999" | Salaries have decimals, so a value such as 99,999.50 would not fit a band ending at 99,999 |

The customer groupings match the Phase 1 proposal, apart from the balance merge.

---

## 5. Validation

### Notebook checks: 24 of 24 passed

The notebook reloads the saved file from disk before running these checks.

| Check | Result |
|---|---|
| Customer count matches the original (10,000) | Pass |
| The file has 17 columns | Pass |
| Original columns are present, in the same order | Pass |
| Customer IDs are unique | Pass |
| Customer IDs are in the same order as the original | Pass |
| No missing values anywhere | Pass |
| Each of the 12 original columns is unchanged (12 checks) | Pass |
| Each of the 5 new columns has the expected groups and counts (5 checks) | Pass |
| Original CSV fingerprint is unchanged | Pass |

### Separate cross-check without pandas

A separate script, run outside the notebook, read both files with Python's basic `csv` tool.

| Check | Result |
|---|---|
| Cells with a different value across the 12 original columns | 0 |
| Cells with the same value written differently | 3,809 (see the number format note above) |
| Customers placed in the wrong group, after working out all 5 groups separately | 0 |
| Different customer IDs | 10,000 |
| Blank cells | 0 |
| Edge values, such as balances of exactly 100,000 and ages of exactly 30 | Fall into the documented bands |

**SHA-256 fingerprint of the original CSV:** `90f6625c31bdfcb0cde3b94c4f3004e43795e382921d0a5be67c4bd490b38818`

**SHA-256 fingerprint of the cleaned CSV:** `3cf6eb4542f2c520f7f6a0831e6f0a1a31db9807abb21a12cc4266ee8bf13005`

---

## 6. Notes for Later Phases

- **Group order:** a CSV stores groups as plain text, so tools may sort them alphabetically (for example, "100,000 to under 150,000" before "50,000 to under 100,000"). The correct order must be set again in Phases 4, 5 and 7, using the order of the tables in Section 4.
- **MySQL import (Phase 5):** salary and balance labels contain commas, so those values are wrapped in double quotes in the CSV. The import must allow for this. The file uses `\n` line endings.
- **Binary columns:** `credit_card`, `active_member` and `churn` remain 0 and 1. No yes/no label columns were added, and they can be added in Power BI if useful.

---

## 7. Remaining Concerns

These are carried forward from Phase 2, as cleaning could not resolve them:

- **Low salaries and even salary spread:** salary findings still need caution.
- **Germany has no zero-balance customers:** this will affect comparisons of `balance_band` and `country`.
- **Small group:** only 60 customers hold 4 products.
- **Unverified meanings:** 1 = yes in `credit_card` and `active_member`, `tenure` in years, and one shared currency.
- **Kaggle source:** the user has not yet confirmed the download page.
- **Licence:** Kaggle gives no clear terms, which also affects whether the cleaned file can be published in Phase 9.
