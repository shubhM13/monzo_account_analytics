{{ config(materialized='view') }}
SELECT DISTINCT
    u.user_id_hashed as UserID,
    a.AccountID as AccountID,
FROM
    {{ref('dim_users')}} u
INNER JOIN
    {{ref('dim_active_accounts')}} a 
ON u.account_id_hashed = a.AccountID
order by UserID