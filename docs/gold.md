**Gold Layer — Analytics Modelling & Insights**

**Modeling Approach**

A Star Schema was implemented.

**Star Schema Overview**
**Fact Table**

gold.fact_sales

**Dimensions**

* gold.dim_customers

* gold.dim_products

* gold.dim_payments

* gold.dim_dates

  **gold.fact_sales**

Data Grain

One row represents; A product sold within an order.

**Modeling Challenge**

Payments were recorded per order, while sales analysis required item-level granularity.

**Solution**

Implemented proportional payment allocation.

Each item receives a share of order payment based on its contribution to total order value.

**Key Measures**

* product price

* shipping cost

* total item value

* item revenue (allocated payment)

**Design Tradeoff** 

Full financial reconciliation was intentionally scoped out.

The model prioritizes analytical usability
over accounting-grade financial reconstruction.

**gold.dim_dates**

**Created to support:**

* time intelligence

* weekday analysis

* monthly trends

* seasonality analysis

Centralizing date logic prevents repeated timestamp transformations across queries.

**Revenue vs Payment Reconciliation Analysis**

**Objective**

* Validate alignment between sales value and collected payments.

* Investigation Steps

* Compared item sales totals vs payments

* Checked duplicate inflation

* Reviewed installment behavior

* Investigated unapproved orders

* Tested rounding impacts

**Findings**

**Structural Differences Identified**

* Payments exist at order level.

* Sales modeled at item level.

* Installments represent customer-bank repayment, not merchant payments.

* Some orders were never approved.

**Conclusion**

Perfect reconciliation was not achievable due to structural differences between transactional sales data and financial payment records.

**BUSINESS VALUE**

The final analytics model enables:

**Revenue Analytics**

* Daily & monthly revenue trends

* Product profitability

**Customer Analytics**

* Purchase frequency

* Customer value estimation

**Payment Insights**

* Installment usage behavior

* Payment method trends

**Operational Insights**

* Geographic performance

* Shipping cost impact

**Exploratory Data Analysis (EDA)**

EDA focused on extracting actionable insights rather than descriptive statistics.

Examples:

* revenue by weekday

* top performing products

* customer purchasing distribution

* installment adoption patterns

**Advanced EDA**

Advanced analysis included:

* revenue seasonality detection

* customer repeat behavior

* payment behavior segmentation

* shipping vs revenue relationship analysis

**Key Analytics Engineering Learnings**

This project demonstrates:

* layered data architecture

* data grain management

* star schema modeling

* analytical tradeoff decisions

* real-world data quality investigation

Gold models were initially implemented as views to enable rapid iteration and validation. After confirming metric accuracy, the central fact table was materialized as a table to simulate production warehouse optimization while dimensions remained logical views.
  
