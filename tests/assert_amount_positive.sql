select
    transaction_id,
    amount
from {{ ref('fct_transactions') }}
where not is_deleted and amount <= 0