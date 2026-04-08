-- Q1: For every user get user_id and last booked room_no

SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY booking_date DESC
        ) AS rn
    FROM bookings
) t
WHERE rn = 1;

-- Q2

SELECT 
    bc.booking_id,
    SUM(i.item_rate * bc.item_quantity) AS total_billing
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE 
    EXTRACT(MONTH FROM bc.bill_date) = 11
    AND EXTRACT(YEAR FROM bc.bill_date) = 2021
GROUP BY bc.booking_id;

-- Q3

SELECT 
    bc.bill_id,
    SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE 
    EXTRACT(MONTH FROM bc.bill_date) = 10
    AND EXTRACT(YEAR FROM bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000;

-- Q4

WITH monthly_items AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        item_id,
        SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY month, item_id
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rnk_desc,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS rnk_asc
    FROM monthly_items
)
SELECT *
FROM ranked
WHERE rnk_desc = 1 OR rnk_asc = 1;

-- Q5

WITH monthly_bills AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        bill_id,
        SUM(i.item_rate * bc.item_quantity) AS bill_amount
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY month, bill_id
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY month 
            ORDER BY bill_amount DESC
        ) AS rnk
    FROM monthly_bills
)
SELECT *
FROM ranked
WHERE rnk = 2;


