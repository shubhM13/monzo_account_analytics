-- models/clean/deduplicate_account_closed.sql
with ranked_accounts as (
    select
        account_id_hashed,
        closed_ts,
        row_number() over (
            partition by account_id_hashed, cast(closed_ts as date) 
            order by closed_ts desc
        ) as row_num
    from {{ source('monzo_datawarehouse', 'account_closed') }}
)

select
    closed_ts,
    account_id_hashed
from ranked_accounts
where row_num = 1
