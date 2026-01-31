-- Chapter 07 - DATA ANALYSIS AND REPORTING

-- Switch to appropriate database
USE ecommerce_db;

-- 1. Total sales
-- This query calculates the total revenue generated from all orders in the database

SELECT SUM(TotalAmount) AS TotalSales FROM Orders;

-- 2. Sales by Month
-- This query caluculates teh total sales for the particular month
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(TotalAmount) AS MonthlySales FROM Orders GROUP BY Month ORDER BY Month 
DESC;


-- ANALYZING CUSTOMER BEHAVIOUR

-- 1. Top Customers
-- This query identifies the top 5 customers who have spent the most
desc orders;
SELECT UserID, SUM(TotalAmount) AS TotalSales FROM Orders GROUP BY UserID ORDER BY TotalSales DESC LIMIT 5;


-- 2. Customer Lifetime Value (CLTV)
-- This query calculates the customer Lifetime Value (CLTV) for each customer,
-- Which is the total amount a customer has spent on the platform

SELECT UserID, SUM(TotalAmount) AS LifeTimeValue FROM Orders GROUP BY UserID  ORDER BY UserID DESC;