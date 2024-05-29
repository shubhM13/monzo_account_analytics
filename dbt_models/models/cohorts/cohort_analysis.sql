-- models/marts/cohort_analysis.sql
{{ config(materialized='table') }}

WITH account_events AS (
    SELECT
        user_id_hashed,
        ac.account_id_hashed,
        DATE(MIN(ac.created_ts)) AS account_start_date,
        DATE(MAX(acc.closed_ts)) AS account_end_date,
        DATE(MAX(ar.reopened_ts)) AS account_reopened_date,
        CURRENT_DATE() AS observation_date
    FROM
        {{ ref('account_created') }} ac
    LEFT JOIN
        {{ ref('account_closed') }} acc ON ac.account_id_hashed = acc.account_id_hashed
    LEFT JOIN
        {{ ref('account_reopened') }} ar ON ac.account_id_hashed = ar.account_id_hashed
    GROUP BY
        user_id_hashed,
        ac.account_id_hashed
),

cohort_data AS (
    SELECT
        user_id_hashed,
        account_id_hashed,
        DATE_TRUNC(account_start_date, MONTH) AS cohort,
        DATE_DIFF(CURRENT_DATE(), account_start_date, MONTH) AS cohort_age_months,
        IFNULL(account_end_date, CURRENT_DATE()) AS account_end_date,
        IFNULL(account_reopened_date, CURRENT_DATE()) AS account_reopened_date
    FROM
        account_events
),

transaction_data AS (
    SELECT
        cohort,
        account_id_hashed,
        DATE_DIFF(DATE(date), cohort, MONTH) AS age_months,
        COUNT(*) AS n_active_users,
        SUM(transactions_num) AS revenue
    FROM
        {{ ref('account_transactions') }}
    JOIN
        cohort_data USING (account_id_hashed)
    GROUP BY
        cohort, account_id_hashed, age_months
)

SELECT
    cohort,
    COUNT(DISTINCT account_id_hashed) AS n_users,
    age_months AS period,
    SUM(n_active_users) AS n_active_users,
    SUM(revenue) AS transactions
FROM
    transaction_data
GROUP BY
    cohort, period
ORDER BY
    cohort, period
