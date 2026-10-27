
    
    

select
    account_id as unique_field,
    count(*) as n_records

from DB_BANKING.STAGING.stg_accounts
where account_id is not null
group by account_id
having count(*) > 1


