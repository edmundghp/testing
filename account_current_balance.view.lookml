### SQL generated from https://havenpower.looker.com/explore/havenpower/map_ers_collections?qid=Fmxu3HSt6QLm7L0jfNWzfZ
- view: account_current_balance
  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    sortkeys: ["map_ers_collections.lst_crm_ext_id"]
    distkey: "map_ers_collections.lst_crm_ext_id"
    sql: |
      SELECT 
        map_ers_collections.lst_crm_ext_id AS "map_ers_collections.lst_crm_ext_id",
        COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN (case when (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) > 0 AND invoice_facts.due_date < CURRENT_DATE THEN 'Overdue'
      when (invoice_facts.total_allocated_amount * -1.0) = map_ers_collections.total_amount THEN 'Paid'
      when (invoice_facts.total_allocated_amount * -1.0) > invoice_facts.due_date THEN 'Over-allocated'
      else 'In term'
      END
       = 'Overdue') THEN (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (case when (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) > 0 AND invoice_facts.due_date < CURRENT_DATE THEN 'Overdue'
      when (invoice_facts.total_allocated_amount * -1.0) = map_ers_collections.total_amount THEN 'Paid'
      when (invoice_facts.total_allocated_amount * -1.0) > invoice_facts.due_date THEN 'Over-allocated'
      else 'In term'
      END
       = 'Overdue') THEN invoice_facts.invoice_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (case when (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) > 0 AND invoice_facts.due_date < CURRENT_DATE THEN 'Overdue'
      when (invoice_facts.total_allocated_amount * -1.0) = map_ers_collections.total_amount THEN 'Paid'
      when (invoice_facts.total_allocated_amount * -1.0) > invoice_facts.due_date THEN 'Over-allocated'
      else 'In term'
      END
       = 'Overdue') THEN invoice_facts.invoice_id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (case when (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) > 0 AND invoice_facts.due_date < CURRENT_DATE THEN 'Overdue'
      when (invoice_facts.total_allocated_amount * -1.0) = map_ers_collections.total_amount THEN 'Paid'
      when (invoice_facts.total_allocated_amount * -1.0) > invoice_facts.due_date THEN 'Over-allocated'
      else 'In term'
      END
       = 'Overdue') THEN invoice_facts.invoice_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (case when (invoice_facts.invoice_amount-(invoice_facts.total_allocated_amount * -1.0)) > 0 AND invoice_facts.due_date < CURRENT_DATE THEN 'Overdue'
      when (invoice_facts.total_allocated_amount * -1.0) = map_ers_collections.total_amount THEN 'Paid'
      when (invoice_facts.total_allocated_amount * -1.0) > invoice_facts.due_date THEN 'Over-allocated'
      else 'In term'
      END
       = 'Overdue') THEN invoice_facts.invoice_id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) + COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Credit note') THEN (txn_facts.total_amount + txn_facts.total_allocated_amount) ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Credit note') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Credit note') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Credit note') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Credit note') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) + COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Receipt of cash') THEN (txn_facts.total_amount + txn_facts.total_allocated_amount) ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Receipt of cash') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Receipt of cash') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Receipt of cash') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Receipt of cash') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) + COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Payment') THEN (txn_facts.total_amount + txn_facts.total_allocated_amount) ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Payment') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Payment') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Payment') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN (CASE
      WHEN txn_facts.due_date < current_date THEN 'Overdue'
      ELSE 'In term'
      END
       = 'Overdue') AND (CASE
      WHEN map_ers_collections.lst_trx_type = 'SLINV' THEN 'Invoice' 
      WHEN map_ers_collections.lst_trx_type = 'SLCRN' THEN 'Credit note' 
      WHEN map_ers_collections.lst_trx_type = 'SLRCP' THEN 'Receipt of cash' 
      WHEN map_ers_collections.lst_trx_type = 'SLPAY' THEN 'Payment' 
      WHEN true THEN 'Unknown' 
      END = 'Payment') THEN txn_facts.lst_trx_id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) AS "invoice_facts.total_overdue_outstanding_debt"
      FROM public.map_ers_collections AS map_ers_collections
      LEFT JOIN ${invoice_facts.SQL_TABLE_NAME} AS invoice_facts ON map_ers_collections.lst_trx_id = invoice_facts.invoice_id
      LEFT JOIN ${txn_facts.SQL_TABLE_NAME} AS txn_facts ON map_ers_collections.lst_trx_id = txn_facts.lst_trx_id
      
      GROUP BY 1
      ORDER BY 1 
      
  fields:


  - dimension: crm_ext_id
    type: string
    hidden: true
    sql: ${TABLE}."map_ers_collections.lst_crm_ext_id"

  - dimension: current_overdue_outstanding_debt
    type: number
    value_format_name: gbp
    sql: ${TABLE}."invoice_facts.total_overdue_outstanding_debt"
    
  - dimension: account_balance_status
    drill_fields: [ops_hierarchy.line_of_business,ops_hierarchy.cm_user_name, ops_hierarchy.tl_user_name, ops_hierarchy.customer_name, map_ers_collections.invoice_payment_method]
    description: 'Currently in debit / credit / zero positiotn'
    sql: |
      CASE
      WHEN ${current_overdue_outstanding_debt} > 0 THEN 'Debit Position'
      WHEN ${current_overdue_outstanding_debt} < 0 THEN 'Credit Position'
      WHEN ${current_overdue_outstanding_debt} = 0 THEN 'Net Zero'
      END
      

  sets:
    detail:
      - map_ers_collections_lst_crm_ext_id
      - invoice_facts_total_overdue_outstanding_debt