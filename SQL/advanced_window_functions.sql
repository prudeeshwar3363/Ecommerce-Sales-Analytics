
-- Project: E-commerce Sales & Profitability Analytics
-- Analysis: Advanced SQL Window Functions

USE ecommerce_analytics;

-- 1. Year-over-year sales growth by category
WITH yearly_sales AS (
    SELECT
        Category,
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS order_year,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY
        Category,
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
),
sales_comparison AS (
    SELECT
        Category,
        order_year,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Category
            ORDER BY order_year
        ) AS previous_year_sales
    FROM yearly_sales
)
SELECT
    Category,
    order_year,
    total_sales,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison
ORDER BY Category, order_year;

-- 2. Month-over-month sales comparison
WITH monthly_sales AS (
    SELECT
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS order_year,
        MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS month_number,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
        MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
),
sales_comparison AS (
    SELECT
        order_year,
        month_number,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY order_year, month_number
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    order_year,
    month_number,
    total_sales,
    previous_month_sales,
    ROUND(
        (total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison
ORDER BY order_year, month_number;

-- 3. Top 3 sub-categories by profit in each region
WITH subcategory_profit AS (
    SELECT
        Region,
        `Sub-Category` AS sub_category,
        SUM(Profit) AS total_profit
    FROM superstore
    GROUP BY Region, `Sub-Category`
),
ranked_subcategories AS (
    SELECT
        Region,
        sub_category,
        total_profit,
        DENSE_RANK() OVER (
            PARTITION BY Region
            ORDER BY total_profit DESC
        ) AS profit_rank
    FROM subcategory_profit
)
SELECT
    Region,
    sub_category,
    total_profit,
    profit_rank
FROM ranked_subcategories
WHERE profit_rank <= 3
ORDER BY Region, profit_rank;

-- 4. Cumulative monthly sales within each year
WITH monthly_sales AS (
    SELECT
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS order_year,
        MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS month_number,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY
        YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
        MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
)
SELECT
    order_year,
    month_number,
    total_sales,
    SUM(total_sales) OVER (
        PARTITION BY order_year
        ORDER BY month_number
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY order_year, month_number;

-- Note: These queries assume Order Date is stored as text in DD-MM-YYYY format.