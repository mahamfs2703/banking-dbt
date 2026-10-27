select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      with fct as (
    select count(*) as fct_rows from DB_BANKING.MARTS.fct_transactions
),

stg as (
    select count(*) as stg_rows from DB_BANKING.STAGING.stg_transactions
)

select 
    fct.fct_rows,
    stg.stg_rows
from fct
cross join stg
where fct.fct_rows != stg.stg_rows
      
    ) dbt_internal_test