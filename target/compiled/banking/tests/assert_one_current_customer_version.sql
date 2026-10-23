select
    customer_id,
    count(*) as current_versions
from DB_BANKING.MARTS.dim_customer
where is_current
group by 1
having count(*) > 1