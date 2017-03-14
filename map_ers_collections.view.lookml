- view: map_ers_collections
  sql_table_name: public.map_ers_collections
  fields:

### Contract

  - dimension: cont_account_type_code
    view_label: 'Contact'
    type: string
    sql: ${TABLE}.cont_account_type_code

  - dimension: cont_line_of_business_code
    view_label: 'Contact'
    type: string
    sql: ${TABLE}.cont_line_of_business_code



### Customer

  - dimension: cust_customer_id
    view_label: 'Customer Account'
    type: number
    sql: ${TABLE}.cust_customer_id

  - dimension: cust_customer_name
    view_label: 'Customer Account'
    type: string
    sql: ${TABLE}.cust_customer_name

  - dimension: cust_customer_type_code
    view_label: 'Customer Account'
    type: string
    sql: ${TABLE}.cust_customer_type_code

  - measure: count_of_customers
    view_label: 'Customer Account'
    type: count_distinct
    sql: ${lst_crm_ext_id}

### Related Transaction

  - dimension_group: lst1_trx
    view_label: 'Related Transaction'
    type: time
    hidden: true
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.lst1_trx_date

  - dimension: lst1_trx_reference
    view_label: 'Related Transaction'
    type: string
    hidden: true
    sql: ${TABLE}.lst1_trx_reference

  - dimension: lst1_trx_type
    view_label: 'Related Transaction'
    type: string
    hidden: true
    sql: ${TABLE}.lst1_trx_type


###  Transaction

  - dimension: lst_billing_period_number
    view_label: 'Transaction'
    type: number
    sql: ${TABLE}.lst_billing_period_number

  - dimension: lst_cash_collection_method
    view_label: 'Transaction'
    type: string
    sql: ${TABLE}.lst_cash_collection_method

  - dimension: lst_contract_id
    view_label: 'Transaction'
    type: number
    sql: ${TABLE}.lst_contract_id

  - dimension: lst_crm_ext_id
    view_label: 'Transaction'
#     label: 'Account ID'
    type: string
    sql: ${TABLE}.lst_crm_ext_id


    
  - dimension: invoice_payment_method
    view_label: 'Invoice'
    type: string
    sql: |
      case when ${lst_payment_method} = 'DD' then 
        (case when ${lst_cash_collection_method} = 'PP' then 'Regular Direct Debit'
        when ${lst_cash_collection_method} = 'IN' then 'Variable Direct Debit'
        end)
      when ${lst_payment_method} = 'BA' then 'BACS Transfer'
      else 'Other'
      end
      

  
  - dimension: payment_terms
    view_label: 'Invoice'
    type: number
    sql: |
        datediff(day, ${lst_trx_raw},${invoice_facts.invoice_due_raw})
    
    

  - dimension: lst_mpan_core
    view_label: 'Transaction'
    type: string
    sql: ${TABLE}.lst_mpan_core

  - dimension: lst_net_amount
    view_label: 'Transaction'
    type: number
    value_format_name: gbp
    sql: ${TABLE}.lst_net_amount

  - dimension: lst_payment_method
    view_label: 'Transaction'
    type: string
    sql: ${TABLE}.lst_payment_method
    

  - dimension: lst_related_trx_id
    view_label: 'Related Transaction'
    type: number
    hidden: true
    sql: ${TABLE}.lst_related_trx_id

  - dimension: lst_tax_amount
    view_label: 'Transaction'
    type: number
    value_format_name: gbp
    sql: ${TABLE}.lst_tax_amount

  - dimension_group: lst_trx
    view_label: 'Transaction'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.lst_trx_date
    drill_fields: [lst_trx_date, ops_hierarchy.line_of_business,ops_hierarchy.cm_user_name, ops_hierarchy.tl_user_name, ops_hierarchy.customer_name, invoice_payment_method]

  - dimension_group: invoice
    view_label: 'Invoice'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: CASE WHEN ${transaction_type} = 'Invoice' THEN ${lst_trx_raw} END

  - dimension: lst_trx_id
    view_label: 'Transaction'
    primary_key: true
    type: number
    sql: ${TABLE}.lst_trx_id

  - dimension: lst_trx_reference
    view_label: 'Transaction'
    type: string
    sql: ${TABLE}.lst_trx_reference

  - dimension: lst_trx_type
    view_label: 'Transaction'
    type: string
    hidden: true
    sql: ${TABLE}.lst_trx_type
    
  - dimension: transaction_type
    view_label: 'Transaction'
    type: string
    sql_case:
      Invoice: ${lst_trx_type} = 'SLINV'
      Credit note: ${lst_trx_type} = 'SLCRN'
      Receipt of cash: ${lst_trx_type} = 'SLRCP'
      Payment: ${lst_trx_type} = 'SLPAY'
      Unknown: true 

  - dimension: cash_payment_method
    view_label: 'Transaction'
    type: string
    sql: ${TABLE}.cash_payment_method
    
  - dimension: lst_writes_off_trx_id
    view_label: 'Transaction'
    type: number
    sql: ${TABLE}.lst_writes_off_trx_id

  - dimension: lst_writes_on_trx_id
    view_label: 'Transaction'
    type: number
    sql: ${TABLE}.lst_writes_on_trx_id

  - dimension: total_amount
    view_label: 'Transaction'
    type: number
    value_format_name: gbp
    sql: ${TABLE}.total_amount

