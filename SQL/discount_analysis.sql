
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Discount and Profitability

USE ecommerce_analytics;

-- 1. Sales and profit by discount level
SELECT
    Discount,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM superstore
GROUP BY Discount
ORDER BY Discount;

-- 2. Discount levels associated with losses
SELECT
    Discount,
    COUNT(*) AS order_rows,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(AVG(Profit), 2) AS average_profit_per_row
FROM superstore
GROUP BY Discount
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;

-- 3. Products with the lowest profit
SELECT
    `Product Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS average_discount_percentage
FROM superstore
GROUP BY `Product ID`, `Product Name`
ORDER BY total_profit ASC
LIMIT 10;
