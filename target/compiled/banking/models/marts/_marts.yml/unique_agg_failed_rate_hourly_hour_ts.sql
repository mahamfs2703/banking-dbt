
    
    

select
    hour_ts as unique_field,
    count(*) as n_records

from DB_BANKING.MARTS.agg_failed_rate_hourly
where hour_ts is not null
group by hour_ts
having count(*) > 1


