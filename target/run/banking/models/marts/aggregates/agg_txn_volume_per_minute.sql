
  
    

        create or replace transient table DB_BANKING.MARTS.agg_txn_volume_per_minute
         as
        (-- one row per minute, for the live trend chart

select

    date_trunc('minute', transaction_ts) as minute_ts,
    count(*) as txn_count,
    sum(amount) as total_amount

from DB_BANKING.MARTS.fct_transactions
where not is_deleted
group by 1
        );
      
  