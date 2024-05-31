{{ config(materialized="view") }}
select account_id, creation_dt, current_status, account_type
from {{ ref("dim_account") }}
where current_status = 'Open' or reopening_dt is not null
