{{ config(materialized="view") }}
select distinct u.user_id_hashed as user_id, a.account_id as account_id,
from {{ ref("dim_users") }} u
inner join {{ ref("dim_active_accounts") }} a on u.account_id_hashed = a.account_id
order by user_id
