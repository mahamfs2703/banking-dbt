select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      select
    account_id,
    count(*) as current_versions
from DB_BANKING.MARTS.dim_account
where is_current
group by 1
having count(*) > 1
      
    ) dbt_internal_test