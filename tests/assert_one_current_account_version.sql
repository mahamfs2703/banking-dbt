select
    account_id,
    count(*) as current_versions
from {{ ref('dim_account') }}
where is_current
group by 1
having count(*) > 1