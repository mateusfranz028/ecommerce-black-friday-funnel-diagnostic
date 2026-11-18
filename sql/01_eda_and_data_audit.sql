-- 1. Create raw staging table for 67.5M clickstream events
CREATE TABLE staging_events (
    event_time TIMESTAMPTZ,
    event_type VARCHAR(50),
    product_id BIGINT,
    category_id BIGINT,
    category_code VARCHAR(255),
    brand VARCHAR(100),
    price NUMERIC(10,2),
    user_id BIGINT,
    user_session UUID
);

-- 2. Bulk load raw CSV into PostgreSQL (update local path before running)
COPY staging_events
FROM 'C:\Users\Public\Documents\2019-Nov.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- 3. Initial audit: event volume distribution across funnel stages
SELECT 
    event_type,
    COUNT(*) AS total_events
FROM staging_events
GROUP BY event_type
ORDER BY total_events DESC;
