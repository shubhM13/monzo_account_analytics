{{ config(materialized='view') }}
SELECT
    UserID as user_id,
    MIN(TransactionDate) AS signup_date
FROM
    {{ref('fact_active_user_transactions')}}
GROUP BY
    user_id