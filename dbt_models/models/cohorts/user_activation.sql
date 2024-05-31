{{ config(materialized='view') }}
SELECT
    user_id as user_id,
    MIN(transaction_date) AS signup_date
FROM
    {{ref('fact_valid_user_transactions')}}
GROUP BY
    user_id