# Sales_Analysis_SQL
# Sales Analysis SQL Project

## Overview
This project demonstrates **advanced sales and customer analysis** using SQL on a sample e-commerce dataset. The dataset contains four main tables:

- **customers** – customer details
- **orders** – order information with order dates
- **products** – product details including product type and price
- **product_orders** – mapping of products to orders with quantity and price

The goal of this project is to **clean the data, analyze revenue and sales trends, understand customer behavior, and segment products** using SQL.

---

## Data Cleaning
- Converted `order_date` from text format to proper `DATE` type.  
- Created a new column for cleaned dates and removed the old column.  
- Updated the primary key constraints for proper indexing.  

---

## Analyses Performed

### 1. Revenue Analysis
- Total revenue generated.
- Revenue per order.
- Revenue by year.
- Revenue by product type.

### 2. Customer Insights
- Top customers by revenue.
- Repeat customers (more than 1 order).
- Customer Lifetime Value (CLV).
- Ranking customers by revenue.

### 3. Product Insights
- Top 5 products by revenue.
- Low-performing products (below average revenue).
- Product performance segmentation (High, Medium, Low).

### 4. Time-Based Analysis
- Monthly sales trends.
- Best sales month.
- Cumulative revenue over time.
- Year-over-Year (YoY) growth.

### 5. Advanced SQL Techniques
- Used **window functions** like `RANK()` and `LAG()` for ranking and YoY growth analysis.
- Aggregation functions like `SUM()` and `COUNT()` for insights.
- Conditional statements (`CASE`) for product segmentation.
- Common Table Expressions (CTEs) for low-performing product analysis.

---

## Tools Used
- **SQL Server** (T-SQL)
- **SQL Queries** for data cleaning, transformation, and analysis.

---


## How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/vishnupriyabottu
Open the .sql files in SQL Server Management Studio (SSMS).

2.Execute the scripts step by step to:

3.Clean the data

4.Run revenue, customer, and product analyses

This project contains SQL queries for data cleaning, revenue analysis, customer analysis, product performance analysis, and time-based sales analysis using an e-commerce dataset.
