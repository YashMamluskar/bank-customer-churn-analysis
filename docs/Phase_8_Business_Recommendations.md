# Phase 8: Business Recommendations and Storytelling

| Item | Details |
|---|---|
| **Project** | Bank Customer Churn Analysis |
| **Phase** | 8 of 9 |
| **Date** | 7 November 2026 |
| **Status** | Complete |
| **Evidence used** | Phase 4 (Python), Phase 5 (SQL) and Phase 7 (Power BI) results |

> **How to read this report:** these are ideas for the bank to test, not proven solutions. The data shows which groups have higher churn, but not why customers left. All counts are for customers in this dataset. No savings, revenue or profit are estimated, because the data has no financial results. Balance is an account amount, not revenue or profit.

---

## 1. Summary

**The situation:** 2,037 of 10,000 customers churned (20.37%). The period is not defined, so this is not a monthly or annual rate.

**The main message:** churn is not spread evenly. It is higher among customers aged 40 to 59, German customers with balances above 100,000 to 150,000, inactive members and customers holding one product.

**What we recommend:**

| Priority | Recommendation | Type |
|---|---:|---|
| 1 | Start recording why and when customers leave | Improve data |
| 2 | Pilot re-engagement for inactive customers with one product | Test |
| 3 | Review German customers with balances above 100,000 to 150,000 | Investigate |
| 4 | Research the needs of customers aged 40 to 59 | Research, then test |
| 5 | Review customers with 3 or 4 products before any promotion | Investigate |
| 6 | Test whether a useful second product helps one-product customers | Test |
| 7 | Research the gap between female and male customers | Research |
| 8 | Track results using the dashboard with dated data | Monitor |

**How the order was chosen:** this is a judgement based on the strength of the evidence, the number of customers involved and how much each step helps the others. The data has no cost information, so this is not a return-on-investment ranking.

---

## 2. How to Read the Numbers

- **Churn rate:** of the customers in a group, the percentage who left. This shows how concentrated churn is within that group.
- **Share of churn:** of all 2,037 churned customers, the percentage from a group. This shows how much of the total comes from that group.
- **Retained customers:** customers in the group who did not leave. This shows how many customers an action could still reach.

**Groups overlap.** One customer can be inactive, German and aged 45 at once, so the counts below must not be added together.

---

## 3. Recommendations

### Recommendation 1: Start recording why and when customers leave

| | |
|---|---|
| **What the data shows** | The dataset has no churn dates, reasons for leaving, complaints or product names. "Active member" is not defined either |
| **Why it matters** | Without this information, the bank can see who left but cannot tell why. Every other recommendation depends on better evidence |
| **Suggested action** | Record the closing date and reason for each departure, use a short exit survey, define "active", and record which products each customer holds |
| **How to measure it** | Share of departures with a recorded date and reason |
| **Caution** | This does not reduce churn by itself, but it makes later tests easier to judge |

### Recommendation 2: Pilot re-engagement for inactive customers with one product

| | |
|---|---|
| **What the data shows** | This group has 2,521 customers and a 36.65% churn rate, compared with 18.92% for active customers with one product. It accounts for 45.36% of all churn, the largest share of any two-characteristic group |
| **Why it matters** | It is the largest single source of churned customers, and 1,597 retained customers remain reachable |
| **Suggested action** | Test simple re-engagement with some of these customers, such as helpful service reminders or personal contact. Compare them with a similar group that receives the bank's normal service |
| **How to measure it** | Churn rate and active member rate, compared between the two groups |
| **Caution** | Inactivity may be an early sign that a customer has already decided to leave, rather than the reason. Raising activity may not reduce churn, which is why a comparison group is needed |

### Recommendation 3: Review German customers with balances above 100,000 to 150,000

| | |
|---|---|
| **What the data shows** | This group has 1,652 customers and a 39.10% churn rate, and it accounts for 31.71% of all churn. The same balance band is 16.12% in France and 14.67% in Spain. Other German customers are at 19.60% |
| **Why it matters** | Germany's high overall rate (32.44%) is concentrated in this one group, so a Germany-wide response may be poorly aimed. 1,006 retained customers are in this group |
| **Suggested action** | Before designing any offer, review German pricing, rates, service and competitor offers for these customers, and speak with German branch staff and customers |
| **How to measure it** | Findings from the review first. If a change follows, compare churn rate before and after, ideally with a comparison group |
| **Caution** | The data contains no information on local market conditions, so the reason for this pattern is unknown |

