
    
    

select
    minute_ts as unique_field,
    count(*) as n_records

from DB_BANKING.MARTS.agg_txn_volume_per_minute
where minute_ts is not null
group by minute_ts
having count(*) > 1


