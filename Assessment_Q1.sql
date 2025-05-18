USE adashi_staging;

-- Question 1: High-Value Customers with Multiple Products

WITH savings_plans AS (
-- Aggregate savings plans per customer: count of savings plans and sum of confirmed deposits
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS savings_count,
        SUM(s.confirmed_amount) AS total_savings_deposits
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id    
    WHERE p.is_regular_savings = 1							-- Only regular savings plans
      AND s.confirmed_amount > 0							-- Only consider funded deposits
    GROUP BY p.owner_id
),

investment_plans AS (
 -- Aggregate investment plans per customer: count of investment plans funded
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS investment_count
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_a_fund = 1                               -- Only investment/fund plans
      AND s.confirmed_amount > 0						-- Only consider funded deposits
    GROUP BY p.owner_id
)

SELECT 
    u.id AS owner_id,
    u.name,
    sp.savings_count,
    ip.investment_count,
    ROUND(COALESCE(sp.total_savings_deposits, 0) / 100.0, 2) AS total_deposits  -- Convert kobo to naira
FROM users_customuser u
JOIN savings_plans sp ON u.id = sp.owner_id 	   -- Only customers with savings plans
JOIN investment_plans ip ON u.id = ip.owner_id	   -- And also investment plans
ORDER BY total_deposits DESC;                      -- Sort by total deposits, highest first
