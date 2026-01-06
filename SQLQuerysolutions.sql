--SHOW TABLES

SELECT * FROM customers
SELECT * FROM orders
SELECT * FROM product_orders
SELECT * FROM [products ]

--CHANGE THE ORDERS TABLE DATE COLUMN DATATYPE
--ADD NEW COLUMN FOR CHANGING DATE TYEP
ALTER TABLE orders
ADD order_date_clean DATE;

--CHANGE THE DATATYPE TEXT TO DATE 
UPDATE orders
SET order_date_clean =
    CASE
        WHEN order_date LIKE '%/%' THEN TRY_CONVERT(DATE, order_date, 101)  -- MM/DD/YYYY
        WHEN order_date LIKE '%-%' THEN TRY_CONVERT(DATE, order_date, 105)  -- DD-MM-YYYY
    END;

--PK IS DEPENDCE ON THE ORDER_dATE COLUMN SO FIRST DELETE PK
ALTER TABLE orders
DROP CONSTRAINT PK_orders;

--DELETE ORDER DATE COLUMN
ALTER TABLE orders
DROP COLUMN order_date;


EXEC sp_rename 'orders.order_date_clean', 'order_date', 'COLUMN';

--Total revenue generated?

SELECT 
 SUM(PO.quantity * PO.unit_price) AS Total_revenue
FROM product_orders AS PO

--Total number of orders placed?

SELECT COUNT(DISTINCT O.order_id) AS Total_orders FROM orders AS O

-- ORDER_REVENUE BY ORDER ID

SELECT
    po.order_id,
    SUM(po.quantity * po.unit_price) AS order_revenue
FROM product_orders po
GROUP BY po.order_id
ORDER BY order_revenue DESC

--Revenue by year
SELECT 
    YEAR(o.order_date) AS order_year,
    SUM(po.quantity * po.unit_price) AS revenue
FROM orders o
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY YEAR(o.order_date)
ORDER BY order_year;

--Top 10 customers by revenue
SELECT TOP 10
    c.customer_id,
    c.first_name,
    SUM(po.quantity * po.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC;

--Repeat customers (more than 1 order)

SELECT 
    customer_id,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

--Customer lifetime value (CLV)
SELECT
    c.customer_id,
    SUM(po.quantity * po.unit_price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY c.customer_id;

--Top 5 products by revenue
SELECT TOP 5
    p.product_name,
    SUM(po.quantity * po.unit_price) AS product_revenue
FROM [products ] p
JOIN product_orders po ON p.product_id = po.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC;

--Product type wise revenue
SELECT
    p.product_type,
    SUM(po.quantity * po.unit_price) AS revenue
FROM [products ] p
JOIN product_orders po ON p.product_id = po.product_id
GROUP BY p.product_type
ORDER BY revenue DESC;

--Low performing products (below avg revenue)
WITH product_revenue AS (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS revenue
    FROM product_orders
    GROUP BY product_id
)
SELECT *
FROM product_revenue
WHERE revenue < (SELECT AVG(revenue) FROM product_revenue);

--TIME-BASED ANALYSIS
--Monthly sales trend
SELECT
    FORMAT(o.order_date, 'yyyy-MM') AS order_month,
    SUM(po.quantity * po.unit_price) AS revenue
FROM orders o
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY order_month;

--Best sales month
SELECT TOP 1
    FORMAT(o.order_date, 'yyyy-MM') AS order_month,
    SUM(po.quantity * po.unit_price) AS revenue
FROM orders o
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY revenue DESC;

--Rank customers by revenue
SELECT
    c.customer_id,
    SUM(po.quantity * po.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(po.quantity * po.unit_price) DESC) AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY c.customer_id;

--Cumulative revenue over time
SELECT
    o.order_date,
    SUM(po.quantity * po.unit_price) AS daily_revenue,
    SUM(SUM(po.quantity * po.unit_price))
        OVER (ORDER BY o.order_date) AS cumulative_revenue
FROM orders o
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

--Product performance segmentation
SELECT
    p.product_name,
    CASE
        WHEN SUM(po.quantity * po.unit_price) > 50000 THEN 'High'
        WHEN SUM(po.quantity * po.unit_price) BETWEEN 20000 AND 50000 THEN 'Medium'
        ELSE 'Low'
    END AS performance_category
FROM [products ] p
JOIN product_orders po ON p.product_id = po.product_id
GROUP BY p.product_name;

--Year-over-Year growth

SELECT
    YEAR(o.order_date) AS order_year,
    SUM(po.quantity * po.unit_price) AS revenue,
    LAG(SUM(po.quantity * po.unit_price))
        OVER (ORDER BY YEAR(o.order_date)) AS prev_year_revenue
FROM orders o
JOIN product_orders po ON o.order_id = po.order_id
GROUP BY YEAR(o.order_date);















