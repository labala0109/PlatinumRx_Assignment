-- =====================================================
-- CLINIC MANAGEMENT SYSTEM QUERIES
-- SQL Dialect: PostgreSQL
-- =====================================================

-- Q1: Revenue from each sales channel in 2021

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;


-- =====================================================

-- Q2: Top 10 most valuable customers in 2021

SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;


-- =====================================================

-- Q3: Month-wise revenue, expense, profit and status

WITH revenue AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY month
),
expense AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY month
)
SELECT 
    r.month,
    r.total_revenue,
    e.total_expense,
    (r.total_revenue - e.total_expense) AS profit,
    CASE
        WHEN (r.total_revenue - e.total_expense) > 0
        THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
JOIN expense e ON r.month = e.month;


-- =====================================================

-- Q4: Most profitable clinic per city for given month (Example: September)

WITH clinic_profit AS (
    SELECT 
        c.city,
        c.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    WHERE EXTRACT(MONTH FROM cs.datetime) = 9
    GROUP BY c.city, c.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 1;


-- =====================================================

-- Q5: Second least profitable clinic per state (Example: September)

WITH clinic_profit AS (
    SELECT 
        c.state,
        c.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    WHERE EXTRACT(MONTH FROM cs.datetime) = 9
    GROUP BY c.state, c.cid
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY state 
            ORDER BY profit ASC
        ) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 2;