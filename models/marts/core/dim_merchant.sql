select

    md5(cast(merchant_id as varchar)) as merchant_key,
    merchant_id,
    merchant_name,
    category,
    city,
    country

from {{ ref('stg_merchants') }}