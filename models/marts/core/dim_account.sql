with versions as (

    select
        *,
        row_number() over (partition by account_id order by dbt_valid_from) as version_number
    from {{ ref('snap_accounts') }}

)

select

    md5(cast(account_id as varchar) || '|' || cast(dbt_valid_from as varchar)) as account_key,
    account_id,
    customer_id,
    account_type,
    currency,
    status,
    opened_at,
    case
        when version_number = 1 then to_timestamp_tz('1900-01-01 00:00:00')
        else dbt_valid_from
    end as valid_from,
    dbt_valid_to as valid_to,
    dbt_valid_to = to_timestamp_tz('9999-12-31 00:00:00') as is_current

from versions