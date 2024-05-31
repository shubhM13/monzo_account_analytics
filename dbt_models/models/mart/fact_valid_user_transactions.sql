{{ config(materialized="table") }}

select
    t.account_id_hashed as account_id,
    u.user_id_hashed as user_id,
    t.date as transaction_date,
    a.creation_dt,
    a.closure_dt,
    a.reopening_dt
from {{ ref("account_transactions") }} t
inner join {{ ref("dim_users") }} u on t.account_id_hashed = u.account_id_hashed
inner join {{ ref("dim_account") }} a on t.account_id_hashed = a.accountid
where
    (
        lower(a.currentstatus) <> 'reopened'
        and t.date
        between a.creation_dt and coalesce(a.closure_dt, date('9999-12-31'))
    )
    or (
        lower(a.currentstatus) = 'reopened'
        and (t.date between a.creation_dt and a.closure_dt)
    )
    or (
        lower(a.currentstatus) = 'reopened'
        and t.date between a.reopening_dt and date('9999-12-31')
    )
