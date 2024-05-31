--select count(distinct account_id_hashed) from {{ref('account_created')}} -- 12000

--select count(distinct account_id_hashed) from {{ref('account_closed')}} -- 3909


--select count(distinct account_id_hashed) from {{ref('account_reopened')}} -- 7

select count(distinct AccountID) from {{ref('dim_account')}} where CurrentStatus = 'Open'