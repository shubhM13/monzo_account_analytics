{{ config(materialized='table') }}
WITH daily_active_users AS (
    SELECT
        UserID as user_id,
        TransactionDate AS activity_date
    FROM
        {{ref('fact_active_user_transactions')}}
    GROUP BY
        UserID,
        TransactionDate
),
distinct_daily_counts AS (
    SELECT
        activity_date,
        COUNT(DISTINCT user_id) AS daily_active_users
    FROM
        daily_active_users
    GROUP BY
        activity_date
)
SELECT
    a.activity_date AS date,
    SUM(b.daily_active_users) AS active_users_count
FROM
    distinct_daily_counts a
JOIN
    distinct_daily_counts b
    ON b.activity_date BETWEEN DATE_SUB(a.activity_date, INTERVAL 6 DAY) AND a.activity_date
GROUP BY
    a.activity_date
ORDER BY
    a.activity_date