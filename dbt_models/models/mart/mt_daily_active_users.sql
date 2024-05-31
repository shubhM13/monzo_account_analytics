{{ config(materialized='table') }}
WITH daily_active_users AS (
SELECT TransactionDate
, count(DISTINCT UserID) AS daily_transacting_users
FROM {{ref('fact_valid_user_transactions')}} t 
GROUP BY TransactionDate
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
    daily_active_users u ON d.date = u.TransactionDate)
select * from all_dates_daily_active_users
