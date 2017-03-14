
- view: txn_facts
  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    distkey: lst_trx_id
    sortkeys: [lst_trx_id]
    sql: |
      SELECT 
        
        lst_trx_id
        ,total_amount
        ,coalesce(sum(vlad_allocated_amount),0) as total_allocated_amount
         ,coalesce(lst_due_date,
                           case when 
                          lst_payment_method = 'DD' and lst_cash_collection_method = 'PP' 
                          then DATEADD(day,14, lst_trx_date )
                        else lst_trx_date
                        end) as due_date
                
        FROM public.map_ers_collections 
        
        group by 1,2,lst_payment_method,lst_cash_collection_method,lst_trx_date,lst_due_date,lst_trx_type


  fields:


  - dimension: lst_trx_id
    type: number
    primary_key: true
    hidden: true
    sql: ${TABLE}.lst_trx_id



  - dimension_group: txn_due
    view_label: 'Txn Facts'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.due_date
    
  - dimension: txn_overdue_status
    sql: |
      CASE
      WHEN ${txn_due_raw} < current_date THEN 'Overdue'
      ELSE 'In term'
      END
    
  - dimension: txn_total_amount
    type: number
    hidden: true
    sql: ${TABLE}.total_amount

  - dimension: txn_allocated_amount
    type: number
    hidden: true
    sql: ${TABLE}.total_allocated_amount
    
  - dimension: txn_unallocated_amount
    type: number
    hidden: true
    sql: ${txn_total_amount} + ${txn_allocated_amount}
    
  - measure: total_unallocated_amount
    type: sum
    sql: ${txn_unallocated_amount}
    value_format_name: gbp

  - measure: total_overdue_unallocated_credit
    type: sum
    sql: ${txn_unallocated_amount}
    value_format_name: gbp
    filters:
      txn_overdue_status: 'Overdue'
      map_ers_collections.transaction_type: 'Credit note'

  - measure: total_overdue_unallocated_cash_receipt
    type: sum
    sql: ${txn_unallocated_amount}
    value_format_name: gbp
    filters:
      txn_overdue_status: 'Overdue'
      map_ers_collections.transaction_type: 'Receipt of cash'
      
  - measure: total_overdue_unallocated_payment
    type: sum
    sql: ${txn_unallocated_amount}
    value_format_name: gbp
    filters:
      txn_overdue_status: 'Overdue'
      map_ers_collections.transaction_type: 'Payment'


  sets:
    detail:
      - lst_trx_id
      - total_amount
      - total_allocated_amount