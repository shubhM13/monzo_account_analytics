{{ config(materialized="table") }}

with
    account_events as (
        select account_id_hashed, date(created_ts) as event_date, 1 as event_type  -- 1 for account creation
        from {{ ref("account_created") }}
        union all
        select account_id_hashed, date(closed_ts) as event_date, -1 as event_type  -- -1 for account closure
        from {{ ref("account_closed") }}
        union all
        select account_id_hashed, date(reopened_ts) as event_date, 1 as event_type  -- 1 for account reopening
        from {{ ref("account_reopened") }}
    ),
    date_sequence as (
        select date
        from {{ ref("dim_date") }}
        where
            date between (select min(event_date) from account_events) and (
                select max(event_date) from account_events
            )
    ),
    account_status as (
        select
            ds.date,
            ae.account_id_hashed,
            sum(ae.event_type) over (
                partition by ds.date, ae.account_id_hashed
            ) as current_sts
        from date_sequence ds
        left join account_events ae on ds.date >= ae.event_date
    )
select date, count(distinct account_id_hashed) as open_accounts
from account_status
where current_sts = 1
group by date
