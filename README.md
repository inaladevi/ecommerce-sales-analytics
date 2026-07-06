# E-Commerce Sales & Customer Analytics

SQL analysis of a UK-based online retailer's transaction data from 2010-2011.

## Dataset
- Source: [UCI Machine Learning Repository via Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)
- 541,909 transactions across 38 countries
- Fields: InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

## What's in this analysis

- **Revenue trends** — monthly revenue, order volume, and average order value over time
- **Top products** — best performing products by revenue and units sold
- **Customer behavior** — top customers by spend, order frequency, and purchase history
- **Regional analysis** — revenue breakdown by country
- **Window functions** — monthly country rankings using RANK() and revenue percentage share
- **Data validation** — detecting cancellations, missing customer IDs, and anomalous invoices
- **Customer segmentation** — classifying customers into High, Medium, and Low value segments using CTEs

## Key findings
- Revenue grew from £823k in Dec 2010 to £1.5M in Nov 2011
- UK accounts for the majority of revenue across all months
- 24.9% of transactions have missing customer IDs
- Top customer (ID 14646) spent over £280k across 73 orders

## Setup

```sql
-- create table
CREATE TABLE transactions (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(20),
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10,2),
    customer_id VARCHAR(20),
    country VARCHAR(100)
);

-- load data
\COPY transactions FROM 'data.csv' CSV HEADER ENCODING 'LATIN1';

-- run analysis
\i analysis.sql
```

## Tools
PostgreSQL 14