select

    cast(account_id as number(38, 0)) as account_id,
    cast(customer_id as number(38, 0)) as customer_id,
    account_type,
    currency,
    cast(balance as number(14, 2)) as balance,
    status,
    opened_at,
    created_at,
    updated_at,
    _fivetran_synced as fivetran_synced_at

from DB_BANKING.POSTGRES_BANKING.accounts
where not coalesce(_fivetran_deleted, false)