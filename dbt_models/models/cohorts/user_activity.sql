{{ config(materialized='view') }}
SELECT
    u.user_id,
    u.signup_date,
    DATE(t.transaction_date) AS activity_date
FROM
    {{ref('user_activation')}} u
INNER JOIN
    {{ref('fact_valid_user_transactions')}} t
    ON u.user_id = t.user_id
    AND DATE(t.transaction_date) > u.signup_date