{{ config(materialized="view") }}
select
    ac.account_id_hashed as account_id,
    ac.created_ts is not null as account_opened_flag,
    acd.closed_ts is not null as account_closed_flag,
    ar.reopened_ts is not null as account_reopened_flag,
    date(ac.created_ts) as creation_dt,
    date(acd.closed_ts) as closure_dt,
    date(ar.reopened_ts) as reopening_dt,
    case
        when ar.reopened_ts is not null
        then 'Reopened'
        when
            (acd.closed_ts is not null)
            and (ar.reopened_ts is null or ar.reopened_ts < acd.closed_ts)
        then 'Closed'
        else 'Open'
    end as current_status,
    ac.account_type as account_type,
from {{ ref("account_created") }} ac
left join
    {{ ref("account_closed_deduped") }} acd
    on ac.account_id_hashed = acd.account_id_hashed
left join
    {{ ref("account_reopened") }} ar on ac.account_id_hashed = ar.account_id_hashed
