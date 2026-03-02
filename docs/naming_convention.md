Column names were standardized in the Silver layer by removing source system prefixes, converting names to snake_case, and improving semantic clarity. The Gold layer further renamed fields to align with business terminology.

| Bronze                   | Silver        | Reason               |
| ------------------------ | -----------   | -------------------- |
| customer_city            | city          | remove source prefix |
| order_purchase_timestamp | purchase_date | readability          |

| Silver           | Gold              | Business Meaning         |
| ---------------- | ----------------- | ------------------------ |
| price            | product_price     | clarify metric           |
| shipping_charges | shipping_cost     | business language        |
| item_revenue     | collected_revenue | financial interpretation |

Remaining columns follow the same naming convention principles.

