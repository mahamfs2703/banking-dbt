select
    transaction_id,
    amount
from DB_BANKING.MARTS.fct_transactions
where not is_deleted and amount <= 0