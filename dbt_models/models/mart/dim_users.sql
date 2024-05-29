{{ config(materialized='view') }}
select distinct user_id_hashed 
, account_id_hashed
 from {{ref('account_created')}}