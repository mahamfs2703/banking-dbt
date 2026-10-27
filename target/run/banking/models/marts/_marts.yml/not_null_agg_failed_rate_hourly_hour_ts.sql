select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hour_ts
from DB_BANKING.MARTS.agg_failed_rate_hourly
where hour_ts is null



      
    ) dbt_internal_test