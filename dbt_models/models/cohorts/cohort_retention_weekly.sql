{{ config(materialized='view') }}

WITH cohort_base AS (
    SELECT
        DATE_TRUNC(u.signup_date, WEEK(MONDAY)) AS cohort,
        u.user_id,
        DATE_DIFF(t.activity_date, u.signup_date, WEEK) AS weeks_since_signup
    FROM
        {{ ref('user_activation') }} u
    LEFT JOIN
        {{ ref('user_activity') }} t
    ON
        u.user_id = t.user_id
),
retention AS (
    SELECT
        cohort,
        weeks_since_signup AS period,
        COUNT(DISTINCT user_id) AS retained_users
    FROM
        cohort_base
    WHERE
        weeks_since_signup IS NOT NULL
    GROUP BY
        cohort,
        weeks_since_signup
),
cohort_size AS (
    SELECT
        DATE_TRUNC(signup_date, WEEK(MONDAY)) AS cohort,
        COUNT(DISTINCT user_id) AS signed_up_users
    FROM
        {{ ref('user_activation') }}
    GROUP BY
        cohort
)
SELECT
    r.cohort,
    r.period,
    r.retained_users,
    c.signed_up_users,
    (r.retained_users / c.signed_up_users) * 100 AS retention_percentage
FROM
    retention r
JOIN
    cohort_size c
    ON r.cohort = c.cohort
ORDER BY
    r.cohort,
    r.period
