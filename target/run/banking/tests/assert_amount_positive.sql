select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      select
    transaction_id,
    amount
from DB_BANKING.MARTS.fct_transactions
where not is_deleted and amount <= 0
      
    ) dbt_internal_test