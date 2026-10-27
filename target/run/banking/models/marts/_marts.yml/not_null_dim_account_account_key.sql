select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select account_key
from DB_BANKING.MARTS.dim_account
where account_key is null



      
    ) dbt_internal_test