# ecommerce-black-friday-funnel-diagnostic
Deep analysis and diagnostic of an e-commerce comparing how the funnel performed during the Black Friday peak vs regular week days, across 67M+ clickstream events using PostgreSQL and Power BI.










## Dataset & ELT Architecture
- Data source: Public dataset (eCommerce behavior data from multi category store, by Michael Kechinov)
- Medallion Pipeline: PostgreSQL aggregation condensed 67,5M events into 16.273 rows on mart_black_friday_funnel table, daily granularity by main category, sub category and brand.
- Star Schema: 1:* relation between Dim_Calendar table and mart_black_friday_funnel table.




## Data Quality & Methodology Notes
- Audit on purchases_without_cart proved that it represents only 1,52% (2.328 sessions) of the the total sessions. It validades the funnel's consistency.
- The overall conversion rate on SQL is 5,58% and on Power BI it's 3,83% because the table mart_black_friday_funnel unveils sessions by brand and subcategory diluting the denominator when a user navigates between multiple brands within the same session.



## Getting Started
- Requirements: PostgreSQL 14+ (PgAdmin) and Power BI Desktop
- Step by step:
1 - Download raw CSV file and load on staging_events table.
2 - Run script 01_eda_and_data_audit.sql.
3 - Run script 02_funnel_by_category.sql.
4 - Run script 03_create_gold_mart.sql.
5 - Open .pbix file, point to the localhost database and refresh the data.



## How to explore
├── README.md
├── sql/
│   ├── 01_eda_and_data_audit.sql
│   ├── 02_funnel_by_category.sql
│   ├── 03_create_gold_mart.sql
├── powerbi/
│   └── black_friday_funnel _diagnostic.pbix
└── assets/
    └── dashboard_overview.pdf

## Author
Mateus Franz * LinkedIn * Substack * E-mail

## License
MIT License
