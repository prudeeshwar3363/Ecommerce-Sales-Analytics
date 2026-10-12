
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Shipping Modes and Customer Segments

USE ecommerce_analytics;

-- 1. Sales and profit by shipping mode
SELECT
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(COUNT(DISTINCT `Order ID`), 0),
        2
    ) AS profit_per_order
FROM superstore
GROUP BY `Ship Mode`
ORDER BY total_orders DESC;

-- 2. Sales and profit by customer segment
SELECT
    Segment,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;
