🥈 **Silver Layer**

Purpose:

Transform raw operational data into clean, standardized business tables suitable for analytics modeling.

Tables:

**silver.customers**

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

Purpose:

Represents validated customer orders.

Transformations:
* Trimmed whitespaces
* Split timestamps into date and time columns

Separating date and time improves analytical flexibility.

Enables creation of a reusable date dimension.

Simplifies time-based aggregations without repeated casting.

**silver.order_items**

Purpose:

Transactional order line items (fact-level operational data).

Key Decisions:

* Duplicates preserved because multiple orders can contain the same product.

The table represents transactional grain; removing duplicates would destroy business meaning.

**silver.products**

Purpose:

Product reference information.

Transformations:

* Removed invalid weight/dimension values

* Trimmed whitespaces in category names column

Physical dimensions required for logistics analysis.

Invalid dimensions would distort shipping analytics.

**silver.payments**

Purpose:

Payment attempts and payment structure per order.

Transformations:

* Standardized payment type

* Validated installment values

Payments exist at order level, not item level.

Later aggregation required for reconciliation.

