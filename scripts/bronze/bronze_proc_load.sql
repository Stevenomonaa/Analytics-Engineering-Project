/*
===================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================================

Script Purpose:
    This stored procedure loads raw data into the Bronze schema
    from external CSV files (file-based ingestion).

    It Performs the following actions:
    - Truncates the bronze tables before loading data.
    - Use the Postgres COPY command to load data from the CSV files.
    - Measures load time per table.
    - Measures total batch execution time.
-----------------------------------------------------------------------------------
Parameters:
-----------------------------------------------------------------------------------
    None.
    This stored procedure does not accept any parameters or return any values.
-----------------------------------------------------------------------------------
How to Execute:
-----------------------------------------------------------------------------------
    CALL bronze.load_bronze();

===================================================================================

*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    rows_count        BIGINT;
    start_time        TIMESTAMP;
    end_time          TIMESTAMP;
    interval_diff     INTERVAL;
    hours             INT;
    minutes           INT;
    seconds           INT;
    milliseconds      INT;
    batch_start_time  TIMESTAMP;
    batch_end_time    TIMESTAMP;
BEGIN
    RAISE NOTICE '==================================================';
    RAISE NOTICE 'LOADING BRONZE LAYER';
    RAISE NOTICE '==================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Starting bronze.load_bronze procedure';
    RAISE NOTICE '';

    batch_start_time := NOW();

    ---------------------------------------------------
    -- CRM Tables
    ---------------------------------------------------
    RAISE NOTICE '---------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '---------------------------------------------------';
    RAISE NOTICE '';

    ---------------------------------------------------
    -- crm_customers
    ---------------------------------------------------
    
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.crm_customers';
        TRUNCATE bronze.crm_customers;

        COPY bronze.crm_customers
        FROM 'C:\sql\dae_project\datasets\source_crm\df_Customers.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

        SELECT COUNT(*) INTO rows_count FROM bronze.crm_customers;
        RAISE NOTICE 'crm_customers: % rows loaded', rows_count;

        end_time := NOW();
        interval_diff := end_time - start_time;
        hours := EXTRACT(HOUR FROM interval_diff)::INT;
        minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
        seconds := EXTRACT(SECOND FROM interval_diff)::INT;
        milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;
        RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
        RAISE NOTICE '';
    

    ---------------------------------------------------
    -- crm_order_items
    ---------------------------------------------------
    
        start_time := NOW();
        TRUNCATE bronze.crm_order_items;
        RAISE NOTICE '>> Loading bronze.crm_order_items';

        COPY bronze.crm_order_items
        FROM 'C:\sql\dae_project\datasets\source_crm\df_OrderItems.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

        SELECT COUNT(*) INTO rows_count FROM bronze.crm_order_items;
        RAISE NOTICE 'crm_order_items: % rows loaded', rows_count;

        end_time := NOW();
        interval_diff := end_time - start_time;
        hours := EXTRACT(HOUR FROM interval_diff)::INT;
        minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
        seconds := EXTRACT(SECOND FROM interval_diff)::INT;
        milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;
        RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
        RAISE NOTICE '';
    

    ---------------------------------------------------
    -- crm_orders
    ---------------------------------------------------
    
        start_time := NOW();
        TRUNCATE bronze.crm_orders;
        RAISE NOTICE '>> Loading bronze.crm_orders';

        COPY bronze.crm_orders
        FROM 'C:\sql\dae_project\datasets\source_crm\df_Orders.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

        SELECT COUNT(*) INTO rows_count FROM bronze.crm_orders;
        RAISE NOTICE 'crm_orders: % rows loaded', rows_count;

        end_time := NOW();
        interval_diff := end_time - start_time;
        hours := EXTRACT(HOUR FROM interval_diff)::INT;
        minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
        seconds := EXTRACT(SECOND FROM interval_diff)::INT;
        milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;
        RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
        RAISE NOTICE '';
   

    ---------------------------------------------------
    -- crm_payments
    ---------------------------------------------------
    
        start_time := NOW();
        TRUNCATE bronze.crm_payments;
        RAISE NOTICE '>> Loading bronze.crm_payments';

        COPY bronze.crm_payments
        FROM 'C:\sql\dae_project\datasets\source_crm\df_Payments.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

        SELECT COUNT(*) INTO rows_count FROM bronze.crm_payments;
        RAISE NOTICE 'crm_payments: % rows loaded', rows_count;

        end_time := NOW();
        interval_diff := end_time - start_time;
        hours := EXTRACT(HOUR FROM interval_diff)::INT;
        minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
        seconds := EXTRACT(SECOND FROM interval_diff)::INT;
        milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;
        RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
        RAISE NOTICE '';
    

    ---------------------------------------------------
    -- ERP Tables
    ---------------------------------------------------
    RAISE NOTICE '---------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '---------------------------------------------------';
    RAISE NOTICE '';

    ---------------------------------------------------
    -- erp_products
    ---------------------------------------------------
    
        start_time := NOW();
        TRUNCATE bronze.erp_products;
        RAISE NOTICE '>> Loading bronze.erp_products';

        COPY bronze.erp_products
        FROM 'C:\sql\dae_project\datasets\source_erp\df_Products.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

        SELECT COUNT(*) INTO rows_count FROM bronze.erp_products;
        RAISE NOTICE 'erp_products: % rows loaded', rows_count;

        end_time := NOW();
        interval_diff := end_time - start_time;
        hours := EXTRACT(HOUR FROM interval_diff)::INT;
        minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
        seconds := EXTRACT(SECOND FROM interval_diff)::INT;
        milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;
        RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
        RAISE NOTICE '';
    

    ---------------------------------------------------
    -- Bronze batch complete
    ---------------------------------------------------
    batch_end_time := NOW();
    interval_diff := batch_end_time - batch_start_time;
    hours := EXTRACT(HOUR FROM interval_diff)::INT;
    minutes := EXTRACT(MINUTE FROM interval_diff)::INT;
    seconds := EXTRACT(SECOND FROM interval_diff)::INT;
    milliseconds := ROUND(EXTRACT(MILLISECOND FROM interval_diff))::INT;

    RAISE NOTICE '===================================================';
    RAISE NOTICE 'Bronze Layer Loading Completed in % hours, % minutes, % seconds, % milliseconds',
                 hours, minutes, seconds, milliseconds;
    RAISE NOTICE '===================================================';

END;
$BODY$;
