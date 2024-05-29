{{ config(materialized='view') }}
SELECT
    u.user_id,
    u.signup_date,
    DATE(t.TransactionDate) AS activity_date
FROM
    {{ref('user_first_action')}} u
INNER JOIN
    {{ref('fact_active_user_transactions')}} t
    ON u.user_id = t.UserID
    AND DATE(t.TransactionDate) > u.signup_date