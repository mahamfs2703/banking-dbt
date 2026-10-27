
  
    

        create or replace transient table DB_BANKING.MARTS.agg_top_merchants
         as
        (-- merchants ranked by completed value

with totals as (

    select
    
        m.merchant_key,
        m.merchant_id,
        m.merchant_name,
        m.category,
        count(*) as completed_txn_count,
        sum(f.amount) as completed_amount
        
    from DB_BANKING.MARTS.fct_transactions f
    join DB_BANKING.MARTS.dim_merchant m
        on m.merchant_key = f.merchant_key
    where not f.is_deleted and f.is_completed
    group by 1,2,3,4
)

select
    *,
    rank() over (order by completed_amount desc) as merchant_rank
from totals
        );
      
  