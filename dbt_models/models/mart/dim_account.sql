{{ config(materialized='view') }}
SELECT 
    ac.account_id_hashed AS AccountID,
    ac.created_ts IS NOT NULL AS AccountOpenedFlag,
    acd.closed_ts IS NOT NULL AS AccountClosedFlag,
    ar.reopened_ts IS NOT NULL AS AccountReopenedFlag,
    DATE(ac.created_ts) AS CreationDate,
    DATE(acd.closed_ts) AS ClosureDate,
    DATE(ar.reopened_ts) AS ReopeningDate,
    CASE
        WHEN ar.reopened_ts IS NOT NULL THEN 'Reopened'
        WHEN (acd.closed_ts IS NOT NULL) 
              AND 
              (ar.reopened_ts IS NULL OR ar.reopened_ts < acd.closed_ts) THEN 'Closed'
        ELSE 'Open'
    END AS CurrentStatus,
    ac.account_type AS AccountType,
FROM {{ref('account_created')}} ac
LEFT JOIN {{ref('account_closed_deduped')}} acd ON ac.account_id_hashed = acd.account_id_hashed
LEFT JOIN {{ref('account_reopened')}} ar ON ac.account_id_hashed = ar.account_id_hashed
