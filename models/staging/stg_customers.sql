select 

    cast(customer_id as number(38, 0)) as customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    country,
    kyc_status,
    created_at,
    updated_at,
    _fivetran_synced as fivetran_synced_at

from {{ source('banking_raw', 'customers') }}
    