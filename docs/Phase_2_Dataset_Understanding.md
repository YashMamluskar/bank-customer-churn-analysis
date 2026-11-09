# Phase 2: Dataset Collection and Data Understanding

| Item | Details |
|---|---|
| **Project** | Bank Customer Churn Analysis |
| **Phase** | 2 of 9 |
| **Date** | 7 November 2026 |
| **Status** | Complete and approved |
| **Inspection script** | [`scripts/phase_2_data_inspection.py`](../scripts/phase_2_data_inspection.py) |
| **Saved script output** | [`outputs/phase_2_inspection_output.txt`](../outputs/phase_2_inspection_output.txt) |
| **Data dictionary** | [`docs/Data_Dictionary.md`](Data_Dictionary.md) |

> **Scope note:** This phase only inspected the data. Nothing was cleaned, removed or changed, and no churn rates or business conclusions were calculated. Counts of customers are shown only to describe the dataset.

---

## 1. Main Findings

1. **The file is structurally clean.** It has 10,000 rows and 12 columns, with no missing values, no duplicate rows and no duplicate customer IDs.
2. **No value breaks a validity rule.** All ages, scores, balances and yes/no codes fall within the ranges we tested.
3. **The meaning of `churn` is now confirmed.** Kaggle states that 1 means the client left the bank "during some period" and 0 means they did not. The period itself is not defined.
4. **Germany has no zero-balance customers, while France and Spain have many.** This matters when comparing balance or country in later phases.
5. **`estimated_salary` needs caution.** Some values are very low (as low as 11.58), and the salaries are spread unusually evenly.
6. **Kaggle lists the data's source as "Unknown" and states no clear licence terms.** We should check this before uploading the CSV to GitHub.

---

## 2. Source Verification

The Kaggle web page did not display its content to our automated tool, so the details below come from Kaggle's public dataset information service (its API), checked on 7 November 2026.

