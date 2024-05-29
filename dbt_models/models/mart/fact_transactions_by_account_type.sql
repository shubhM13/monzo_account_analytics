{{ config(materialized='view') }}
SELECT
    a.account_type,
    t.date,
    SUM(t.transactions_num) AS transaction_count
FROM
    {{ref('account_transactions')}} t
JOIN
    {{ref('account_created')}} a ON t.account_id_hashed = a.account_id_hashed
GROUP BY
    a.account_type,
    t.date