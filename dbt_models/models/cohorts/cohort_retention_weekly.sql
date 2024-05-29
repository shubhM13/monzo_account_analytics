{{ config(materialized='view') }}

WITH cohort_base AS (
    SELECT
        u.signup_date,
        u.user_id,
        DATE_DIFF(t.activity_date, u.signup_date, DAY) AS days_since_signup
    FROM
        {{ ref('user_first_action') }} u
    LEFT JOIN
        {{ ref('user_activity') }} t
    ON
        u.user_id = t.user_id
),
retention AS (
    SELECT
        signup_date,
        FLOOR(days_since_signup / 7) AS cohort_week,
        COUNT(DISTINCT user_id) AS retained_users
    FROM
        cohort_base
    WHERE
        days_since_signup IS NOT NULL
    GROUP BY
        signup_date,
        FLOOR(days_since_signup / 7)
),
cohort_size AS (
    SELECT
        signup_date,
        COUNT(DISTINCT user_id) AS cohort_size
    FROM
        {{ ref('user_first_action') }}
    GROUP BY
        signup_date
)
SELECT
    r.signup_date,
    r.cohort_week,
    r.retained_users,
    c.cohort_size,
    (r.retained_users / c.cohort_size) * 100 AS retention_percentage
FROM
    retention r
JOIN
    cohort_size c
    ON r.signup_date = c.signup_date
WHERE 
    r.signup_date >= '2020-01-01'
ORDER BY
    r.signup_date,
    r.cohort_week
