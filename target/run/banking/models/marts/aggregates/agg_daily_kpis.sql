
  
    

        create or replace transient table DB_BANKING.MARTS.agg_daily_kpis
         as
        (-- one row per day, for the KPI tiles

select

    cast(transaction_ts as date) as txn_date,
    count(*) as txn_count,
    count_if(is_completed) as completed_count,
    count_if(is_failed) as failed_count,
    div0(count_if(is_completed), count(*)) as success_rate,
    sum(case when is_completed then amount end) as completed_amount,
    avg(case when is_completed then amount end) as avg_ticket_size

from DB_BANKING.MARTS.fct_transactions
where not is_deleted
group by 1
        );
      
  