### Unallocated payments and credits

    

    
  - measure: total_transaction_amount_credit
    type: sum_distinct
    sql_distinct_key: lst_trx_reference
    sql: ${total_amount}
    hidden: true
    filters:
      transaction_type: 'Credit note'
    
  - measure: total_allocations_credit
    type: sum
    # sql_distinct_key: vlad_allocation_id
    sql: coalesce(${vlad_allocated_amount},0)
    hidden: true
    filters:
      transaction_type: 'Credit note'
    
    
  - measure: total_unallocated_credit
    view_label: 'Unallocated Transactions'
    type: number
    sql: ${total_transaction_amount_credit} + ${total_allocations_credit}
    value_format_name: gbp
 
 
  # - measure: total_transaction_amount_cash_receipt
  #   type: sum_distinct
  #   sql_distinct_key: lst_trx_id
  #   sql: ${total_amount}
  #   hidden: true
  #   filters:
  #     transaction_type: 'Receipt of cash'
    
  # - measure: total_allocations_cash_receipt
  #   type: sum_distinct
  #   sql_distinct_key: vlad_allocation_id
  #   sql: ${vlad_allocated_amount}
  #   hidden: true
  #   filters:
  #     transaction_type: 'Receipt of cash'
    
    
  # - measure: total_unallocated_cash_receipt
  #   view_label: 'Unallocated Transactions'
  #   type: number
  #   sql: ${total_transaction_amount_cash_receipt} - ${total_allocations_cash_receipt}
  #   value_format_name: gbp   

  # - measure: total_transaction_amount_payment
  #   type: sum_distinct
  #   sql_distinct_key: lst_trx_id
  #   sql: ${total_amount}
  #   hidden: true
  #   filters:
  #     transaction_type: 'Payment'
    
  # - measure: total_allocations_payment
  #   type: sum_distinct
  #   sql_distinct_key: vlad_allocation_id
  #   sql: ${vlad_allocated_amount}
  #   hidden: true
  #   filters:
  #     transaction_type: 'Payment'
    
    
  # - measure: total_unallocated_payment
  #   view_label: 'Unallocated Transactions'
  #   type: number
  #   sql: ${total_transaction_amount_payment} - ${total_allocations_payment}
  #   value_format_name: gbp   
    

    
