# DataAnalytics-Assessment

This repository contains my solutions to the SQL Proficiency Assessment. The goal is to demonstrate expertise in data retrieval, transformation, and analysis using SQL, applied to real-world business scenarios.

## 📁 Repository Structure
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
│
└── README.md


---

## Assessment Overview

The goal of this assessment is to demonstrate proficiency in SQL by solving practical business problems using realistic data. The database included the following core tables:

- `users_customuser`: Customer demographic and contact details
- `plans_plan`: Customer plans (savings, investments)
- `savings_savingsaccount`: Deposit transactions
- `withdrawals_withdrawal`: Withdrawal transactions

---

## Question-by-Question Explanation

###  Q1: High-Value Customers with Multiple Products

**Task**: Identify customers with both funded savings and investment plans, sorted by total deposits.

**Approach**:
- Filter `plans_plan` to select active/funded savings plans (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`)
- Join with `savings_savingsaccount` to sum confirmed deposit amounts
- Group by customer and count the number of distinct savings and investment plans
- Order by total deposits in descending order

###  Q2: Transaction Frequency Analysis

**Task**: Determine how frequently customers transact and categorize them as High, Medium, or Low frequency users.

**Approach**:
- Extract month and year from transaction date to compute monthly transaction frequency per customer
- Calculate average transactions per month per customer
- Bucket customers based on thresholds:
  - High Frequency: ≥10
  - Medium Frequency: 3–9
  - Low Frequency: ≤2
- Aggregate the number of customers in each bucket

###  Q3: Account Inactivity Alert

**Task**: Identify active accounts that have not had inflow transactions for over a year.

**Approach**:
- Filter active plans from `plans_plan`
- Determine the most recent transaction date per plan from `savings_savingsaccount`
- Calculate `inactivity_days` by comparing with the current date
- Select those where `inactivity_days > 365`

###  Q4: Customer Lifetime Value (CLV) Estimation

**Task**: Estimate CLV using transaction count and tenure since signup.

**Approach**:
- Compute account tenure in months using the difference between current date and `date_joined` in `users_customuser`
- Count all transactions per user
- Use the provided CLV formula: CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
- Assume profit per transaction is 0.1% of transaction value
- Order by estimated CLV in descending order
 
##  Challenges Encountered
 
- - **Ambiguous Columns**: Resolved using explicit table aliases in joins.
- **Currency Normalization**: Handled conversion of values stored in kobo to naira where needed for clarity and correctness.
- **Missing Data**: Addressed plans with no transactions using left joins and fallback values (`COALESCE`).

---

##  Notes

- Queries are optimized for clarity and correctness.
- Proper indentation, aliasing, and comments were used throughout.
- The final result reflects an analytical, structured, and scalable approach to solving SQL problems.


  
