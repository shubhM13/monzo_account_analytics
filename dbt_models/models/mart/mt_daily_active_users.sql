{{ config(materialized="table") }}
with
    daily_active_users as (
        select transaction_date, count(distinct user_id) as daily_transacting_users
        from {{ ref("fact_valid_user_transactions") }} t
        group by transaction_date
    ),
    all_dates_daily_active_users as (
        select d.date, d.day, d.month, d.year, d.week, u.daily_transacting_users
        from {{ ref("dim_date") }} d
        left join daily_active_users u on d.date = u.transaction_date
    )
select *
from all_dates_daily_active_users
