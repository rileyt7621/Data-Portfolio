-- Create a view to consolidate inventory data for Power BI reporting
CREATE VIEW PBI_Inventory AS 

-- CTE: Get the most recent purchase order line per stock item
WITH LatestPOLine AS (
    SELECT 
        StockItemID, 
        ExpectedUnitPricePerOuter,
        ROW_NUMBER() OVER (
            PARTITION BY StockItemID 
            ORDER BY PurchaseOrderID DESC
        ) rn  -- Assigns row number to each PO line, most recent gets rn = 1
    FROM Purchasing.PurchaseOrderLines
)

-- CTE: Aggregate stock group names per item into a single string
, StockGroupsPerItem AS (
    SELECT 
        sisg.StockItemID,
        STRING_AGG(sg.StockGroupName, ', ') AS StockGroupNames  -- Combines multiple group names into one field
    FROM Warehouse.StockItemStockGroups sisg
    JOIN Warehouse.StockGroups sg 
        ON sisg.StockGroupID = sg.StockGroupID
    GROUP BY sisg.StockItemID
)

-- CTE: Summarize incoming stock pipeline for each item
, IncomingStockPipeline AS (
    SELECT 
        pol.StockItemID,
        SUM(pol.OrderedOuters) AS IncomingQuantity,  -- Total incoming units
        MAX(po.ExpectedDeliveryDate) AS LatestExpectedDelivery,  -- Most recent expected delivery date
        AVG(pol.ExpectedUnitPricePerOuter) AS AvgExpectedUnitPrice  -- Average expected price across open orders
    FROM Purchasing.PurchaseOrderLines pol
    JOIN Purchasing.PurchaseOrders po 
        ON pol.PurchaseOrderID = po.PurchaseOrderID
    WHERE po.IsOrderFinalized = 0  -- Only include open/unfinalized orders
    GROUP BY pol.StockItemID
)

-- Final SELECT: Combine all sources into a unified inventory view
SELECT 
    si.StockItemID,
    si.StockItemName,
    sgpi.StockGroupNames,  -- Aggregated stock group labels
    s.SupplierName,
    si.LeadTimeDays,
    sih.QuantityOnHand,
    sih.BinLocation,
    sih.LastCostPrice,
    pol.ExpectedUnitPricePerOuter,  -- Latest expected purchase price
    isp.IncomingQuantity,
    isp.LatestExpectedDelivery,
    isp.AvgExpectedUnitPrice,
    sih.ReorderLevel,
    sih.TargetStockLevel,

    -- Derived stock status based on thresholds
    CASE 
        WHEN sih.QuantityOnHand < sih.ReorderLevel THEN 'Reorder Needed'
        WHEN sih.QuantityOnHand < sih.TargetStockLevel THEN 'Stock Low'
        ELSE 'Sufficient'
    END AS StockStatus,

    -- Calculated inventory value based on current stock and cost price
    sih.QuantityOnHand * sih.LastCostPrice AS InventoryValue

FROM Warehouse.StockItems si
LEFT JOIN Warehouse.StockItemHoldings sih 
    ON si.StockItemID = sih.StockItemID
LEFT JOIN StockGroupsPerItem sgpi 
    ON si.StockItemID = sgpi.StockItemID
LEFT JOIN Purchasing.Suppliers s 
    ON si.SupplierID = s.SupplierID
LEFT JOIN LatestPOLine pol 
    ON si.StockItemID = pol.StockItemID AND pol.rn = 1  -- Only include most recent PO line
LEFT JOIN IncomingStockPipeline isp 
    ON si.StockItemID = isp.StockItemID

GO

-- Create a view to analyze supplier reliability and lead time performance
CREATE VIEW PBI_SupplierRelability AS 

-- Select key supplier and inventory fields for reporting
SELECT 
    Purchasing.Suppliers.SupplierName,         -- Supplier name for identification
    Purchasing.Suppliers.SupplierID,           -- Unique supplier ID
    Warehouse.StockItems.LeadTimeDays,         -- Expected lead time from the stock item metadata

    -- Calculate the average lead time based on actual purchase order data
    AVG(
        DATEDIFF(
            DAY, 
            Purchasing.PurchaseOrders.OrderDate, 
            Purchasing.PurchaseOrders.ExpectedDeliveryDate
        )
    ) AS AvgLeadTime  -- Average number of days between order placement and expected delivery

-- Join supplier data with purchase orders to access order dates and delivery expectations
FROM Purchasing.Suppliers
LEFT JOIN Purchasing.PurchaseOrders
    ON Purchasing.Suppliers.SupplierID = Purchasing.PurchaseOrders.SupplierID

-- Join supplier data with stock items to retrieve expected lead times
LEFT JOIN Warehouse.StockItems
    ON Purchasing.Suppliers.SupplierID = Warehouse.StockItems.SupplierID

-- Group by supplier and item-level lead time to calculate averages per supplier
GROUP BY 
    Purchasing.Suppliers.SupplierName,
    Purchasing.Suppliers.SupplierID,
    Warehouse.StockItems.LeadTimeDays
