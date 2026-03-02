bronze DDL

CREATE SCHEMA bronze;

-- CRM Customers
DROP TABLE IF EXISTS bronze.crm_customers;
CREATE TABLE bronze.crm_customers (
    customer_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50)
);

-- CRM Orders
DROP TABLE IF EXISTS bronze.crm_orders;
CREATE TABLE bronze.crm_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP
);

-- CRM Order Items
DROP TABLE IF EXISTS bronze.crm_order_items;
CREATE TABLE bronze.crm_order_items (
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price NUMERIC,
    shipping_charges NUMERIC
);

-- CRM Payments
DROP TABLE IF EXISTS bronze.crm_payments;
CREATE TABLE bronze.crm_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC
);

--  ERP Products
DROP TABLE IF EXISTS bronze.erp_products;
CREATE TABLE bronze.erp_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);
