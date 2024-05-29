{{ config(materialized='view') }}
SELECT
    date,
    SUM(transactions_num) AS total_transaction_count
FROM
    {{ref('account_transactions')}}
GROUP BY
    date
