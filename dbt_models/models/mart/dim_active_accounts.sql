{{ config(materialized='view') }}
SELECT
    AccountID,
    creation_dt,
    CurrentStatus,
    AccountType
FROM
    {{ref('dim_account')}}
WHERE
    CurrentStatus = 'Open' OR reopening_dt IS NOT NULL