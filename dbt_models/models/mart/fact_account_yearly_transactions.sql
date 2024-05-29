{{ config(materialized='view') }}
SELECT
    account_id_hashed,
    EXTRACT(YEAR FROM date) AS year,
    SUM(transactions_num) AS transaction_count
FROM
    {{ref('account_transactions')}}
GROUP BY
    account_id_hashed,
    EXTRACT(YEAR FROM date)