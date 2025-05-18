USE adashi_staging;

-- Question 4: Customer Lifetime Value (CLV) Estimation

WITH user_transactions AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,							-- Combine first and last name
        u.date_joined,															-- When customer signed up
        COUNT(s.id) AS total_transactions,										-- Number of transactions made
        SUM(s.confirmed_amount) / 100 AS total_transaction_value_naira			-- Total value of confirmed deposits in Naira
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s 
        ON u.id = s.owner_id AND s.confirmed_amount > 0							-- Only count transactions with actual inflows
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined						
),

clv_calc AS (
    SELECT 
        customer_id,
        name,
        FLOOR(DATEDIFF(CURDATE(), date_joined) / 30) AS tenure_months,			 -- How many months since they joined
        total_transactions,
        
        -- Estimated CLV Formula: (transactions / tenure) * 12 months * average profit per transaction
        --  profit = 0.1% of avg transaction value (assumption)						
        
        ROUND(
            (total_transactions / NULLIF(FLOOR(DATEDIFF(CURDATE(), date_joined) / 30), 0)) 
            * 12 
            * (total_transaction_value_naira / NULLIF(total_transactions, 0)) 
            * 0.001,																				-- Transaction values were already converted from Kobo to Naira earlier
            2
        ) AS estimated_clv
    FROM user_transactions
)
-- Final result: CLV for each customer, ordered from highest to lowest
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
