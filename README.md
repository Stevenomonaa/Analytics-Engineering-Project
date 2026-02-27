# Analytics-Engineering-Project

Built an end-to-end analytics pipeline using a Kaggle e-commerce dataset.
Raw transactional data was transformed through Bronze → Silver → Gold layers into a star schema supporting business analytics and exploratory analysis.

🎯 Objectives:

* Build analytics-ready data warehouse

* Apply Medallion Architecture

* Model star schema

* Reconcile revenue vs payments

* Perform business EDA

🧱 Architecture:

Layer	             Purpose
Bronze     →    Raw ingestion
Silver	  →   Cleaned business entities
Gold	     →    Analytics star schema
Analytics  →    Insights & EDA


🔄 Data Flow:

Source (Kaggle CSV)
   ↓
Bronze Tables
   ↓
Silver Clean Tables
   ↓
Gold Star Schema
   ↓
Analytics Views
   ↓
Business Insights

⭐ Key Features:

* Revenue reconciliation logic

* Payment allocation model

* Star schema warehouse

* Date dimension

* Analytical views

🛠 Tech Stack:

* SQL (PostgreSQL)

* Data Modeling

* Analytics Engineering Concepts

* Exploratory Data Analysis
