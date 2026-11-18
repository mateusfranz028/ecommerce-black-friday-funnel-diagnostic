# ecommerce-black-friday-funnel-diagnostic
Deep analysis and diagnostic of an e-commerce comparing how the funnel performed during the Black Friday peak vs regular week days, across 67M+ clickstream events using PostgreSQL and Power BI.



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
