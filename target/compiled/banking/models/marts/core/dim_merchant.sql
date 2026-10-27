select

    md5(cast(merchant_id as varchar)) as merchant_key,
    merchant_id,
    merchant_name,
    category,
    city,
    country

from DB_BANKING.STAGING.stg_merchants