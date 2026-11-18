# E-Commerce Black Friday Funnel Diagnostic

<img width="3075" height="1763" alt="dashboard_overview_page-0001" src="https://github.com/user-attachments/assets/1751c9c1-9061-4ed2-9639-33ce509a84c5" />



Deep analysis and diagnostic of a multi category e-commerce comparing how the funnel performed during the Black Friday peak vs regular week days, across 67M+ clickstream events using PostgreSQL and Power BI.

Walkthrough Video (loom link)


## Business Insights
- The critical loss isn't at checkout (which shows a 48.38% cart-to-purchase conversion rate for the week), but rather at the top of the funnel—with only 11.54% of sessions resulting in a "view cart" action.
- The "electronics" category ($40.55M in revenue; 9.95% add-to-cart rate) is driving the store’s performance, while "apparel" (2.67%) and "furniture" (3.05%) face significant friction on product pages.
- Before reallocating media spend away from categories with low initial conversion, conduct an audit of price competitiveness, shipping terms, and the consistency between advertisements and their corresponding landing pages.

Full Article on Substack (substack link)

## Dataset & ELT Architecture
- Data source: [Public dataset](https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store/data)  (eCommerce behavior data from multi category store, by Michael Kechinov)
- Medallion Pipeline: PostgreSQL aggregation condensed 67,5M events into 16.273 rows on mart_black_friday_funnel table, daily granularity by main category, sub category and brand.
- Star Schema: 1:* relation between Dim_Calendar table and mart_black_friday_funnel table.




## Data Quality & Methodology Notes
- Audit on purchases_without_cart proved that it represents only 1,52% (2.328 sessions) of the the total sessions. It validades the funnel's consistency.
- The overall conversion rate on SQL is 5,58% and on Power BI it's 3,83% because the table mart_black_friday_funnel unveils sessions by brand and subcategory diluting the denominator when a user navigates between multiple brands within the same session.



## Getting Started
- Requirements: PostgreSQL 14+ (PgAdmin) and Power BI Desktop
    
  - 1 - Download raw [CSV file](https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store/data) and load on staging_events table;
  
  - 2 - Run script 01_eda_and_data_audit.sql;

  - 3 - Run script 02_funnel_by_category.sql;

  - 4 - Run script 03_create_gold_mart.sql;

  - 5 - Open .pbix file, point to the localhost database and refresh the data.



## How to explore
```
├── README.md
├── sql/
│   ├── 01_eda_and_data_audit.sql
│   ├── 02_funnel_by_category.sql
│   ├── 03_create_gold_mart.sql
├── powerbi/
│   └── black_friday_funnel _diagnostic.pbix
└── assets/
    └── dashboard_overview.pdf
```

## Author
Mateus Franz


[LinkedIn](https://www.linkedin.com/in/mateusfranz/) · [Substack](https://substack.com/@mateusfranz) · [E-mail](contactme.attendee261@slmail.me)

## License
MIT License
