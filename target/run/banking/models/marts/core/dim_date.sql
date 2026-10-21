
  
    

        create or replace transient table DB_BANKING.MARTS.dim_date
         as
        (with spine as (

    select 
        dateadd(day, row_number() over (order by seq4()) -1, to_date('2024-01-01')) as date_day
    from table(generator(rowcount => 1827))

) 

select
    to_number(to_char(date_day, 'YYYYMMDD')) as date_key,
    date_day,
    year(date_day) as calendar_year,
    quarter(date_day) as calendar_quarter,
    month(date_day) as calendar_month,
    monthname(date_day) as month_name,
    day(date_day) as day_of_month,
    dayofweekiso(date_day) as day_of_week_iso,
    dayname(date_day) as day_name,
    weekofyear(date_day) as week_of_year,
    dayofweekiso(date_day) in (6,7) as is_weekend

from spine
        );
      
  