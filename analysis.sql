-- E-Commerce Sales & Customer Analytics
-- Dataset: UK Online Retail 2010-2011
-- Source: https://www.kaggle.com/datasets/carrie1/ecommerce-data

-- monthly revenue and order trends

SELECT 
    DATE_TRUNC('month', invoice_date) AS month,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
FROM transactions
WHERE quantity > 0 AND unit_price > 0
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;

-- top 10 products by revenue

SELECT 
    stock_code,
    description,
    SUM(quantity) AS total_units_sold,
    SUM(quantity * unit_price) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS times_ordered
FROM transactions
WHERE quantity > 0 AND unit_price > 0
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;

-- top 10 customers by total spend

SELECT 
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity * unit_price) AS total_spent,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value,
    MIN(invoice_date) AS first_purchase,
    MAX(invoice_date) AS last_purchase
FROM transactions
WHERE quantity > 0 
    AND unit_price > 0 
    AND customer_id IS NOT NULL
    AND customer_id != ''
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- revenue by country

SELECT 
    country,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
FROM transactions
WHERE quantity > 0 AND unit_price > 0
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- top 5 countries by revenue per month using window functions

WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', invoice_date) AS month,
        country,
        SUM(quantity * unit_price) AS revenue
    FROM transactions
    WHERE quantity > 0 AND unit_price > 0
    GROUP BY DATE_TRUNC('month', invoice_date), country
)
SELECT 
    month,
    country,
    revenue,
    RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS country_rank,
    ROUND(revenue / SUM(revenue) OVER (PARTITION BY month) * 100, 2) AS revenue_percentage
FROM monthly_revenue
WHERE country_rank <= 5
ORDER BY month, country_rank;

-- cancellations and returns

SELECT 
    COUNT(*) AS total_cancellations,
    SUM(ABS(quantity)) AS total_units_returned,
    SUM(ABS(quantity * unit_price)) AS total_value_returned
FROM transactions
WHERE quantity < 0;

-- transactions with missing customer IDs

SELECT 
    COUNT(*) AS transactions_without_customer,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions), 2) AS percentage
FROM transactions
WHERE customer_id IS NULL OR customer_id = '';

-- invoices with unusually high line items

SELECT 
    invoice_no,
    COUNT(*) AS line_items
FROM transactions
GROUP BY invoice_no
HAVING COUNT(*) > 20
ORDER BY line_items DESC
LIMIT 10;

-- customer segmentation by spend

WITH customer_stats AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price) AS total_spent,
        COUNT(DISTINCT invoice_no) AS total_orders,
        MAX(invoice_date) AS last_purchase
    FROM transactions
    WHERE quantity > 0 
        AND unit_price > 0
        AND customer_id IS NOT NULL
        AND customer_id != ''
    GROUP BY customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        total_spent,
        total_orders,
        last_purchase,
        CASE 
            WHEN total_spent > 10000 THEN 'High Value'
            WHEN total_spent > 1000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS segment
    FROM customer_stats
)
SELECT 
    segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_spent,
    ROUND(AVG(total_orders), 2) AS avg_orders
FROM customer_segments
GROUP BY segment
ORDER BY avg_spent DESC;