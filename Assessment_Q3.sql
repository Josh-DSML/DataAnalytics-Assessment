USE adashi_staging;

-- Question 3: Account Inactivity Alert

WITH last_transactions AS (
-- Get the latest confirmed transaction date per plan for active savings or investment plans
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings' 		-- Identify plan type Savings
            WHEN p.is_a_fund = 1 THEN 'Investment'				-- Identify plan type Investment
            ELSE 'Other'										-- any other type, should in case
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date		-- Latest confirmed transaction date
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id AND s.confirmed_amount > 0	 -- Only consider positive inflow transactions
    WHERE 
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)				-- Only savings or investment plans
        AND p.status_id = 1  -- Only active plans					 -- Only active plans
    GROUP BY p.id, p.owner_id, type
)
-- Select plans where last transaction was either never done or older than 365 days
SELECT 
    lt.plan_id,
    lt.owner_id,
    lt.type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days   	-- Days since last transaction
FROM last_transactions lt
WHERE 
    lt.last_transaction_date IS NULL 									 -- No transaction at all
    OR DATEDIFF(CURDATE(), lt.last_transaction_date) > 365				-- Last transaction > 1 year ago
ORDER BY inactivity_days DESC;											 -- Sort with most inactive first
