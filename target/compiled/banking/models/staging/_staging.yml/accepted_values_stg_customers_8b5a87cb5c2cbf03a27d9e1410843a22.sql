
    
    

with all_values as (

    select
        kyc_status as value_field,
        count(*) as n_records

    from DB_BANKING.STAGING.stg_customers
    group by kyc_status

)

select *
from all_values
where value_field not in (
    'PENDING','VERIFIED','REJECTED'
)


