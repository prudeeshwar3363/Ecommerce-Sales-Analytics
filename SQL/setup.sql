-- Project: E-commerce Sales & Profitability Analytics
-- Database setup and data validation

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;

-- Check the number of imported records
SELECT COUNT(*) AS total_rows
FROM superstore;

-- Preview the first five records
SELECT *
FROM superstore
LIMIT 5;