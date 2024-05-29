{{ config(materialized='view') }}
SELECT
    account_id_hashed,
    FORMAT_TIMESTAMP('%Y-%m-01', date) AS month,
    SUM(transactions_num) AS transaction_count
FROM
    {{ref('account_transactions')}}
GROUP BY
    account_id_hashed,
    FORMAT_TIMESTAMP('%Y-%m-01', date)