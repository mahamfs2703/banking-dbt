
  create or replace   view DB_BANKING.STAGING.stg_transactions
  
   as (
    select

    cast(transaction_id as number(38, 0)) as transaction_id,
    cast(account_id as number(38, 0)) as account_id,
    cast(merchant_id as number(38, 0)) as merchant_id,
    transaction_type,
    cast(amount as number(14, 2)) as amount,
    currency,
    status,
    transaction_ts,
    created_at,
    updated_at,
    _fivetran_synced as fivetran_synced_at,
    coalesce(_fivetran_deleted, false) as is_deleted

from DB_BANKING.POSTGRES_BANKING.transactions
  );

