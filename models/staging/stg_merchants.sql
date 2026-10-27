select 

    cast(merchant_id as number(38, 0)) as merchant_id,
    merchant_name,
    category,
    city,
    country,
    created_at,
    updated_at,
    _fivetran_synced as fivetran_synced_at

from {{ source('banking_raw', 'merchants') }}
where not coalesce(_fivetran_deleted, false)