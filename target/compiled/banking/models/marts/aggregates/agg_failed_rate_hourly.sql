-- failed-transaction rate per hour

select 

    date_trunc('hour', transaction_ts) as hour_ts,
    count(*) as txn_count,
    count_if(is_failed) as failed_count,
    div0(count_if(is_failed), count(*)) as failed_rate

from DB_BANKING.MARTS.fct_transactions
where not is_deleted
group by 1