### Recommendation 4: Research the needs of customers aged 40 to 59

| | |
|---|---|
| **What the data shows** | Ages 40 to 49 have a 30.79% churn rate and ages 50 to 59 have 56.04%. Together, they are 34.87% of customers but 63.48% of churned customers. Inactive customers aged 50 to 59 reach 81.23% |
| **Why it matters** | This is the clearest age pattern in the data. Ages 50 to 59 have the highest rate (382 retained customers), while ages 40 to 49 offer the larger audience (1,812 retained customers) |
| **Suggested action** | Interview customers and review whether current products suit their needs, such as retirement planning or changing family finances. Use the findings to design a small test |
| **How to measure it** | Research findings first, then churn rate in a test against a comparison group |
| **Caution** | The needs listed are ideas to explore, not findings from this data. Offers should be based on customer needs, and any age-based treatment should have a legal and fairness review. Only 70 retained customers are in the inactive 50 to 59 group, so it is too small to be a large programme by itself |

### Recommendation 5: Review customers with 3 or 4 products before any promotion

| | |
|---|---|
| **What the data shows** | 82.71% of the 266 customers with 3 products churned, and all 60 customers with 4 products churned (a small group). Customers with 2 products have the lowest rate (7.58%) |
| **Why it matters** | Holding more products does not simply go with staying. A result of 100% is unusual, and the bank should understand it before encouraging customers to take more products |
| **Suggested action** | Check whether the data is correct, which products are involved, whether they were sold together, and whether these customers made complaints. Pause any promotion of a third or fourth product to existing customers until this is understood |
| **How to measure it** | Findings from the review |
| **Caution** | These groups are small (46 retained customers with 3 products, and none with 4), so this is a review rather than a retention programme |

### Recommendation 6: Test whether a useful second product helps one-product customers

| | |
|---|---|
| **What the data shows** | Customers with 1 product have a 27.71% churn rate and 69.17% of all churn. Customers with 2 products have 7.58% |
| **Why it matters** | 3,675 retained customers hold one product, making this the largest audience in this report |
| **Suggested action** | Offer a relevant second product to some of these customers, and compare them with a similar group that does not receive the offer |
| **How to measure it** | Churn rate in the two groups, and whether customers actually use the second product |
| **Caution** | This is the easiest finding to misread. Customers who already plan to stay may simply be more likely to take a second product. If so, selling more products would not reduce churn, and only a controlled test can show the difference |

### Recommendation 7: Research the gap between female and male customers

| | |
|---|---|
| **What the data shows** | The churn rate is 25.07% for female customers and 16.46% for male customers. Female customers are 45.43% of customers but 55.92% of churned customers |
| **Why it matters** | This is a sizeable gap between two large groups, and the data does not explain it |
| **Suggested action** | Compare service experiences, product fit and complaints between the two groups, using surveys and customer feedback |
| **How to measure it** | Research findings |
| **Caution** | Gender is not a cause, and this finding does not support gender-based offers or pricing. The aim is to find out whether something in the customer experience needs fixing |

### Recommendation 8: Track results using the dashboard with dated data

| | |
|---|---|
| **What the data shows** | The dashboard gives one view of churn, but this dataset has no dates, so it cannot show change over time |
| **Why it matters** | The bank cannot tell whether churn is improving without comparing periods |
| **Suggested action** | Refresh the dashboard with dated data at a regular interval, and add the results of each test |
| **How to measure it** | Churn rate, retention rate, active member rate and churn contribution by group over time |
| **Caution** | This needs Recommendation 1 to be in place first |

---

## 4. How to Run the Tests

Recommendations 2, 3, 4 and 6 can use the same simple approach:

1. **Choose a clear group,** such as inactive customers with one product.
2. **Split it into two similar parts,** ideally at random. One receives the new action, and the other receives normal service.
3. **Decide the measure and time period in advance,** so the result cannot be chosen afterwards.
4. **Compare churn rates between the two parts.** A comparison group helps separate the effect of the action from other changes.
5. **Check the cost before expanding.** The bank has this information, but this dataset does not.

This report sets no numeric targets, because the data gives no basis for them. The bank should set them using its own costs and goals.

---

## 5. What Not to Do Based on This Data