**Dataset page:** [Bank Customer Churn Dataset on Kaggle](https://www.kaggle.com/datasets/gauravtopre/bank-customer-churn-dataset)

| Detail | What Kaggle states | Compared with our file |
|---|---|---|
| **Title** | Bank Customer Churn Dataset | Not applicable |
| **Owner** | Gaurav Topre (`gauravtopre`) | Not applicable |
| **File name** | `Bank Customer Churn Prediction.csv` | **Exact match** |
| **File size** | 561,600 bytes | **Exact match** |
| **Columns** | The same 12 names, in the same order | **Exact match** |
| **Described as** | Data for "ABC Multistate bank" | Not checkable |
| **Version** | Version 1, released 30 August 2022 | Not checkable |
| **Update frequency** | Never | Not checkable |
| **Original source** | "Unknown" | Not checkable |
| **Licence** | "Other (specified in description)", but the description contains no licence terms | Not checkable |

**Conclusion:** the file name, size and columns all match, so this is very likely the source of our file. Please confirm that this is the Kaggle page you downloaded it from.

---

## 3. File, Rows and Columns

| Check | Result |
|---|---|
| **File name** | `Bank Customer Churn Prediction.csv` |
| **Location** | Main project folder |
| **Size** | 561,600 bytes |
| **Rows** | 10,000 customers (plus 1 header row) |
| **Columns** | 12 |
| **Row structure** | Every row has the same number of columns |

---

## 4. Data Types

| Type | Columns | Simple meaning |
|---|---|---|
| **Whole number** (`int64`) | `customer_id`, `credit_score`, `age`, `tenure`, `products_number`, `credit_card`, `active_member`, `churn` | Numbers without decimals |
| **Decimal** (`float64`) | `balance`, `estimated_salary` | Numbers with decimals |
| **Text** (`object`) | `country`, `gender` | Words |

All types look appropriate. `credit_card`, `active_member` and `churn` are stored as numbers, but they act as yes/no columns. An average of these columns would therefore give a percentage rather than a typical value, so they were left out of the numerical summary.

---

## 5. Missing Values and Duplicates

### Missing values

| Check | Result |
|---|---|
| Empty cells across all columns | **0** |
| Placeholder text such as "N/A", "unknown" or "?" in `country` and `gender` | **0** |

### Duplicates

| Check | Result |
|---|---|
| Fully duplicated rows | **0** |
| Duplicated customer IDs | **0** |
| Identical details under a different customer ID | **0** |

**In simple terms:** every row is a different customer, and no information is missing. No missing-value or duplicate fixes appear to be needed in Phase 3.

---

## 6. Categorical and Binary Values

| Column | Value | Customers |
|---|---|---|
| `country` | France | 5,014 |
| | Germany | 2,509 |
| | Spain | 2,477 |
| `gender` | Female | 4,543 |
| | Male | 5,457 |
| `credit_card` | 0 | 2,945 |
| | 1 | 7,055 |
| `active_member` | 0 | 4,849 |
| | 1 | 5,151 |
| `churn` | 0 | 7,963 |
| | 1 | 2,037 |

The spellings are consistent, with no extra spaces or case variations, and the binary columns contain only 0 and 1.

---

## 7. Numerical Summary

| Column | Minimum | Maximum | Mean | Median |
|---|---|---|---|---|
| `credit_score` | 350 | 850 | 650.53 | 652 |
| `age` | 18 | 92 | 38.92 | 37 |
| `tenure` | 0 | 10 | 5.01 | 5 |
| `balance` | 0 | 250,898.09 | 76,485.89 | 97,198.54 |
| `products_number` | 1 | 4 | 1.53 | 1 |
| `estimated_salary` | 11.58 | 199,992.48 | 100,090.24 | 100,193.91 |

**Why the mean and median of `balance` differ:** the many zero balances pull the mean down, while the median is less affected. For this column, the average alone would give a misleading picture of a typical customer.

### Counts for small whole-number columns

| `tenure` | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| **Customers** | 413 | 1,035 | 1,048 | 1,009 | 989 | 1,012 | 967 | 1,028 | 1,025 | 984 | 490 |

| `products_number` | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| **Customers** | 5,084 | 4,590 | 266 | 60 |

---

## 8. Unusual or Potentially Invalid Values

### Validity rules

**Zero rows** broke any of these rules:

- `credit_score` must be between 300 and 850.
- `age` must be between 18 and 100.
- `tenure` must not be negative and must be lower than `age`.
- `balance` must not be negative.
- `estimated_salary` must be above zero.
- `products_number` must be between 1 and 4.
- `credit_card`, `active_member` and `churn` must be 0 or 1.

These rules are our own reasonableness checks, not rules published by the bank or Kaggle.

### Values to watch

These values are not proven errors, so **none should be removed or changed without a reason and your approval.**

| Finding | Count or value | Why it matters | Suggested handling |
|---|---|---|---|
| Zero balance | 3,617 customers | A large group that distorts balance averages | Keep it, and treat it as its own group |
| Zero balance in Germany | 0 of 2,509 (France has 2,418 and Spain has 1,199) | Balance and country are tied together, so comparing them separately could mislead | Keep it, and note it wherever country or balance is compared |
| `estimated_salary` under 1,000 | 59 customers, 4 of them under 100 (lowest is 11.58) | These are very low for a salary | Keep them, and investigate further in Phase 3 |
| Even salary spread | Mean and median are nearly equal, and the 4 salary bands hold 2,453 to 2,555 customers | Real salaries are usually less evenly spread, so this column may be modelled or simulated | Treat salary findings with caution |
| `credit_score` of exactly 850 | 233 customers | Suggests scores may be capped at 850 | Keep them |
| Low `credit_score` outliers | 15 customers below 383 (lowest is 350) | Unusual but within the valid range | Keep them |
| `age` outliers | 359 customers above 62, including 15 aged 80 or above (oldest is 92) | Statistically high, but realistic ages | Keep them |
| `products_number` of 4 | 60 customers | Small group, which makes its percentages unreliable | Keep it, and flag it as a small group |
| `tenure` of 0 and 10 | 413 and 490 customers, compared with about 1,000 for other values | The edges are about half the usual size, and the cause is unknown | Keep them, and note it in tenure analysis |

**How outliers were found:** the common "1.5 × IQR" rule flags values far from the middle 50% of the data. An outlier is unusual, but not automatically wrong.

---

## 9. Phase 1 Assumptions Reviewed

| # | Phase 1 assumption | Status | Evidence |
|---|---|---|---|
| 1 | `churn` = 1 means left, 0 means stayed | **Verified by Kaggle** | Kaggle states this directly, although "some period" is not defined |
| 2 | In `credit_card` and `active_member`, 1 = yes and 0 = no | **Not verified** | Only 0 and 1 appear, but Kaggle does not explain them |
| 3 | `tenure` is measured in years | **Not verified** | Values from 0 to 10 are consistent with years, but no unit is stated |
| 4 | `balance` and `estimated_salary` use one shared currency | **Not verified** | No currency is stated, and the customers span three countries |
| 5 | `balance` was recorded before the customer left | **Supported, not confirmed** | 1,537 of the 2,037 churned customers still show a balance above 0, so balances were not all cleared on leaving. The recording date is unknown |
| 6 | Each row represents one customer | **Verified by the data** | 10,000 rows and 10,000 different customer IDs |
| 7 | Credit scores follow a scale of about 300 to 850 | **Supported, not confirmed** | Actual range is 350 to 850, but no scale is documented |

The Phase 1 limitation on unknown data origin is also confirmed, because Kaggle lists the source as "Unknown".

---

## 10. Columns for the Business Questions

| Column | Business questions | Usefulness |
|---|---|---|
| `churn` | All | **Essential:** the measure used throughout the analysis |
| `customer_id` | None directly | Identifies and counts customers, with no analytical meaning (Kaggle calls it an "unused variable") |
| `country` | Q2, Q10 | **High:** three clear groups of usable size |
| `gender` | Q3 | **Medium:** a useful comparison, but not treated as a cause |
| `age` | Q4, Q10 | **High:** wide range, needs age bands |
| `tenure` | Q5 | **High:** needs tenure bands, and the unit is unconfirmed |
| `active_member` | Q6, Q10 | **High:** clear yes/no groups, but "active" is undefined |
| `products_number` | Q7 | **High:** the group holding 4 products is small |
| `credit_card` | Q7 | **Medium:** clear yes/no groups |
| `balance` | Q8, Q10 | **High:** needs a separate zero-balance group |
| `credit_score` | Q9 | **Medium:** needs score bands |
| `estimated_salary` | Q9 | **Low to medium:** needs bands, and its values need caution |

### Proposed bands from Phase 1

Every customer fits into exactly one band. Only one band falls below our 100-customer small-group limit.

| Group | Customers per band |
|---|---|
| **Age** | Under 30: 1,641 · 30–39: 4,346 · 40–49: 2,618 · 50–59: 869 · 60+: 526 |
| **Tenure** | 0–2: 2,496 · 3–5: 3,010 · 6–8: 3,020 · 9–10: 1,474 |
| **Credit score** | Below 580: 2,362 · 580–669: 3,331 · 670–739: 2,428 · 740–799: 1,224 · 800+: 655 |
| **Estimated salary** | Under 50,000: 2,453 · 50,000–99,999: 2,537 · 100,000–149,999: 2,555 · 150,000+: 2,455 |
| **Balance** | Zero: 3,617 · Above 0 to 50,000: **75** · Above 50,000 to 100,000: 1,509 · Above 100,000 to 150,000: 3,830 · Above 150,000: 969 |

**Recommendation for Phase 3:** merge the two lowest non-zero balance bands into "Above 0 to 100,000" (1,584 customers). The 75-customer band is too small to compare reliably.

---

## 11. Limitations and Data Quality Concerns

| Concern | Effect on the project |
|---|---|
| **Undefined churn period** | Churn counts cannot be converted to an annual or monthly rate |
| **No dates** | No time trends are possible |
| **Most column meanings are undocumented** | Kaggle describes only `churn` in detail, so the other meanings are inferred from column names |
| **Unknown original source** | We cannot confirm whether the data comes from a real bank, and findings may not apply to banks in general |
| **Unclear licence** | Kaggle points to the description for licence terms, but none are given there. Until this is clarified, linking to Kaggle from GitHub may be safer than uploading the CSV |
| **`estimated_salary` reliability** | Very low values and the even spread limit confidence in salary findings |
| **Balance linked to country** | Germany has no zero balances, so country and balance effects can overlap |
| **Unclear product count** | The data does not say whether `products_number` includes a credit card |
| **Undefined "active member"** | The rule used to mark a customer as active is not documented |

---

## 12. Validation

| Check | Result |
|---|---|
| Rows, columns and blank cells re-counted with Python's basic `csv` tool, separately from pandas | **Match** |
| Different customer IDs and full rows re-counted with the `csv` tool | **Match** |
| Category and binary counts re-counted with the `csv` tool | **Match** |
| Original CSV SHA-256 fingerprint compared with its value at the start of Phase 1 | **Unchanged** |
| File name, size and columns compared with Kaggle's listing | **Match** |

**SHA-256 fingerprint of the original CSV:** `90f6625c31bdfcb0cde3b94c4f3004e43795e382921d0a5be67c4bd490b38818`
