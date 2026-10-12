
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Sales and Profitability by Category and Sub-Category

USE ecommerce_analytics;

-- 1. Sales, profit, and quantity by category
SELECT
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM superstore
GROUP BY Category
ORDER BY total_sales DESC;

-- 2. Profit by category
SELECT
    Category,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;

-- 3. Sales and profit by sub-category
SELECT
    Sub_Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Sub_Category
ORDER BY total_profit DESC;
