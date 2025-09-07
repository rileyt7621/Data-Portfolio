# Inventory Project
## Aim
The aim of this project was to demonstrate proficiency in SQL, by writing my own queries to obtain data from which a dashboard could then be built. The dashboard was based upon the idea of being a real-time summary of current inventory and related information such as incoming purchases. Whilst the dashboard will not update as the database the data is taken from is static, it provided a guide for how to approach building the dashboard. 

## Data Source
The data for this project was obtained from the [WideWorldImporters](https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-oltp-database-catalog?view=sql-server-ver17&source=recommendations) (WWI) sample databases from Microsoft. WWI represents a fictional company which operates as a wholesale novelty goods importer and distributor. 

## Data Preparation
The SQL query written for this project can be seen in the file labelled Inventory_Query.SQL. As the data was taken from the WWI example databases, minimal data preparation was needed before building the dashboard. However, as many items belonged in multiple stock groups it was important to separate the stock group names by a “,” delimiter to ensure the stock groups slicer was accurate. 

## Dashboard Overview
The dashboard consists of a single page, containing cards representing key metrics such as current inventory value, units in stock, number of SKU’s, the stock status of the overall product range and the number of incoming orders. The visuals displayed below these cards highlight top items by inventory value and quantity, as well as vendors by inventory value and quantity. There are also visuals related to inventory value and quantity by stock group. These visuals can all be filtered by a stock group slicer, as well as a custom text filter slicer. This allows users to search for specific items, improving interactivity within the dashboard. 

Users can also drill down on the incoming orders card, revealing a page dedicated to current incoming orders. This allows users to explore incoming orders in greater depth. Cards display the current number of incoming orders and units as well as the value of the incoming inventory. Graphs display the incoming units and inventory value by vendor and stock group. A table also highlights the incoming orders with conditional, colour-coded formatting. This allows users to identify low-stock products and whether they will still be understocked after delivery. 
	
## Business Applications
This dashboard was designed to provide a real-time summary of the WWI’s inventory. This allows insights into which items tie up the most capital. For example, the two items with the greatest inventory value (food related variety packs of USB drives) have over double the inventory value of the 3rd highest item. This could mean the USB food flash drive variety packs are overstocked and may need tighter stock controls. 

The dashboard could also provide insights into which suppliers are responsible for the greatest volume of stock, and which provide the most expensive stock. This could reveal whether WWI are overly dependent on certain vendors, as well as identify where to focus relationship management and possible contract renegotiation efforts. 
