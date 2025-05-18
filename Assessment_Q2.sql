USE adashi_staging;

-- Question 2: Transaction Frequency Analysis

WITH customer_activity AS (
-- Calculate total transactions per customer and the number of active months they’ve been transacting
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
-- Calculate average transactions per month per customer and classify into categories
frequency_classification AS (
    SELECT
        ca.owner_id,
        ROUND(ca.total_transactions / ca.active_months, 2) AS avg_txn_per_month,
        CASE
            WHEN (ca.total_transactions / ca.active_months) >= 10 THEN 'High Frequency'
            WHEN (ca.total_transactions / ca.active_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_activity ca
)
-- Aggregate by frequency categories showing number of customers and avg transactions per month
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM frequency_classification
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;										-- Ensure output order: High > Medium > Low frequency
