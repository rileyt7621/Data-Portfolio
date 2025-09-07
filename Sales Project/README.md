# Sales Project
## Aim
This project aimed to demonstrate proficiency in SQL as well as building a dashboard with a focus on providing insights based on trends over time.  

## Data Source
The data for this project was obtained from the [Wide World Importers](https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-what-is?view=sql-server-ver17) (WWI) sample databases from Microsoft. WWI represents a fictional company which operates as a wholesale novelty goods importer and distributor. 

## Data Preparation
The SQL query written for this project can be seen in the file labelled Sales_Query.SQL. As the data was taken from the WWI example databases, minimal data preparation was needed before building the dashboard. To develop my SQL ability, all data transformations were performed in SQL rather than creating calculated measures or columns in Power BI. 

## Dashboard Overview
The dashboard consists of 3 pages. The first page provides an overall summary of WWI’s sales. Key metrics displayed on cards included net revenue, number of orders and units sold. Area charts display net revenue, number of orders and units sold over time. Bar charts display net revenue and units sold by stock group. These visuals can be manipulated by applying date filters (year, quarter and month slicers. 

Users can navigate to two other pages which explore product and customer sales in more depth. The first of these pages investigates product sales, identifying top ten best sellers and net revenue over time by stock group. This page also displays a bubble chart displaying net revenue against units sold across the product range. These visuals can be filtered by the date slicers, as well as a stock group slicer.

The third page shows net revenue by customer category as well as the top ten customers by net revenue. An area chart shows the net revenue over time by customer category and a scatter graph displays the top 50 customers by net revenue and their purchase patterns. 

## Business Applications
The sales summary page provides a way for users to quickly identify trends in net revenue over time. For example, net revenue per quarter has increased between January 2013 and 2016, showing revenue growth. However, this is marked by sharp upward slopes (possibly due to seasonal spikes) and areas of decline rather than a consistent level of growth. This may highlight cyclical behaviour which could inform future staffing and inventory planning. 

The scatter graphs on the other two pages provide deeper insight into product and customer sales. The scatter graph located on the product sales page allows users to identify products by net revenue and volume. Low volume but high value products like the air cushion machine can be designated as premium items and may benefit from targeted marketing. Items with low revenue but high volume may benefit from price reviews to increase net revenue further. Items with low volume and revenue may be seasonal products, and discussions should take place around when these items are stocked. 

The scatter graph on the customer sales page allows insights into how the top 50 customers spend. Customers with high average order values and net revenue may be ideal candidates for loyalty programs due to their tendency to spend big and often, whereas customers with low average order values and low revenue may not be worth investing time and money into developing the relationship. This graph can also be adapted to filter by different fields. The top 50 customers by net revenue were chosen to make the graph more legible, rather than including all 663 customers. 
