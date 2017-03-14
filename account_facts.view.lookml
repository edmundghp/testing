- view: account_facts

  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    distkey: customer_id
    sortkeys: [customer_id]
    sql: |
      SELECT  e.customer_id AS customer_id
             ,count(case when collection_status = 'in collection' then 1 end) as invoices_in_collection
             
      FROM ${invoice_facts.SQL_TABLE_NAME} AS e
      
      group by e.customer_id
      
      
      
  fields:
  - dimension: customer_id
    sql: ${TABLE}.customer_id
    hidden: true
    primary_key: true
    
  - dimension: number_invoices_in_collection
    type: number
    view_label: 'Customer Account'
    sql: ${TABLE}.invoices_in_collection
    
  - dimension: is_in_collection
    type: yesno
    view_label: 'Customer Account'
    sql: ${number_invoices_in_collection} > 0