-- Step 4: Advanced RFM Segmentation

-- Query 1: The RFM Segmentation (One Query, Done)

/*
RFM Segmentation: Classify customers into behavior-based segments
using Recency, Frequency, and Monetary scoring.
*/
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.city,
        DATEDIFF(CURDATE(), MAX(t.transaction_date)) AS recency_days,
        COUNT(t.transaction_id) AS frequency,
        ROUND(SUM(t.amount), 2) AS monetary
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
),
rfm_scored AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_metrics
)
SELECT 
    customer_id,
    full_name,
    city,
    recency_days,
    frequency,
    monetary,
    CONCAT(r_score, f_score, m_score) AS rfm_code,
    CASE 
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 3 AND m_score >= 3 THEN 'Big Spenders'
        WHEN r_score >= 3 THEN 'Recent Customers'
        WHEN f_score >= 3 AND m_score >= 3 THEN 'At Risk'
        WHEN f_score >= 3 THEN 'Need Attention'
        ELSE 'Hibernating'
    END AS customer_segment
FROM rfm_scored
ORDER BY monetary DESC
LIMIT 50;

-- Query 2: RFM Segment Summary

/*
RFM Segment Distribution: How many customers fall into each segment?
*/
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        DATEDIFF(CURDATE(), MAX(t.transaction_date)) AS recency_days,
        COUNT(t.transaction_id) AS frequency,
        SUM(t.amount) AS monetary
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    GROUP BY c.customer_id
),
rfm_scored AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_metrics
),
segmented AS (
    SELECT 
        CASE 
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
            WHEN r_score >= 3 AND m_score >= 3 THEN 'Big Spenders'
            WHEN r_score >= 3 THEN 'Recent Customers'
            WHEN f_score >= 3 AND m_score >= 3 THEN 'At Risk'
            WHEN f_score >= 3 THEN 'Need Attention'
            ELSE 'Hibernating'
        END AS customer_segment
    FROM rfm_scored
)
SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM segmented), 1) AS percentage
FROM segmented
GROUP BY customer_segment
ORDER BY total_customers DESC;