### Transaction Charge

  - dimension: lstc_charge_id
    view_label: 'Transaction Charge'
    type: number
    sql: ${TABLE}.lstc_charge_id

  - dimension: lstc_net_amount
    view_label: 'Transaction Charge'
    type: number
    value_format_name: gbp
    sql: ${TABLE}.lstc_net_amount

  - dimension: lstc_vat_amount
    view_label: 'Transaction Charge'
    type: number
    sql: ${TABLE}.lstc_vat_amount

  - dimension: lstc_transaction_source
    view_label: 'Transaction Charge'
    sql: ${TABLE}.lstc_transaction_source
    
  - dimension: payment_method_used
    view_label: 'Transaction Charge'
    sql: |
      CASE
      WHEN ${lstc_transaction_source} = 'DD Receipt'
      THEN ${cash_payment_method}
      ELSE ${lstc_transaction_source}
      END
    
    
### Representative

  - dimension: ur_preferred
    view_label: 'Representative'
    type: string
    sql: ${TABLE}.ur_preferred

  - dimension: ur_representative_role_code
    view_label: 'Representative'
    type: string
    sql: ${TABLE}.ur_representative_role_code

  - dimension: ur_user_id
    view_label: 'Representative'
    type: string
    sql: ${TABLE}.ur_user_id

  - dimension: uu_user_name
    view_label: 'Representative'
    type: string
    sql: ${TABLE}.uu_user_name



### VLAD

  - dimension: vlad_alloc_crm_ext_id
    view_label: 'Variable Ledger Allocation Details'
    hidden: true
    type: string
    sql: ${TABLE}.vlad_alloc_crm_ext_id

  - dimension: vlad_alloc_mpan_core
    view_label: 'Variable Ledger Allocation Details'
    hidden: true
    type: string
    sql: ${TABLE}.vlad_alloc_mpan_core

  - dimension: vlad_alloc_trx_id
    label: "Allocation Transaction ID"
    view_label: 'Variable Ledger Allocation Details'
    type: number
    sql: ${TABLE}.vlad_alloc_trx_id

  - dimension: vlad_alloc_trx_type
    hidden: true
    view_label: 'Variable Ledger Allocation Details'
    type: string
    sql: ${TABLE}.vlad_alloc_trx_type

  - dimension: allocation_transaction_type
    view_label: 'Variable Ledger Allocation Details'
    type: string
    sql_case:
      Invoice: ${vlad_alloc_trx_type} = 'SLINV'
      Credit note: ${vlad_alloc_trx_type} = 'SLCRN'
      Receipt of cash: ${vlad_alloc_trx_type} = 'SLRCP'
      Payment: ${vlad_alloc_trx_type} = 'SLPAY'
      Unknown: true 

  - dimension: vlad_allocated_amount
    label: 'Allocation Amount'
    view_label: 'Variable Ledger Allocation Details'
    type: number
    value_format_name: gbp
    sql: ${TABLE}.vlad_allocated_amount

  - dimension: vlad_allocation_id
    label: 'Allocation ID'
    view_label: 'Variable Ledger Allocation Details'
    type: number
    sql: ${TABLE}.vlad_allocation_id

  - dimension_group: vlad_effective
    label: 'Allocation Effective Date'
    view_label: 'Variable Ledger Allocation Details'
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.vlad_effective_date



### Other

  - measure: count
    # hidden: true
    type: count
    drill_fields: [cust_customer_name, uu_user_name]
 
 
### Invoices
    
  - measure: sum_of_invoice_totals
    view_label: 'Invoice'
    type: sum_distinct    
    value_format_name: gbp
    sql: ${total_amount}
    sql_distinct_key: ${lst_trx_id}
    drill_fields: [lst_trx_id, lst_trx_date, invoice_facts.due_date, total_amount, sum_of_invoice_allocation_amounts,  sum_of_invoice_allocation_amounts_paid, sum_of_invoice_allocation_amounts_credited, invoice_facts.sum_of_unpaid_amount]
    filters: 
      transaction_type: 'Invoice'
      
  - measure: count_of_invoices
    view_label: 'Invoice'
    type: count_distinct
    filters: 
      transaction_type: 'Invoice'
    sql: ${lst_trx_id}
    drill_fields: [lst_trx_id, total_amount, lst_trx_date, lst_due_date, vlad_alloc_trx_id, vlad_alloc_trx_type, vlad_allocated_amount, vlad_effective_date]
    
  - measure: count_of_overdue_invoices
    view_label: 'Invoice'
    type: count_distinct
    filters: 
      transaction_type: 'Invoice'
      invoice_facts.overdue_status: 'Overdue'
    sql: ${lst_trx_id}

  - measure: sum_of_overdue_invoices
    label: 'Sum of Overdue Invoice Amounts (Full Value)'
    view_label: 'Invoice'
    description: 'Total value of overdue invoices, including FULL value of partially paid invoices'
    type: sum_distinct
    value_format_name: gbp
    filters: 
      transaction_type: 'Invoice'
      invoice_facts.overdue_status: 'Overdue'
    sql: ${total_amount}
    sql_distinct_key: ${lst_trx_id}
