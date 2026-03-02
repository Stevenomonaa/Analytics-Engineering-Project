/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================

DROP TABLE IF EXISTS silver.customers;
CREATE TABLE silver.customers AS
SELECT DISTINCT
    customer_id,
    LPAD(customer_zip_code_prefix::TEXT, 5, '0') AS zip_prefix, ----Converts the number into text so formatting is possible and Ensures the ZIP prefix always has 5 digits by adding leading zeros when needed.
    LOWER(TRIM(customer_city)) AS city,
    UPPER(TRIM(customer_state))
FROM bronze.crm_customers
WHERE customer_id IS NOT NULL;

=========================================================
DROP TABLE IF EXISTS silver.orders;

CREATE TABLE silver.orders AS
SELECT
    -- Identifiers
    order_id,
    customer_id,
    
    -- Purchase Data (Separated)
    DATE(order_purchase_timestamp) AS purchase_date,
    TO_CHAR(order_purchase_timestamp, 'HH24:MI:SS') AS purchase_time,
    
    -- Approval Data (Separated)
    DATE(order_approved_at) AS approved_date,
    TO_CHAR(order_approved_at, 'HH24:MI:SS') AS approved_time
FROM bronze.crm_orders
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL;
====================================================
DROP TABLE IF EXISTS silver.order_items;

CREATE TABLE silver.order_items AS
SELECT
    order_id,
    product_id,
    seller_id,
    price,
    shipping_charges
FROM bronze.crm_order_items
WHERE price > 0
AND order_id IS NOT NULL
AND product_id IS NOT NULL;
=======================================================
DROP TABLE IF EXISTS silver.payments;

CREATE TABLE silver.payments AS
SELECT
    order_id,
    payment_sequential AS payment_sequence,
    LOWER(payment_type) AS payment_type,
    payment_installments AS installments,
    payment_value
FROM bronze.crm_payments
WHERE payment_value > 0
AND order_id IS NOT NULL;
===================================================
DROP TABLE IF EXISTS silver.products;

CREATE TABLE silver.products AS
SELECT
    product_id,
    product_category,
    weight_grams,
    length_cm,
    height_cm,
    width_cm
FROM (
    SELECT
        -- Remove unwanted spaces
        TRIM(product_id) AS product_id,
        TRIM(product_category_name) AS product_category,

        -- Clean weight
        CASE 
            WHEN product_weight_g <= 0 THEN NULL
            ELSE product_weight_g
        END AS weight_grams,

        -- Clean dimensions
        CASE 
            WHEN product_length_cm <= 0 THEN NULL
            ELSE product_length_cm
        END AS length_cm,

        CASE 
            WHEN product_height_cm <= 0 THEN NULL
            ELSE product_height_cm
        END AS height_cm,

        CASE 
            WHEN product_width_cm <= 0 THEN NULL
            ELSE product_width_cm
        END AS width_cm,

        -- Deduplicate by keeping most complete record
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(product_id)
            ORDER BY
                (
                    CASE WHEN product_weight_g > 0 THEN 1 ELSE 0 END +
                    CASE WHEN product_length_cm > 0 THEN 1 ELSE 0 END +
                    CASE WHEN product_height_cm > 0 THEN 1 ELSE 0 END +
                    CASE WHEN product_width_cm > 0 THEN 1 ELSE 0 END
                ) DESC
        ) AS rn

    FROM bronze.erp_products
) cleaned_products
WHERE rn = 1;
