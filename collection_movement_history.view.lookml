
- view: collection_movement_history
  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    sortkeys: [ref_date]
    distkey: invoice_id
    sql: |
      select distinct
        invoice_facts.invoice_id
        ,invoice_facts.customer_id
        ,invoice_facts.invoice_amount
        ,invoice_facts.due_date
        ,invoice_facts.date_entered_collection
        ,reference_dates.ref_date
        ,coalesce(sum(case when date_trunc('month',map_ers_collections.lst1_trx_date) = date_trunc('month',ref_date) then vlad_allocated_amount end),0) as amount_allocated_in_month
        ,coalesce(sum(case when date_trunc('month',map_ers_collections.lst1_trx_date) = date_trunc('month',ref_date) and vlad_alloc_trx_type = 'SLCRN'  then vlad_allocated_amount end),0) as amount_credited_in_month
        ,coalesce(sum(case when date_trunc('month',map_ers_collections.lst1_trx_date) = date_trunc('month',ref_date) and vlad_alloc_trx_type in ('SLRCP','SLPAY')  then vlad_allocated_amount end),0) as amount_paid_in_month
        
        
        
        ,coalesce(sum(case when map_ers_collections.lst1_trx_date <= ref_date then vlad_allocated_amount end),0) as amount_paid_so_far
        
      
      
      from ${invoice_facts.SQL_TABLE_NAME} as invoice_facts
      left join ${reference_dates.SQL_TABLE_NAME} as reference_dates
          on invoice_facts.date_entered_collection <= reference_dates.ref_date
      left join public.map_ers_collections as map_ers_collections
          on invoice_facts.invoice_id = map_ers_collections.lst_trx_id
      
      where date_entered_collection is not null
      -- and invoice_facts.invoice_id = '1729561'
      
      group by 1,2,3,4,5,6
      order by ref_date
 

  fields:


  - dimension: invoice_id
    type: number
    sql: ${TABLE}.invoice_id

  - dimension: customer_id
    type: number
    sql: ${TABLE}.customer_id

  - measure: invoices_in_collection
    type: count_distinct
    sql: ${invoice_id}
    filters:
      is_in_collection: 'Yes'


  - dimension_group: invoice_due
    type: time
    timeframes: [date, month, raw]
    sql: ${TABLE}.due_date

  - dimension_group: date_entered_collection
    type: time
    timeframes: [date, month, raw]
    sql: ${TABLE}.date_entered_collection

  - dimension_group: ref
    type: time
    timeframes: [month, raw]
    sql: ${TABLE}.ref_date
    
  - dimension: months_in_collection
    type: number
    sql: datediff('month',${date_entered_collection_raw},${ref_raw})

  - dimension: is_new_collection
    type: yesno
    sql: date_trunc('month',${ref_raw}) = date_trunc('month',${date_entered_collection_raw})

  - dimension: is_in_collection
    type: yesno
    description: 'Indicates whether an invoice was still in collection as of the ref month'
    sql: ${amount_paid_so_far} <> ${invoice_amount} 
#     sql: ${amount_paid_so_far} <> ${invoice_amount} AND ${amount_allocated_in_month} <> 0
    


  - dimension: amount_allocated_in_month
    type: number
    sql: ${TABLE}.amount_allocated_in_month * -1.0

  - measure: total_reduction
    type: sum
    sql: ${amount_allocated_in_month}
    value_format_name: gbp

  - dimension: amount_credited_in_month
    type: number
    sql: ${TABLE}.amount_credited_in_month * -1.0

  - measure: total_credit_adjustments
    type: sum
    sql: ${amount_credited_in_month}
    value_format_name: gbp
    
    
    
  - dimension: amount_paid_in_month
    type: number
    sql: ${TABLE}.amount_paid_in_month * -1.0

  - measure: total_cash_payments
    type: sum
    sql: ${amount_paid_in_month}
    value_format_name: gbp
 
 
 
  - dimension: invoice_amount
    type: number
    sql: ${TABLE}.invoice_amount
    
  - measure: total_invoice_amount
    type: sum
    sql: ${invoice_amount}
    value_format_name: gbp

 
 
  - dimension: amount_paid_so_far
    type: number
    sql: ${TABLE}.amount_paid_so_far * -1.0

  - dimension: balance_outstanding
    type: number
    sql: ${invoice_amount} - ${amount_paid_so_far}

  - measure: total_balance_outstanding
    type: sum
    sql: ${balance_outstanding}
    value_format_name: gbp

  sets:
    detail:
      - invoice_id
      - invoice_amount
      - due_date_time
      - date_entered_collection_time
      - ref_date_time
      - amount_allocated_in_month
      - amount_credited_in_month
      - amount_paid_in_month
      - amount_paid_so_far