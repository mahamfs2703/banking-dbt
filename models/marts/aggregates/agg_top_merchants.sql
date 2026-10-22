-- merchants ranked by completed value

with totals as (

    select
    
        m.merchant_key,
        m.merchant_id,
        m.merchant_name,
        m.category,
        count(*) as completed_txn_count,
        sum(f.amount) as completed_amount
        
    from {{ ref('fct_transactions') }} f
    join {{ ref('dim_merchant') }} m
        on m.merchant_key = f.merchant_key
    where not f.is_deleted and f.is_completed
    group by 1,2,3,4
)

select
    *,
    rank() over (order by completed_amount desc) as merchant_rank
from totals
