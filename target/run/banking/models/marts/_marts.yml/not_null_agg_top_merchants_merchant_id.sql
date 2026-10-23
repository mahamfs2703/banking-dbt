select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select merchant_id
from DB_BANKING.MARTS.agg_top_merchants
where merchant_id is null



      
    ) dbt_internal_test