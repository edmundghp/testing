- view: reference_dates
  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    sortkeys: [ref_date]
    distkey: ref_date
    sql: |
      select distinct dateadd('day',-1,date_trunc('month',lst_trx_date)) AS ref_date
      
      from map_ers_collections
      order by 1 desc
      

  fields:
  
  - dimension_group: ref_date
    type: date
    sql: ${TABLE}.ref_date

  sets:
    detail:
      - ref_date_time