- connection: havenredshift

- include: "*.view.lookml"       # include all views in this project
- include: "*.dashboard.lookml"  # include all dashboards in this project


# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
# EXPLORE USED DURING TRIAL
#
# - explore: consumption
#   persist_for: 6 hours
#   joins:
#     - join: green_information
#       sql_on: ${consumption.green} = ${green_information.d_green_id}
#       relationship: many_to_one ## many rows in Consumption can correspond to 1 row in Green Metadata
#       
#     - join: site_address
#       sql_on: ${consumption.mpan_core} = ${site_address.mpan_core}
#       relationship: many_to_one 

- explore: map_ers_collections
  label: 'Ledger Reporting'
  sql_always_where: ${lst_trx_type} not in ('DARCP', 'DAPAY') #Filtering out Deposit Accounts
  joins:
    - join: ops_hierarchy
      view_label: 'Account Management Team'
      relationship: many_to_one 
      sql_on: ${cust_customer_id} = ${ops_hierarchy.cust_customer_id}
    
    - join: invoice_facts
      view_label: 'Invoice'
      relationship: many_to_one 
      sql_on: ${lst_trx_id} = ${invoice_facts.invoice_id}

    - join: txn_facts
      view_label: 'Transaction Facts'
      relationship: many_to_one 
      sql_on: ${lst_trx_id} = ${txn_facts.lst_trx_id}
      
      
    - join: account_facts
      relationship: many_to_one 
      sql_on: ${cust_customer_id} = ${account_facts.customer_id}
      
    - join: account_current_balance
      view_label: 'Customer Account'
      sql_on: ${lst_crm_ext_id} = ${account_current_balance.crm_ext_id}
      relationship: many_to_one
      
- explore: collection_movement_history 
  description: 'Monthly snapshots of accounts in collection'
  joins:
  - join: ops_hierarchy
    view_label: 'Account Management Team'
    relationship: many_to_one 
    sql_on: ${collection_movement_history.customer_id} = ${ops_hierarchy.cust_customer_id}  
    
  - join: invoice_details
    from: map_ers_collections
    fields: [invoice_payment_method]
    sql_on: ${collection_movement_history.invoice_id} = ${invoice_details.lst_trx_id}
      
      
      
      
      