/*
===============================================================================
DDL Script: Create Gold Views (PostgreSQL)
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


--Customer Dimension--
--Business identity table.
DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT
    customer_id,
    city AS customer_city,
    customer_state,
    zip_prefix AS customer_zip_prefix
FROM silver.customers;
=================================================

--Product Dimension--
--Product descriptive attributes

DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    product_id,
    product_category,
    weight_grams AS product_weight_grams,
    length_cm AS product_lenght_cm,
    height_cm AS product_height_cm,
    width_cm AS product_width_cm
FROM silver.products;

=============================================

--Payment Dimension--
--Payments may appear multiple times per order.
--We aggregate first to prevent revenue duplication.
DROP VIEW IF EXISTS gold.dim_payments;

CREATE VIEW gold.dim_payments AS
SELECT
    order_id,
    SUM(payment_value) AS total_payment_value,
    COUNT(*) AS payment_count,
    MAX(installments) AS installments
FROM silver.payments
GROUP BY order_id;
==================================================


--Date Dimension-
DROP VIEW IF EXISTS gold.dim_dates;

CREATE VIEW gold.dim_dates AS
SELECT DISTINCT
    TO_CHAR(purchase_date,'YYYYMMDD')::INT AS date_key,
    purchase_date AS full_date,

    EXTRACT(YEAR FROM purchase_date) AS year,
    EXTRACT(MONTH FROM purchase_date) AS month,
    EXTRACT(DAY FROM purchase_date) AS day,

    TRIM(TO_CHAR(purchase_date,'Month')) AS month_name,
    TRIM(TO_CHAR(purchase_date,'Day')) AS weekday_name,
    EXTRACT(DOW FROM purchase_date) AS day_of_week,

    CASE
        WHEN EXTRACT(DOW FROM purchase_date) IN (0,6)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type

FROM silver.orders
WHERE purchase_date IS NOT NULL;
=======================================================

--Facts Table Purpose--
--dashboards
--BI tools
--aggregations
--fast queries


DROP TABLE IF EXISTS gold.fact_sales;

CREATE TABLE gold.fact_sales AS

WITH order_totals AS (
    SELECT
        oi.order_id,
        SUM(oi.price + oi.shipping_charges) AS order_total_value,
        p.total_payment_value
    FROM silver.order_items oi
    JOIN silver.orders o
        ON oi.order_id = o.order_id
    LEFT JOIN gold.dim_payments p
        ON oi.order_id = p.order_id
    GROUP BY 
        oi.order_id,
        p.total_payment_value
)

SELECT
    -- =========================
    -- Keys
    -- =========================
    oi.order_id,
    o.customer_id,
    oi.product_id,

    -- Star schema date key
    TO_CHAR(o.purchase_date, 'YYYYMMDD')::INT AS date_key,

    -- =========================
    -- Order Lifecycle
    -- =========================
    o.purchase_date,
    o.approved_date,

    CASE
        WHEN o.approved_date IS NULL THEN 'UNAPPROVED'
        ELSE 'APPROVED'
    END AS order_status,

    -- =========================
    -- Measures (FACTS)
    -- =========================
    oi.price AS product_price,
    oi.shipping_charges AS shipping_cost,

    (oi.price + oi.shipping_charges) AS gross_sales,

    -- Proportional revenue allocation
    ROUND(
        ((oi.price + oi.shipping_charges)
        / ot.order_total_value)
        * ot.total_payment_value,
        2
    ) AS collected_revenue

FROM silver.order_items oi

JOIN silver.orders o
    ON oi.order_id = o.order_id

JOIN order_totals ot
    ON oi.order_id = ot.order_id;
