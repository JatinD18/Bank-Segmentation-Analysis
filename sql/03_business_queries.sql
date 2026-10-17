-- Step 3: Business Queries

USE bank_segmentation;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions;

------------------------------------------------------

-- Query 1: Total Spend per Customer
-- Business Question: Who are our biggest spenders? This helps identify high-value customers for premium banking offers.

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.city,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(t.transaction_id) AS total_debit_transactions,
    ROUND(SUM(t.amount), 2) AS total_spend,
    ROUND(AVG(t.amount), 2) AS avg_transaction_amount
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'debit'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spend DESC
LIMIT 20;

/*Business Insight:
- Chennai leads the top spenders with 4 customers in the top 20.
- Ahmedabad, Pune, and Hyderabad each have 3 customers in the top 20.
- All top 20 high spenders hold multiple accounts, showing that multi-product customers generate higher value.
- Their high spend is driven by frequent high-value debit transactions, not one-time purchases.

Recommendation:
- Target multi-account customers in Chennai, Ahmedabad, Pune, and Hyderabad for premium banking offers.
- Identify single-account customers with high transaction value and encourage them to open a second account.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 2: Salary Trend Analysis
-- Business Question: How are salary credits trending month over month? This indicates employment stability and payroll partnerships.

SELECT 
    DATE_FORMAT(t.transaction_date, '%Y-%m') AS month,
    COUNT(*) AS salary_credit_count,
    ROUND(SUM(t.amount), 2) AS total_salary_credited,
    ROUND(AVG(t.amount), 2) AS avg_salary_amount,
    ROUND(MIN(t.amount), 2) AS min_salary,
    ROUND(MAX(t.amount), 2) AS max_salary
FROM transactions t
WHERE t.service = 'Salary Credit'
  AND t.transaction_type = 'credit'
GROUP BY DATE_FORMAT(t.transaction_date, '%Y-%m')
ORDER BY month;

/*
Business Insight:
- Salary credits grew 117% from Oct 2023 (85 credits) to Jun 2024 (185 credits), indicating strong customer acquisition and payroll partnerships.
- Total salary credited surged from ₹18.7L to ₹50.3L — a 168% increase in just 9 months.
- Average salary peaked in Apr 2024 at ₹28,634, suggesting a shift toward higher-income customers.
- The minimum salary rose from ₹52 in Oct 2023 to ₹5,435 in Apr 2024, confirming the bank is attracting more premium salaried professionals over time.
- Jun 2024 recorded the highest total volume (₹50.3L), likely driven by mid-year bonus payouts.

Recommendation:
- Strengthen corporate payroll tie-ups with companies in the ₹25K-₹50K salary bracket to sustain this growth trajectory.
- Launch targeted credit card and personal loan offers during peak salary months (Mar-Jun) when customer liquidity is highest.
*/ 

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 3: Most Active Accounts (By Transaction Count)
-- Business Question: Which accounts are the most frequently used? These are your most engaged customers.

SELECT 
    a.account_id,
    a.account_type,
    a.status,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount), 2) AS total_volume
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_type, a.status, c.first_name, c.last_name, c.city
ORDER BY transaction_count DESC
LIMIT 20;

