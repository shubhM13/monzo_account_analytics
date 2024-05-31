

{{ config(materialized='view') }}

WITH account_events AS (
    SELECT 
        account_id_hashed, 
        DATE(created_ts) AS event_date, 
        1 AS event_type -- 1 for account creation
    FROM {{ ref('account_created') }}
    UNION ALL
    SELECT 
        account_id_hashed, 
        DATE(closed_ts) AS event_date, 
        -1 AS event_type -- -1 for account closure
    FROM {{ ref('account_closed') }}
    UNION ALL
    SELECT 
        account_id_hashed, 
        DATE(reopened_ts) AS event_date, 
        1 AS event_type -- 1 for account reopening
    FROM {{ ref('account_reopened') }}
),
date_sequence AS (
    SELECT 
        date
    FROM {{ ref('dim_date') }}
    WHERE date BETWEEN (SELECT MIN(event_date) FROM account_events) 
                     AND (SELECT MAX(event_date) FROM account_events)
),
account_status AS (
    SELECT
        ds.date,
        ae.account_id_hashed,
        SUM(ae.event_type) OVER (PARTITION BY ds.date, ae.account_id_hashed) as current_sts
    FROM 
        date_sequence ds
    LEFT JOIN 
        account_events ae
    ON 
        ds.date >= ae.event_date
)
SELECT
    DATE(date) as dt,
    COUNT(DISTINCT account_id_hashed) AS open_accounts
FROM
    account_status
WHERE
    current_sts = 1
GROUP BY
    dt
ORDER BY dt DESC