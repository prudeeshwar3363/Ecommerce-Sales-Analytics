
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Customer Profitability and Average Order Value

USE ecommerce_analytics;

-- 1. Top 10 customers by total profit
SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_profit DESC
LIMIT 10;

-- 2. Top 10 customers by average order value
SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Sales) AS total_sales,
    ROUND(
        SUM(Sales) / NULLIF(COUNT(DISTINCT `Order ID`), 0),
        2
    ) AS average_order_value
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY average_order_value DESC
LIMIT 10;

-- 3. Sales and profit by customer segment
SELECT
    Segment,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;
