- view: invoice_facts

  derived_table:
    sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
    distkey: invoice_id
    sortkeys: [invoice_id]
    sql: |
       SELECT  
              e.lst_trx_id AS invoice_id
             ,e.cust_customer_id AS customer_id
             ,e.total_amount as invoice_amount
             ,coalesce(sum(vlad_allocated_amount),0) as total_allocated_amount
             
            
             ,coalesce(sum(case when vlad_alloc_trx_type in ('SLRCP', 'SLPAY') then vlad_allocated_amount end),0) as total_cash_allocated_amount
             ,coalesce(sum(case when vlad_alloc_trx_type in ('SLCRN') then vlad_allocated_amount end),0) as total_credit_note_allocated_amount
             
             ,case when e.total_amount + sum(vlad_allocated_amount) > 0 then 'not fully paid' 
              when e.total_amount + sum(vlad_allocated_amount) = 0 then 'fully paid' 
              else 'over-allocated'
              end as payment_status

             ,coalesce(e.lst_due_date,
             
                case 
                 when  e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                 then DATEADD(day,14, e.lst_trx_date )
                 else e.lst_trx_date
                end) as due_date
            
            , case
              when 
              
              dateadd(day,31,
              
              coalesce(e.lst_due_date,
             
                case 
                 when  e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                 then DATEADD(day,14, e.lst_trx_date )
                 else e.lst_trx_date
                end)) < current_date
                  
                  and
                  
                  e.total_amount + sum(vlad_allocated_amount) > 0
                  
                  then 'in collection'
                  end
            AS collection_status
      
           ,coalesce(sum(case
                when 
                
                lst1_trx_date <  -- sum all allocations within 30 days of the invoice due date (need to confirm lst1_trx_date vs vlad_alloc_effective_date)
                   dateadd(day,31, 
                      (
                        coalesce(e.lst_due_date,
                           case when 
                          e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                          then DATEADD(day,14, e.lst_trx_date )
                        else e.lst_trx_date
                        end) -- this is the calculated due date for the invoice
                      )
                      )
                
                then vlad_allocated_amount
                end),0) as total_allocated_amount_within_30_days
        
              ,CASE
               WHEN
                  --- if the total amount collected within 30 days of the due date
                  (coalesce(sum(case
                  WHEN 
                  
                  lst1_trx_date <  -- sum all allocations within 30 days of the invoice due date (need to confirm lst1_trx_date vs vlad_alloc_effective_date)
                     dateadd(day,31, 
                        (
                          coalesce(e.lst_due_date,
                           case when 
                          e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                          then DATEADD(day,14, e.lst_trx_date )
                        else e.lst_trx_date
                        end)-- this is the calculated due date for the invoice
                        )
                        )
                  
                  then vlad_allocated_amount
                  end),0)
                  
                  --- is less than the invoice amount
                  + invoice_amount > 0)
                  
                  AND
                  --- and the due date was more than 30 days ago
                  
                  dateadd(day,31,coalesce(e.lst_due_date,
                           case when 
                          e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                          then DATEADD(day,14, e.lst_trx_date )
                        else e.lst_trx_date
                        end)) < current_date                  
                  
                  THEN
                  --- date it goes into collection
                  dateadd(day,31, 
                        (
                          coalesce(e.lst_due_date,
                           case when 
                          e.lst_payment_method = 'DD' and e.lst_cash_collection_method = 'PP' 
                          then DATEADD(day,14, e.lst_trx_date )
                        else e.lst_trx_date
                        end) -- this is the calculated due date for the invoice
                        )
                        )
                  END date_entered_collection
            
          
          
          
          FROM map_ers_collections AS e
          where lst_trx_type = 'SLINV'  
          
          group by e.lst_trx_id, e.total_amount, e.lst_payment_method, e.lst_cash_collection_method, e.lst_trx_date, e.lst_due_date, e.cust_customer_id 

  fields: 

    - dimension: invoice_id
      type: number
      hidden: true
      primary_key: true
      sql: ${TABLE}.invoice_id

    - dimension: invoice_amount
      type: number
      hidden: true
      sql: ${TABLE}.invoice_amount
    
    
    - dimension: total_allocated_amount
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: gbp
      sql: ${TABLE}.total_allocated_amount * -1.0

    - dimension_group: invoice_due
      view_label: 'Invoice'
      type: time
      timeframes: [time, date, week, month, raw]
      sql: ${TABLE}.due_date

    - dimension: overdue_days
      view_label: 'Invoice'
      type: number
      sql: |
          CASE
          WHEN ${invoice_facts.overdue_status} = 'Overdue'
          then datediff(day, ${invoice_due_raw}, current_date)
          END
      
    - dimension: overdue_days_tiered
      view_label: 'Invoice'
      type: tier
      style: integer
      tiers: [1, 16, 31, 61, 91, 121, 151, 366, 731, 1096]
      sql: ${overdue_days}

    - dimension: total_allocated_amount_within_30_days
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: gbp
      sql: ${TABLE}.total_allocated_amount_within_30_days*-1
      
    - dimension_group: entered_collection
      view_label: 'Invoice'
      type: time
      timeframes: [date, raw, month]
      sql: ${TABLE}.date_entered_collection


    - dimension: total_cash_allocated_amount
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: gbp
      sql: ${TABLE}.total_cash_allocated_amount*-1

    - dimension: total_credit_note_allocated_amount
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: gbp
      sql: ${TABLE}.total_credit_note_allocated_amount*-1

      
    - dimension: unpaid_amount
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: gbp 
      sql: ${invoice_amount}-${total_allocated_amount}

    - measure: sum_of_unpaid_amount
      label: 'Total Outstanding Debt'
      view_label: 'Invoice'
      description: 'Unpaid portiton remaining of all invoices, even if still in term'
      type: sum
      value_format_name: gbp
      sql: ${unpaid_amount}
   
   
    - measure: sum_of_overdue_invoice_unpaid_portion
      label: 'Unpaid Balance of Overdue Invoices'
      view_label: 'Invoice'
      description: 'Unpaid portiton remaining of overdue invoices'
      type: sum
      value_format_name: gbp
      filters: 
        invoice_facts.overdue_status: 'Overdue'
      sql: ${unpaid_amount}

    - measure: total_overdue_outstanding_debt
      type: number
      view_label: 'Overdue Debt'
      sql: ${sum_of_overdue_invoice_unpaid_portion} + ${txn_facts.total_overdue_unallocated_credit} + ${txn_facts.total_overdue_unallocated_cash_receipt} + ${txn_facts.total_overdue_unallocated_payment}
      value_format_name: gbp 
 
 
 
      
    - dimension: overdue_status
      view_label: 'Invoice'
      type: string
      sql: |
        case when ${unpaid_amount} > 0 AND ${invoice_due_raw} < CURRENT_DATE THEN 'Overdue'
        when ${total_allocated_amount} = ${map_ers_collections.total_amount} THEN 'Paid'
        when ${total_allocated_amount} > ${invoice_due_raw} THEN 'Over-allocated'
        else 'In term'
        END

    - dimension: collection_status
      view_label: 'Invoice'
      sql: |
        case
        when ${TABLE}.collection_status = 'in collection' THEN 'In Collection'
        else 'Not In Collection'
        end
        
      
      
    - dimension: total_allocated_amount_percent
      view_label: 'Invoice'
      group_label: 'Invoice Payment Summary'
      type: number
      value_format_name: percent_2
      sql: 1.0*${total_allocated_amount}/nullif(${map_ers_collections.total_amount},0)