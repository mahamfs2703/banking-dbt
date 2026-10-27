
    
    

select
    txn_date as unique_field,
    count(*) as n_records

from DB_BANKING.MARTS.agg_daily_kpis
where txn_date is not null
group by txn_date
having count(*) > 1