- **Don't claim causes.** For example, the data does not show that being inactive or living in Germany makes customers leave.
- **Don't target on tenure, credit card, credit score or salary alone.** Each shows little difference, within 3.40 percentage points.
- **Don't treat 185,588,094.63 as lost money.** It is the balance held by churned customers, not lost revenue or profit.
- **Don't add segment shares together.** The groups overlap.
- **Don't describe 20.37% as a monthly or annual rate.** The period is not defined.
- **Don't rely on the 100% figure alone.** It comes from only 60 customers.
- **Don't apply these results to all banks.** Kaggle lists the data's original source as "Unknown".

---

## 6. The Business Story

### The problem

A bank is losing customers and needs to know where to focus its retention effort. Treating every customer the same could spend effort on customers who would have stayed anyway, and miss those who are more likely to leave.

### What we did

We cleaned and checked data on 10,000 customers, analysed it in Python, reproduced the results in SQL, and built an interactive Power BI dashboard. Every stage kept the same figures.

### What we found

1. **About 1 in 5 customers left** (2,037 customers, 20.37%).
2. **Age shows a strong pattern.** Churn rises from 7.56% under 30 to 56.04% at ages 50 to 59.
3. **Activity and product holdings matter to the picture.** Inactive customers with one product make up 45.36% of all churn.
4. **Germany's headline hides the detail.** Its high rate is concentrated among customers with balances above 100,000 to 150,000 (39.10%), and other German customers are at 19.60%.
5. **Some things matter less than expected.** Tenure, credit card, credit score and salary show little difference.

### What it means

The bank has clear groups to investigate first, but the data shows where churn is concentrated and not why it happens. So the next step is to learn why and test carefully, rather than launch a large campaign straight away.

### What happens next

Start recording why customers leave, pilot re-engagement with inactive one-product customers, and review the German group. Measure each test against a comparison group before expanding it.

---

## 7. Presenting This Project

### A one-minute summary

> "I analysed 10,000 bank customers to find out where churn is concentrated. About 20% left. Using Python, SQL and Power BI, I found that churn is much higher among customers aged 40 to 59, inactive members and customers with one product, and that Germany's high rate sits mostly in one balance group. I separated churn rate from share of churn, because a group with the highest rate is not always the largest source of churn. I checked that all three tools gave the same numbers. The data can't explain why customers left, so my recommendations are to record exit reasons, then test re-engagement against a comparison group."

### Walking through the dashboard

1. **Executive Overview:** start with the KPI cards, then point out Germany and ages 50 to 59. Show a slicer working.
2. **Customer Churn Analysis:** show which characteristics separate customers clearly, and which show little difference. Showing "no difference" is useful too.
3. **Customer Segments & Risk:** explain the Germany balance pattern, then the priority table and its rule.

### Questions you might be asked

**What is the difference between churn rate and share of churn?**
Churn rate divides by customers in the group, and share of churn divides by all churned customers. Ages 50 to 59 have the highest rate (56.04%), but ages 40 to 49 are the largest source (39.57%), because that group is larger.

**Why didn't you remove outliers or very low salaries?**
They were unusual, but nothing proved they were wrong. Removing valid customers would change the results, so they were kept and flagged.

**How do you know your numbers are right?**
Python, SQL and Power BI were compared with each other. For example, Phase 5 found 0 differences across 24 key measures, and Phase 7 passed 380 of 380 checks. I also checked that the source files stayed unchanged.

**Why no machine learning?**
The goal was to explain patterns to a business audience, which descriptive analysis does well. This project was scoped as data analysis.

**Do 2 products cause customers to stay?**
The data can't show that. Customers planning to stay may simply be more likely to hold two products, so I recommended a controlled test.

**What was the most surprising finding?**
That Germany's high rate is concentrated in one balance group, and that all 60 customers with 4 products churned. The second result is why I recommended checking the data before acting.

**What would you do with more time or data?**
Add churn dates, reasons for leaving, product names and complaint records. That would allow trend analysis and a better understanding of why customers leave.

---

## 8. Limitations

- **No causes:** the data shows patterns, not reasons for leaving.
- **No time information:** there are no dates, and the churn period is undefined.
- **No financial results:** no revenue, profit or campaign costs are available.
- **Unverified meanings:** 1 = active in `active_member`, `tenure` in years and one shared currency are not confirmed by Kaggle.
- **Unknown source:** Kaggle lists the original source as "Unknown", and the data may not represent a real bank.
- **Salary caution:** very low values and an unusually even spread limit confidence in salary findings.
- **Ideas beyond the data:** the suggested actions and the customer needs mentioned are ideas to test, and do not come from the data.
