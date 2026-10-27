select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select minute_ts
from DB_BANKING.MARTS.agg_txn_volume_per_minute
where minute_ts is null



      
    ) dbt_internal_test