/*
Business Insight:
- The most active accounts average 16 to 18 transactions, with "Savings" accounts dominating high-frequency usage, confirming they are the primary vehicle for daily retail banking (UPI, bills).
- Interestingly, some "Fixed Deposit" and "Dormant" accounts appear in the top activity list. This reveals a critical retention issue: high-value, high-frequency customers have recently stopped transacting and slipped into dormancy.
- The total volume moved by these top accounts ranges from ₹3.3L to ₹5.2L, showing that frequent transactors are also high-volume movers.
- Activity is well-distributed across major metros like Mumbai, Bangalore, Lucknow, and Kolkata, rather than concentrated in a single city.

Recommendation:
- Launch an immediate "Win-Back" campaign targeting the "Dormant" accounts that historically show high transaction counts, offering fee waivers or cashback to reactivate them.
- Since Savings accounts drive daily engagement, introduce tiered reward points for every 5th UPI/bill payment to incentivize continued daily usage and prevent them from moving to competitor apps.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 4: Most Active Accounts (By Transaction Volume)
-- Business Question: Which accounts move the most money? This is different from Query 3 — an account might have fewer transactions but much larger amounts.

SELECT 
    a.account_id,
    a.account_type,
    a.status,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount), 2) AS total_volume,
    ROUND(AVG(t.amount), 2) AS avg_per_transaction
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_type, a.status, c.first_name, c.last_name, c.city
ORDER BY total_volume DESC
LIMIT 20;

/*
Business Insight:
- The highest-volume accounts move between ₹4.2L and ₹5.2L, with massive average ticket sizes ranging from ₹26,000 to ₹39,000 per transaction.
- While "Current" and "Savings" accounts dominate the list, some "Fixed Deposit" accounts also appear with high volumes, indicating either large initial funding deposits or premature liquidations.
- A critical finding is that several of these massive volume-movers are currently marked as "Dormant" (e.g., accounts in Lucknow, Delhi, Ahmedabad, and Kolkata), meaning the bank has recently lost touch with some of its most valuable transacting customers.

Recommendation:
- Launch an immediate VIP "Win-Back" outreach program assigning dedicated Relationship Managers to the "Dormant" high-volume accounts to understand why they stopped transacting.
- For the active "Current" accounts moving large sums, cross-sell premium business banking services, trade finance, or high-limit credit products to capture more fee-based revenue from their heavy cash flow.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 5: Monthly Transaction Breakdown
-- Business Question: What's the overall transaction activity per month? This helps with capacity planning and revenue forecasting.

SELECT 
    DATE_FORMAT(t.transaction_date, '%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_volume,
    ROUND(AVG(t.amount), 2) AS avg_transaction_amount,
    SUM(CASE WHEN t.transaction_type = 'credit' THEN 1 ELSE 0 END) AS credit_count,
    SUM(CASE WHEN t.transaction_type = 'debit' THEN 1 ELSE 0 END) AS debit_count
FROM transactions t
GROUP BY DATE_FORMAT(t.transaction_date, '%Y-%m')
ORDER BY month;

/*
Business Insight:
- Transaction activity peaked in Dec 2023 with 2,914 transactions and ₹7.34 crore volume, driven by year-end bonuses, festival spending, and tax-saving investments.
- Oct 2023 was a partial ramp-up month (1,361 transactions), but from Nov 2023 onwards, monthly volume stabilized in the 2,600-2,900 range.
- Feb 2024 recorded the lowest full-month activity (2,630 transactions, ₹6.57 crore) — a classic post-holiday spending dip.
- Average transaction size is remarkably stable at ₹24,500-₹25,200 across all 12 months, indicating consistent customer behavior rather than one-off large transfers.
- Credits and debits are nearly balanced every month (healthy sign), but Jun 2024 and Jul 2024 show debits slightly outnumbering credits (1,443 vs 1,349 and 1,427 vs 1,353), suggesting customers are drawing down savings mid-year.

Recommendation:
- Run targeted "Year-End Wealth" campaigns in Nov-Dec to capitalize on the peak transaction season with investment and insurance products.
- Introduce short-term credit lines or "Buy Now Pay Later" offers during the Feb dip and mid-year (Jun-Jul) when customers are spending more than they earn.
- Since average ticket size is stable, focus growth strategy on increasing transaction FREQUENCY rather than transaction VALUE.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 6: Yearly Transaction Breakdown
-- Business Question: Year-over-year growth or decline? This is the metric a CEO would look at first.

SELECT 
    YEAR(t.transaction_date) AS year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_volume,
    ROUND(AVG(t.amount), 2) AS avg_transaction,
    COUNT(DISTINCT a.customer_id) AS unique_customers_transacting
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
GROUP BY YEAR(t.transaction_date)
ORDER BY year;

/*
Business Insight:
- 2024 and 2025 show remarkable stability, with ~33,300 transactions and ~₹83.2 Crore in total volume each year, indicating a mature and highly retained customer base.
- The average transaction size remained consistently steady at ~₹25,000 across all years, proving that customer spending behavior is predictable and not driven by erratic one-off transfers.
- Unique transacting customers peaked at 9,363 in 2024 and remained strong at 9,335 in 2025, demonstrating excellent year-over-year retention.
- 2023 reflects the initial ramp-up phase (partial year), while 2026 is currently on track to match previous full-year run rates.

Recommendation:
- Since transaction volumes and the active customer base have stabilized, the bank should shift its strategic focus from pure customer acquisition to increasing "Share of Wallet" via cross-selling (loans, credit cards, wealth management).
- Leverage the predictable ₹25,000 average transaction size to introduce automated micro-investment or "round-up" savings features that trigger after standard monthly transactions.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 7: Top 20 High-Value Customers (By Credit Inflow)
-- Business Question: Who are the "whales" bringing the most money into the bank? These customers should get priority relationship management.

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.city,
    c.signup_date,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(t.transaction_id) AS credit_transactions,
    ROUND(SUM(t.amount), 2) AS total_credit_inflow,
    ROUND(AVG(t.amount), 2) AS avg_credit_amount
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'credit'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.signup_date
ORDER BY total_credit_inflow DESC
LIMIT 20;

/*
Business Insight:
- 100% of the top 20 high-value customers hold exactly 3 accounts, proving a direct and undeniable correlation between multi-product adoption and high credit inflow.
- The average credit transaction size ranges from ₹24,000 to ₹36,000, indicating these customers are high-income salaried professionals or business owners.
- High-value customers are well-distributed across both Tier-1 (Delhi, Bangalore, Chennai) and Tier-2 (Lucknow, Jaipur, Ahmedabad) cities, showing that wealth generation is not limited to major metros.
- Both long-term customers (since 2019) and recent joiners (2023) appear in the top 20, meaning account depth (holding 3 products) matters far more than account age.

Recommendation:
- Implement a "3-Product Advantage" onboarding flow where new customers are incentivized (via fee waivers or higher interest rates) to open a third account within their first 6 months.
- Identify customers who currently hold 2 accounts and have average monthly credit inflows > ₹20,000, and target them with personalized wealth management or premium banking offers to push them into the 3-account tier.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 8: Dormant Accounts Detection
-- Business Question: Which customers have gone silent? Identifying dormant accounts is critical for retention campaigns.

SELECT 																								-- | Business Insight:
    c.customer_id,																					-- | The data reveals a critical discrepancy in the database: many accounts 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name, 											-- | marked as "Active" in the system have not had a single transaction in
    c.city, 																						-- | over 1,000 days (nearly 3 years). 
    a.account_id, 																					-- | 
    a.account_type, 																				-- |- This "ghost active" status spans across all account types (Savings,
    a.status, 																						-- | Current, and Fixed Deposits) and all major cities, indicating that 
    MAX(t.transaction_date) AS last_transaction_date, 												-- | the system's dormancy flag is not updating automatically based on
    DATEDIFF(CURDATE(), MAX(t.transaction_date)) AS days_since_last_transaction 					-- | actual user behavior.
FROM customers c 																					-- |
JOIN accounts a ON c.customer_id = a.customer_id 													-- |- The longest period of inactivity detected is 1,085 days, meaning 
LEFT JOIN transactions t ON a.account_id = t.account_id 											-- | the bank is holding liabilities for accounts that have essentially
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, a.account_id, a.account_type, a.status 	-- | been abandoned.
HAVING last_transaction_date IS NULL  																-- |
    OR last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 12 MONTH) 								-- |
ORDER BY days_since_last_transaction DESC 															-- |
LIMIT 30; 																							-- |

/*
Business Insight:
- The data reveals a critical discrepancy in the database: many accounts marked as "Active" in the system have not had a single transaction in over 1,000 days (nearly 3 years). 
- This "ghost active" status spans across all account types (Savings, Current, and Fixed Deposits) and all major cities, indicating that the system's dormancy flag is not updating automatically based on actual user behavior.
- The longest period of inactivity detected is 1,085 days, meaning the bank is holding liabilities for accounts that have essentially been abandoned.

Recommendation:
- Implement an automated nightly SQL script or database trigger to automatically flip the `status` flag to 'Dormant' if `DATEDIFF(CURDATE(), last_transaction_date) > 365`.
- Launch a targeted "Win-Back" reactivation campaign (e.g., offering zero-fee transactions or a small cashback bonus) specifically aimed at these 1,000+ day inactive users to recover lost engagement before they permanently churn to competitor banks.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 9: Single Product Customers (Cross-Sell Opportunity)
-- Business Question: Which customers only have ONE type of account? These are your biggest cross-sell opportunities.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.city,
    COUNT(DISTINCT a.account_type) AS product_count,
    GROUP_CONCAT(DISTINCT a.account_type ORDER BY a.account_type) AS products_held,
    COUNT(DISTINCT a.account_id) AS total_accounts
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING product_count = 1
ORDER BY RAND()
LIMIT 30;
/*
Business Insight:
- A significant segment of the customer base holds only a single banking product, making them highly vulnerable to churn and competitor poaching.
- The single-product holdings are heavily skewed towards everyday transactional accounts (predominantly "Current" and "Savings"), meaning the bank is missing out on capturing their long-term wealth or credit business.
- Customers holding only a "Fixed Deposit" represent a captive audience with available capital, yet they lack a daily transactional relationship with the bank.
- This single-product vulnerability is widespread and evenly distributed across major hubs like Bangalore, Ahmedabad, Lucknow, and Mumbai.

Recommendation:
- Implement an automated cross-sell trigger: when a single-product "Current" or "Savings" account maintains a healthy average monthly balance, prompt the user with a pre-approved offer for a complementary product (like a Fixed Deposit or Credit Card).
- For customers holding ONLY a "Fixed Deposit", launch a targeted campaign offering a zero-fee digital Savings account to capture their daily UPI and bill-payment transaction flow, thereby increasing product stickiness from 1 to 2.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 10: Most Used Transaction Services
-- Business Question: What services do customers use most? This informs product development and marketing spend.

SELECT 
    t.service,
    t.transaction_type,
    COUNT(*) AS usage_count,
    ROUND(AVG(t.amount), 2) AS avg_amount,
    ROUND(SUM(t.amount), 2) AS total_volume,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions), 
        2
    ) AS percentage_of_total
FROM transactions t
GROUP BY t.service, t.transaction_type
ORDER BY usage_count DESC;

/*
Business Insight:
- Transaction usage is remarkably evenly distributed across all 8 core banking services, with each service accounting for roughly 6.1% to 6.4% of total volume. This indicates a highly engaged customer base using the bank for diverse financial needs.
- "Loan EMI" (debit) slightly edges out as the most frequent transaction at 6.39%, followed closely by "Interest Credit" and "Utility Bill Payments", showing that automated and recurring payments dominate user activity.
- The average transaction amount remains highly consistent (between ₹24,100 and ₹25,700) across all services, indicating uniform cash flow behavior among the customer base regardless of the service used.
- Both credit and debit transactions are perfectly balanced across services, reflecting healthy money movement (inflows and outflows) within the bank's ecosystem.

Recommendation:
- Since customers are already using a wide variety of services, the bank should focus on cross-platform bundling (e.g., offering cashback on "Utility Bill Payments" that can be directly redeemed against "Loan EMI" dues) to increase ecosystem stickiness.
- Introduce automated "Auto-Pay" discounts for recurring services like Loan EMIs and Utility Bills to guarantee on-time payments and reduce manual transaction processing costs.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 11: City-wise Performance
-- Business Question: Which cities drive the most revenue? This helps decide where to open new branches or run targeted campaigns.
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_transaction_volume,
    ROUND(AVG(t.amount), 2) AS avg_transaction_amount,
    ROUND(SUM(t.amount) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.city
ORDER BY total_transaction_volume DESC;
/*
Business Insight:
- Bangalore is the undisputed volume leader, driving the highest total transaction volume (₹274.1M) and the highest number of transactions (10,911).
- Pune is the efficiency champion: despite having fewer total customers than Bangalore, Mumbai, or Chennai, it generates the highest revenue per customer (₹257,093).
- Kolkata customers exhibit the highest average transaction size (₹25,392), indicating a market highly comfortable with large-ticket transfers.
- Baseline spending behavior is remarkably uniform nationally, with the average transaction amount tightly clustered between ₹24,700 and ₹25,300 across all 8 cities.

Recommendation:
- Investigate and replicate the specific product bundles or wealth-management strategies driving Pune's high revenue-per-customer across other major metros.
- Target Kolkata's customer base with high-limit credit cards, premium personal loans, or mortgage products, leveraging their proven comfort with large transaction sizes.
- Prioritize digital infrastructure scaling and localized customer support in Bangalore to ensure seamless service for the disproportionately high transaction volume.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Query 12: Engagement by Region (Active vs Dormant Split)
-- Business Question: What's the active/dormant account split per city? High dormancy in a city signals a retention problem.

SELECT 
    c.city,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT CASE WHEN a.status = 'Active' THEN a.account_id END) AS active_accounts,
    COUNT(DISTINCT CASE WHEN a.status = 'Dormant' THEN a.account_id END) AS dormant_accounts,
    ROUND(
        COUNT(DISTINCT CASE WHEN a.status = 'Active' THEN a.account_id END) * 100.0 / 
        COUNT(DISTINCT a.account_id), 
        1
    ) AS active_percentage,
    ROUND(
        COUNT(DISTINCT CASE WHEN a.status = 'Dormant' THEN a.account_id END) * 100.0 / 
        COUNT(DISTINCT a.account_id), 
        1
    ) AS dormant_percentage
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.city
ORDER BY dormant_percentage DESC;

/*
Business Insight:
- Dormancy rates are remarkably consistent across all regions, ranging from a low of 9.3% in Pune to a high of 11.0% in Lucknow.
- Pune leads in customer retention with the highest active account percentage (90.7%), while Northern and Eastern cities like Lucknow (11.0%), Delhi (10.4%), and Kolkata (10.3%) show slightly higher churn.
- Bangalore is the largest active hub, holding the highest total number of accounts (1,652) and active accounts (1,491), followed closely by Ahmedabad and Mumbai.
- The narrow 1.7% gap between the best (Pune) and worst (Lucknow) performing cities indicates that systemic product or service issues, rather than localized branch failures, are likely driving dormancy.

Recommendation:
- Conduct a qualitative study on Pune's customer success and branch operations to identify best practices that can be replicated in higher-churn Northern cities like Lucknow and Delhi.
- Since the dormancy rate is relatively uniform nationwide, launch a centralized, digital-first "Win-Back" campaign targeting the ~10% dormant base across all regions, rather than relying on fragmented, city-specific branch interventions.
*/