-- Materialize aggregated Gold table for Power BI ingestion (16,273 rows)
CREATE TABLE mart_black_friday_funnel AS
WITH session_daily_category AS (
    SELECT 
        DATE(event_time AT TIME ZONE 'UTC') AS event_date,
        user_session,
        split_part(category_code, '.', 1) AS main_category,
        COALESCE(NULLIF(split_part(category_code, '.', 2), ''), 'other') AS sub_category,
        COALESCE(brand, 'unbranded') AS brand,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS had_view,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase,
        SUM(CASE WHEN event_type = 'cart' THEN price ELSE 0 END) AS cart_value,
        SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END) AS purchase_revenue
    FROM staging_events
    WHERE event_time >= '2019-11-24 00:00:00+00' 
      AND event_time < '2019-12-01 00:00:00+00'
      AND user_session IS NOT NULL
      AND category_code IS NOT NULL
    GROUP BY 
        DATE(event_time AT TIME ZONE 'UTC'),
        user_session,
        split_part(category_code, '.', 1),
        COALESCE(NULLIF(split_part(category_code, '.', 2), ''), 'other'),
        COALESCE(brand, 'unbranded')
)
SELECT 
    event_date,
    main_category,
    sub_category,
    brand,
    COUNT(*) AS total_sessions,
    SUM(had_view) AS sessions_with_view,
    SUM(had_cart) AS sessions_with_cart,
    SUM(had_purchase) AS sessions_with_purchase,
    ROUND(SUM(cart_value), 2) AS total_cart_value,
    ROUND(SUM(purchase_revenue), 2) AS total_revenue
FROM session_daily_category
GROUP BY 
    event_date,
    main_category,
    sub_category,
    brand;

-- Verify final Gold layer row count
SELECT COUNT(*) AS gold_row_count FROM mart_black_friday_funnel;
