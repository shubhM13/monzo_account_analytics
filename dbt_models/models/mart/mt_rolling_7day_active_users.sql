{{ config(materialized='table') }}

with rolling_7day_activity as (
SELECT
    a.*,
    SUM(a.daily_transacting_users) OVER (
        ORDER BY a.date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7day_transacting_users
FROM
    {{ref('mt_daily_active_users')}} a)

select b.*
, c.open_accounts as cumulative_open_accounts
, (b.rolling_7day_transacting_users/open_accounts)*100 as rolling_7d_active_users
from rolling_7day_activity b 
inner join {{ref('mt_daily_cum_active_accounts')}} c
on b.date = c.date
order by b.date asc