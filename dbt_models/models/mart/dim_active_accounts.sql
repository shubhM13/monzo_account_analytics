{{ config(materialized='view') }}
SELECT
    AccountID,
    CreationDate,
    CurrentStatus,
    AccountType
FROM
    {{ref('dim_account')}}
WHERE
    CurrentStatus = 'Open' OR ReopeningDate IS NOT NULL