# 
#   - measure: sum_of_overdue_invoice_unpaid_portion
#     label: 'Sum of Overdue Invoice Amounts (Unpaid Portion)'
#     view_label: 'Invoice'
#     description: 'Unpaid portiton remaining of overdue invoices'
#     type: sum_distinct
#     value_format_name: gbp
#     filters: 
#       transaction_type: 'Invoice'
#       invoice_facts.overdue_status: 'Overdue'
#     sql: ${invoice_facts.overdue_amount}
#     sql_distinct_key: ${lst_trx_id}
#     
  - measure: percent_of_overdue_invoices
    view_label: 'Invoice'
    type: number
    value_format_name: percent_2
    sql: 1.0*${count_of_overdue_invoices} /nullif(${count_of_invoices}, 0)

  - measure: sum_of_all_transactions
    view_label: 'Invoice'
    description: 'Sum of payment + cash amount (not tied to invoices - trx_date represents actual payment date)'
    type: sum_distinct    
    sql: ${total_amount}
    sql_distinct_key: ${lst_trx_id}
    value_format_name: gbp
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
   
  - measure: sum_of_payments_receieved
    view_label: 'Invoice'
    description: 'Sum of payment + cash amount (not tied to invoices - trx_date represents actual payment date)'
    type: sum_distinct    
    sql: ${total_amount} * -1.0
    sql_distinct_key: ${lst_trx_id}
    value_format_name: gbp
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
    filters: 
      transaction_type: 'Payment, Receipt of cash'    

  - measure: sum_of_credit_notes_issued
    view_label: 'Invoice'
    description: 'Sum of credit note amount (not tied to invoices - trx_date represents actual credit note transaction date)'
    type: sum_distinct    
    sql: ${total_amount} * -1.0
    sql_distinct_key: ${lst_trx_id}
    value_format_name: gbp
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
    filters: 
      transaction_type: 'Credit note'    
    
    
  - measure: sum_of_invoice_allocation_amounts
    view_label: 'Invoice'
    description: 'Sum of allocation amounts against invoices (trx_date represents date of corresponding invoice)'
    type: sum    
    value_format_name: gbp
    sql: ${vlad_allocated_amount}*-1
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
    filters: 
      transaction_type: 'Invoice'

  - measure: sum_of_invoice_allocation_amounts_paid
    view_label: 'Invoice'
    description: 'Sum of allocation amounts against invoices from payments and cash receipts'
    type: sum    
    value_format_name: gbp
    sql: ${vlad_allocated_amount}*-1
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
    filters: 
      transaction_type: 'Invoice'
      allocation_transaction_type: 'Payment, Receipt of cash'
      
  - measure: sum_of_invoice_allocation_amounts_credited
    view_label: 'Invoice'
    description: 'Sum of allocation amounts against invoices from credit notes'
    type: sum    
    value_format_name: gbp
    sql: ${vlad_allocated_amount}*-1
    drill_fields: [vlad_allocation_id, vlad_allocated_amount, allocation_transaction_type, vlad_effective_date, lst1_trx_date]
    filters: 
      transaction_type: 'Invoice'      
      allocation_transaction_type: 'Credit note'

  - measure: total_percent_collected
    view_label: 'Invoice'
    type: number
    value_format_name: percent_2
    sql: 1.0*${sum_of_invoice_allocation_amounts}/nullif(${sum_of_invoice_totals}, 0)
  
    

    