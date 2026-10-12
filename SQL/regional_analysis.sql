
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Regional Sales and Profitability

USE ecommerce_analytics;

-- 1. Sales and profit by region
SELECT
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;

-- 2. Sales and profit by region and category
SELECT
    Region,
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region, Category
ORDER BY Region, total_sales DESC;

-- 3. Year-over-year sales growth by region
WITH yearly_sales AS (
    SELECT
        Region,
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS order_year,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY
        Region,
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
),
sales_comparison AS (
    SELECT
        Region,
        order_year,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Region
            ORDER BY order_year
        ) AS previous_year_sales
    FROM yearly_sales
)
SELECT
    Region,
    order_year,
    total_sales,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison
ORDER BY Region, order_year;

-- Note: This assumes Order Date is stored as text in DD-MM-YYYY format. If it is already a MySQL DATE column, use YEAR('Order Date') instead.