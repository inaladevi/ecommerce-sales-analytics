# E-Commerce Sales & Customer Analytics

SQL analysis of a UK-based online retailer's transaction data from 2010–2011 using PostgreSQL.

## Dataset

- **Source:** [UCI Machine Learning Repository via Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)
- **Records:** 541,909 transactions
- **Countries:** 38
- **Time period:** 2010–2011
- **Fields:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

## What's in this analysis

- **Revenue trends** — monthly revenue, order volume, unique customers, and average order value
- **Product performance** — top products by revenue, units sold, and order frequency
- **Customer behavior** — top customers by total spend, order frequency, average order value, and purchase history
- **Regional analysis** — revenue, order volume, and average order value by country
- **Window functions** — monthly country rankings using `RANK()` and revenue percentage share
- **Data quality** — analyzing returns, missing customer IDs, and high-volume invoices
- **Customer segmentation** — classifying customers into High, Medium, and Low Value segments using CTEs

## Key Findings

- Revenue grew from approximately **£823K in December 2010 to £1.5M in November 2011**
- The **UK accounts for the majority of revenue** across the analyzed period
- Approximately **24.9% of transactions have missing customer IDs**, limiting customer-level analysis
- Top customer **14646** spent over **£280K across 73 orders**

## SQL Techniques Demonstrated

- Aggregations: `SUM()`, `AVG()`, `COUNT()`, `COUNT(DISTINCT)`
- Date analysis: `DATE_TRUNC()`
- Common Table Expressions (CTEs)
- Window functions: `RANK()`, `SUM() OVER()`
- Conditional logic: `CASE`
- Data-quality checks
- Customer segmentation
- PostgreSQL-specific data loading with `\COPY`

## Setup

### 1. Download the dataset
Download `data.csv` from the [Kaggle dataset page](https://www.kaggle.com/datasets/carrie1/ecommerce-data) and place it in the root folder of this repository.

### 2. Create the table and load data

```sql
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
\(\i\) analysis.sql
```

## Tools
PostgreSQL 14