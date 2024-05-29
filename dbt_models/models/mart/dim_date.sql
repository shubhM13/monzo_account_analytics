{{ config(materialized='view') }}

WITH source_data AS (
    SELECT 
        DISTINCT date AS raw_date
    FROM {{ref('account_transactions')}}
    UNION DISTINCT
    SELECT DATE(created_ts) AS raw_date FROM {{ref('account_created')}}
    UNION DISTINCT
    SELECT DATE(closed_ts) AS raw_date FROM {{ref('account_closed')}}
    UNION DISTINCT
    SELECT DATE(reopened_ts) AS raw_date FROM {{ref('account_reopened')}}
)

SELECT
    FORMAT_DATE('%Y%m%d', raw_date) AS DateKey,
    raw_date AS Date,
    EXTRACT(YEAR FROM raw_date) AS Year,
    EXTRACT(MONTH FROM raw_date) AS Month,
    EXTRACT(DAY FROM raw_date) AS Day,
    EXTRACT(QUARTER FROM raw_date) AS Quarter,
    EXTRACT(WEEK FROM raw_date) AS WeekOfYear,
    EXTRACT(DAYOFWEEK FROM raw_date) AS DayOfWeek
FROM source_data
