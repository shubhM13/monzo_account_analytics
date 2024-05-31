{{ config(materialized='table') }}
WITH daily_active_users AS (
SELECT transaction_date
, count(DISTINCT user_id) AS daily_transacting_users
FROM {{ref('fact_valid_user_transactions')}} t 
GROUP BY transaction_date
),
all_dates_daily_active_users AS (
    SELECT d.date
    , d.day
    ,d.month 
    ,d.year 
    ,d.week
    ,u.daily_transacting_users
    FROM {{ref('dim_date')}} d
    LEFT JOIN 
    daily_active_users u ON d.date = u.transaction_date)
select * from all_dates_daily_active_users
