
      
  
    

        create or replace transient table DB_BANKING.SNAPSHOTS.snap_customers
         as
        (
    

    select *,
        md5(coalesce(cast(customer_id as varchar ), '')
         || '|' || coalesce(cast(updated_at as varchar ), '')
        ) as dbt_scd_id,
        updated_at as dbt_updated_at,
        updated_at as dbt_valid_from,
        
  
  coalesce(nullif(updated_at, updated_at), to_timestamp_tz('9999-12-31 00:00:00'))
  as dbt_valid_to
from (
        select * from DB_BANKING.STAGING.stg_customers
    ) sbq



        );
      
  
  