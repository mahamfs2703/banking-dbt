
    
    

select
    merchant_id as unique_field,
    count(*) as n_records

from DB_BANKING.MARTS.agg_top_merchants
where merchant_id is not null
group by merchant_id
having count(*) > 1


