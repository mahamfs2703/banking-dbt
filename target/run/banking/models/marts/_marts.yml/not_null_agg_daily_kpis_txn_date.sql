select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select txn_date
from DB_BANKING.MARTS.agg_daily_kpis
where txn_date is null



      
    ) dbt_internal_test