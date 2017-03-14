- view: map_ers_collections_generated
  sql_table_name: public.map_ers_collections
  fields:

  - dimension: cash_payment_method
    type: string
    sql: ${TABLE}.cash_payment_method

  - dimension: cont_account_type_code
    type: string
    sql: ${TABLE}.cont_account_type_code

  - dimension: cont_line_of_business_code
    type: string
    sql: ${TABLE}.cont_line_of_business_code

  - dimension: crh_plan_id_count
    type: number
    value_format_name: id
    sql: ${TABLE}.crh_plan_id_count

  - dimension: cust_customer_id
    type: number
    sql: ${TABLE}.cust_customer_id

  - dimension: cust_customer_name
    type: string
    sql: ${TABLE}.cust_customer_name

  - dimension: cust_customer_type_code
    type: string
    sql: ${TABLE}.cust_customer_type_code

  - dimension_group: lst1_trx
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.lst1_trx_date

  - dimension: lst1_trx_reference
    type: string
    sql: ${TABLE}.lst1_trx_reference

  - dimension: lst1_trx_type
    type: string
    sql: ${TABLE}.lst1_trx_type

  - dimension: lst_billing_period_number
    type: number
    sql: ${TABLE}.lst_billing_period_number

  - dimension: lst_cash_collection_method
    type: string
    sql: ${TABLE}.lst_cash_collection_method

  - dimension: lst_contract_id
    type: number
    sql: ${TABLE}.lst_contract_id

  - dimension: lst_crm_ext_id
    type: string
    sql: ${TABLE}.lst_crm_ext_id

  - dimension_group: lst_due
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.lst_due_date

  - dimension: lst_mpan_core
    type: string
    sql: ${TABLE}.lst_mpan_core

  - dimension: lst_net_amount
    type: number
    sql: ${TABLE}.lst_net_amount

  - dimension: lst_payment_method
    type: string
    sql: ${TABLE}.lst_payment_method

  - dimension: lst_related_trx_id
    type: number
    sql: ${TABLE}.lst_related_trx_id

  - dimension: lst_tax_amount
    type: number
    sql: ${TABLE}.lst_tax_amount

  - dimension_group: lst_trx
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.lst_trx_date

  - dimension: lst_trx_id
    type: number
    sql: ${TABLE}.lst_trx_id

  - dimension: lst_trx_reference
    type: string
    sql: ${TABLE}.lst_trx_reference

  - dimension: lst_trx_type
    type: string
    sql: ${TABLE}.lst_trx_type

  - dimension: lst_writes_off_trx_id
    type: number
    sql: ${TABLE}.lst_writes_off_trx_id

  - dimension: lst_writes_on_trx_id
    type: number
    sql: ${TABLE}.lst_writes_on_trx_id

  - dimension: lstc_charge_id
    type: number
    sql: ${TABLE}.lstc_charge_id

  - dimension: lstc_net_amount
    type: number
    sql: ${TABLE}.lstc_net_amount

  - dimension: lstc_transaction_source
    type: string
    sql: ${TABLE}.lstc_transaction_source

  - dimension: lstc_vat_amount
    type: number
    sql: ${TABLE}.lstc_vat_amount

  - dimension: obt_bacs_reference
    type: string
    sql: ${TABLE}.obt_bacs_reference

  - dimension: obt_bacs_trx_id
    type: number
    sql: ${TABLE}.obt_bacs_trx_id

  - dimension: obt_trx_reference
    type: string
    sql: ${TABLE}.obt_trx_reference

  - dimension: total_amount
    type: number
    sql: ${TABLE}.total_amount

  - dimension: ur_preferred
    type: string
    sql: ${TABLE}.ur_preferred

  - dimension: ur_representative_role_code
    type: string
    sql: ${TABLE}.ur_representative_role_code

  - dimension: ur_user_id
    type: string
    sql: ${TABLE}.ur_user_id

  - dimension: uu_user_name
    type: string
    sql: ${TABLE}.uu_user_name

  - dimension: vlad_alloc_crm_ext_id
    type: string
    sql: ${TABLE}.vlad_alloc_crm_ext_id

  - dimension: vlad_alloc_mpan_core
    type: string
    sql: ${TABLE}.vlad_alloc_mpan_core

  - dimension: vlad_alloc_trx_id
    type: number
    sql: ${TABLE}.vlad_alloc_trx_id

  - dimension: vlad_alloc_trx_type
    type: string
    sql: ${TABLE}.vlad_alloc_trx_type

  - dimension: vlad_allocated_amount
    type: number
    sql: ${TABLE}.vlad_allocated_amount

  - dimension: vlad_allocation_id
    type: number
    sql: ${TABLE}.vlad_allocation_id

  - dimension_group: vlad_effective
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.vlad_effective_date

  - measure: count
    type: count
    drill_fields: [cust_customer_name, uu_user_name]

