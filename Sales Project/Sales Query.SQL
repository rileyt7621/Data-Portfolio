-- Drop and recreate view: PBI_Monthly_Customer_Revenue
-- Purpose: Monthly revenue per customer for Power BI
IF OBJECT_ID (N'DBO.PBI_Monthly_Customer_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Customer_Revenue
END
GO

CREATE VIEW PBI_Monthly_Customer_Revenue AS
SELECT 
    YEAR(I.InvoiceDate) AS InvoiceYear,         -- Extract year from invoice date
    MONTH(I.InvoiceDate) AS InvoiceMonth,       -- Extract month from invoice date
    I.InvoiceDate,                              -- Full invoice date for reference
    C.CustomerID,                               -- Customer identifier
    C.CustomerCategoryID,                       -- Customer segment/category
    SUM(IL.Quantity * IL.UnitPrice) AS NetRevenue, -- Total revenue per customer per month
    COUNT(DISTINCT IL.InvoiceID) AS NumOrders      -- Number of unique orders
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C ON I.CustomerID = C.CustomerID
GROUP BY 
    YEAR(I.InvoiceDate), 
    MONTH(I.InvoiceDate), 
    C.CustomerID, 
    C.CustomerCategoryID, 
    I.InvoiceDate
GO

-- Drop and recreate view: PBI_Customer_Revenue
-- Purpose: Lifetime revenue per customer with ranking
IF OBJECT_ID (N'DBO.PBI_Customer_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Customer_Revenue
END
GO

CREATE VIEW PBI_Customer_Revenue AS
SELECT 
    C.CustomerID,
    C.CustomerCategoryID,
    SUM(IL.Quantity * IL.UnitPrice) AS NetRevenue, -- Total revenue
    COUNT(DISTINCT IL.InvoiceID) AS NumOrders,     -- Total orders
    ROUND(SUM(IL.Quantity * IL.UnitPrice) / COUNT(DISTINCT IL.InvoiceID), 2) AS AvgOrderValue, -- Revenue per order
    DENSE_RANK() OVER (ORDER BY SUM(IL.Quantity * IL.UnitPrice) DESC) AS CustomerRank -- Rank by revenue
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C ON I.CustomerID = C.CustomerID
GROUP BY 
    C.CustomerID, 
    C.CustomerCategoryID
GO

-- Drop and recreate view: PBI_Monthly_Revenue
-- Purpose: Monthly revenue across all customers
IF OBJECT_ID (N'DBO.PBI_Monthly_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Revenue
END
GO

CREATE VIEW PBI_Monthly_Revenue AS
SELECT 
    YEAR(I.InvoiceDate) AS InvoiceYear,
    MONTH(I.InvoiceDate) AS InvoiceMonth,
    I.InvoiceDate,
    SUM(IL.Quantity * IL.UnitPrice) AS NetRevenue, -- Total revenue
    SUM(IL.Quantity) AS UnitsSold,                 -- Total units sold
    COUNT(DISTINCT IL.InvoiceID) AS NumOrders,     -- Number of orders
    ROUND(SUM(IL.Quantity * IL.UnitPrice) / COUNT(DISTINCT IL.InvoiceID), 2) AS AvgOrderValue -- Average revenue per order
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C ON I.CustomerID = C.CustomerID
GROUP BY 
    YEAR(I.InvoiceDate), 
    MONTH(I.InvoiceDate), 
    I.InvoiceDate
GO

-- Drop and recreate view: PBI_Monthly_Product_Revenue
-- Purpose: Monthly revenue per product
IF OBJECT_ID (N'DBO.PBI_Monthly_Product_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Product_Revenue
END
GO

CREATE VIEW PBI_Monthly_Product_Revenue AS
SELECT 
    YEAR(I.InvoiceDate) AS InvoiceYear,
    MONTH(I.InvoiceDate) AS InvoiceMonth,
    I.InvoiceDate,
    IL.StockItemID,
    SUM(IL.Quantity * IL.UnitPrice) AS NetRevenue, -- Revenue per product
    SUM(IL.Quantity) AS UnitsSold                  -- Units sold per product
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C ON I.CustomerID = C.CustomerID
GROUP BY 
    YEAR(I.InvoiceDate), 
    MONTH(I.InvoiceDate), 
    IL.StockItemID, 
    I.InvoiceDate
GO

-- Drop and recreate view: PBI_Product_Revenue
-- Purpose: Lifetime revenue per product with ranking
IF OBJECT_ID (N'DBO.PBI_Product_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Product_Revenue
END
GO

CREATE VIEW PBI_Product_Revenue AS
SELECT 
    IL.StockItemID,
    SUM(IL.Quantity * IL.UnitPrice) AS NetRevenue, -- Total revenue per product
    SUM(IL.Quantity) AS UnitsSold,                 -- Total units sold
    ROUND(AVG(IL.UnitPrice), 2) AS AvgUnitPrice,   -- Average unit price
    DENSE_RANK() OVER (ORDER BY SUM(IL.Quantity * IL.UnitPrice) DESC) AS ProductRank -- Rank by revenue
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C ON I.CustomerID = C.CustomerID
GROUP BY 
    IL.StockItemID
GO
