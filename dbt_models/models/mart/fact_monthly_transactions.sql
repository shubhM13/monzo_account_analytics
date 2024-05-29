{{ config(materialized='view') }}
SELECT
    FORMAT_TIMESTAMP('%Y-%m-01', date) AS month,
    SUM(transactions_num) AS total_transaction_count
FROM
    {{ref('account_transactions')}}
GROUP BY
    date
