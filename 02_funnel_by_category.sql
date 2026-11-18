-- 1. Sample session-level binary flags (Black Friday week: Nov 24 - Nov 30, 2019)
WITH session_summary AS (
    SELECT 
        user_session,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS had_view,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
    FROM staging_events
    WHERE event_time >= '2019-11-24 00:00:00+00' 
      AND event_time < '2019-12-01 00:00:00+00'
      AND user_session IS NOT NULL
    GROUP BY user_session
)
SELECT * 
FROM session_summary
LIMIT 20;

-- 2. Overall store conversion funnel metrics (session-level)
WITH session_summary AS (
    SELECT 
        user_session,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS had_view,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
    FROM staging_events
    WHERE event_time >= '2019-11-24 00:00:00+00' 
      AND event_time < '2019-12-01 00:00:00+00'
      AND user_session IS NOT NULL
    GROUP BY user_session
)
SELECT 
    COUNT(*) AS total_sessions,
    SUM(had_view) AS sessions_with_view,
    SUM(had_cart) AS sessions_with_cart,
    SUM(had_purchase) AS sessions_with_purchase,
    ROUND(SUM(had_cart)::numeric / NULLIF(SUM(had_view), 0) * 100, 2) AS view_to_cart_pct,
    ROUND(SUM(had_purchase)::numeric / NULLIF(SUM(had_cart), 0) * 100, 2) AS cart_to_purchase_pct,
    ROUND(SUM(had_purchase)::numeric / NULLIF(SUM(had_view), 0) * 100, 2) AS overall_conversion_pct
FROM session_summary;

-- 3. Data quality audit: direct purchases without cart event (linearity check)
WITH session_summary AS (
    SELECT 
        user_session,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
    FROM staging_events
    WHERE event_time >= '2019-11-24 00:00:00+00' 
      AND event_time < '2019-12-01 00:00:00+00'
      AND user_session IS NOT NULL
    GROUP BY user_session
)
SELECT 
    COUNT(*) FILTER (WHERE had_purchase = 1 AND had_cart = 0) AS purchases_without_cart,
    COUNT(*) FILTER (WHERE had_purchase = 1 AND had_cart = 1) AS purchases_with_cart
FROM session_summary;

-- 4. Funnel breakdown by top-level product category
WITH session_category_summary AS (
    SELECT 
        user_session,
        split_part(category_code, '.', 1) AS main_category,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS had_view,
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS had_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS had_purchase
    FROM staging_events
    WHERE event_time >= '2019-11-24 00:00:00+00' 
      AND event_time < '2019-12-01 00:00:00+00'
      AND user_session IS NOT NULL
      AND category_code IS NOT NULL
    GROUP BY user_session, split_part(category_code, '.', 1)
)
SELECT 
    main_category,
    COUNT(*) AS total_sessions,
    SUM(had_view) AS sessions_with_view,
    SUM(had_cart) AS sessions_with_cart,
    SUM(had_purchase) AS sessions_with_purchase,
    ROUND(SUM(had_cart)::numeric / NULLIF(SUM(had_view), 0) * 100, 2) AS view_to_cart_pct,
    ROUND(SUM(had_purchase)::numeric / NULLIF(SUM(had_cart), 0) * 100, 2) AS cart_to_purchase_pct,
    ROUND(SUM(had_purchase)::numeric / NULLIF(SUM(had_view), 0) * 100, 2) AS overall_conversion_pct
FROM session_category_summary
GROUP BY main_category
ORDER BY total_sessions DESC;