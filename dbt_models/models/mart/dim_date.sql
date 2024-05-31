{{ config(materialized='table') }}

WITH source_data AS (
    SELECT DISTINCT DATE(date) AS raw_date FROM {{ ref('account_transactions') }}
    UNION DISTINCT
    SELECT DATE(created_ts) AS raw_date FROM {{ ref('account_created') }}
    UNION DISTINCT
    SELECT DATE(closed_ts) AS raw_date FROM {{ ref('account_closed') }}
    UNION DISTINCT
    SELECT DATE(reopened_ts) AS raw_date FROM {{ ref('account_reopened') }}
),
date_bounds AS (
    SELECT 
        MIN(raw_date) AS start_date, 
        MAX(raw_date) AS end_date 
    FROM 
        source_data
),
date_series AS (
    SELECT
        date
    FROM
        UNNEST(GENERATE_DATE_ARRAY((SELECT start_date FROM date_bounds), (SELECT end_date FROM date_bounds))) AS date
)
SELECT
    date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(QUARTER FROM date) AS quarter,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(WEEK FROM date) AS week,
    EXTRACT(DAY FROM date) AS day,
    EXTRACT(DAYOFWEEK FROM date) AS day_of_week,
    EXTRACT(DAYOFYEAR FROM date) AS day_of_year,
    EXTRACT(ISOWEEK FROM date) AS iso_week,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS weekday_weekend,
    CASE
        WHEN EXTRACT(MONTH FROM date) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date) = 12 THEN 'December'
    END AS month_name,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM date) = 1 THEN 'Sunday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 2 THEN 'Monday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 3 THEN 'Tuesday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 4 THEN 'Wednesday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 5 THEN 'Thursday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 6 THEN 'Friday'
        WHEN EXTRACT(DAYOFWEEK FROM date) = 7 THEN 'Saturday'
    END AS day_name,
    IF(DATE_DIFF(date, CAST(CONCAT(EXTRACT(YEAR FROM date), '-01-01') AS DATE), DAY) + 1 <= 7, 'First Week', 'Not First Week') AS first_week_of_year
FROM
    date_series
