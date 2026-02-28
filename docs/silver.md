🥈 **Silver Layer**

Purpose:

Transform raw operational data into clean, standardized business tables suitable for analytics modeling.

Tables:

**silver.customers**

Grain:

One row per customer.

Purpose:

Represents unique customers with standardized geographic attributes.

Transformations:

* Trimmed whitespaces

* Standardized text casing

* Fixed Brazilian ZIP code formatting

Standardized casing prevents duplicate cities during aggregation.

ZIP codes padded to 5 digits to ensure consistent joins and geographic analysis.

Cleaning performed here prevents repeated transformations in downstream analytics.

**silver.orders**

Grain:

One row per order.

Purpose:

Represents validated customer orders.

Transformations:
* Trimmed whitespaces
* Split timestamps into date and time columns
(purchase_date

purchase_time

approved_date

approved_time)

Separating date and time improves analytical flexibility.

Enables creation of a reusable date dimension.

Simplifies time-based aggregations without repeated casting.

**silver.order_items**

Data Grain:

One row = one product within one order.

Purpose:

Transactional order line items (fact-level operational data).

Key Decisions:

* Duplicates in product_id preserved because multiple orders can contain the same product.

The table represents transactional grain; removing duplicates would destroy business meaning.

**silver.products**

Grain:

One row per product.

Purpose:

Product reference information.

Transformations:

* Removed invalid weight/dimension values

* Trimmed whitespaces in category names column

Physical dimensions required for logistics analysis.

Invalid dimensions would distort shipping analytics.

**silver.payments**

Grain:

One row per payment attempt.

Key Concepts:

payment_sequential tracks retry attempts

payment_installments represents customer repayment schedule to the bank

Purpose:

Payment attempts and payment structure per order.

Transformations:

* Standardized payment type

* Validated installment values

Payments exist at order level, not item level.

Later aggregation required for reconciliation.

During Silver validation:

* Unapproved orders detected

* Payment retries identified

* Non-reconcilable financial differences observed

These findings influenced Gold modeling decisions.

