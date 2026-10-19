
      
  
    

        create or replace transient table DB_BANKING.SNAPSHOTS.snap_accounts
         as
        (
    

    select *,
        md5(coalesce(cast(account_id as varchar ), '')
         || '|' || coalesce(cast(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as varchar ), '')
        ) as dbt_scd_id,
        to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
        to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
        
  
  coalesce(nullif(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())), to_timestamp_ntz(convert_timezone('UTC', current_timestamp()))), to_timestamp_tz('9999-12-31 00:00:00'))
  as dbt_valid_to
from (
        select * from DB_BANKING.STAGING.stg_accounts
    ) sbq



        );
      
  
  