# - view: payment_facts
# 
#   derived_table:
#     sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24))
#     distkey: payment_id
#     sortkeys: [payment_id]
#     sql: |
#       SELECT  e.lst_trx_id AS payment_id
#              ,e.last1_trx_id AS related_invoice_id
#             ,datediff(day, lst_due_date, lst1_trx_date)
#       FROM map_ers_collections AS e
#       where lst_trx_type IN ('SLRCP','SLPAY') 
#       group by e.lst_trx_id
# 
# 
# 
# # # Or, you could make this view a derived table, like this:
# #   derived_table:
# #     sql: |
# #       SELECT
# #         user_id as user_id
# #         , COUNT(*) as lifetime_orders
# #         , MAX(orders.created_at) as most_recent_purchase_at
# #       FROM orders
# #       GROUP BY user_id
# #
# #  fields:
# # #     Define your dimensions and measures here, like this:
# #     - dimension: lifetime_orders
# #       type: number
# #       sql: ${TABLE}.lifetime_orders
# #
# #     - dimension: most_recent_purchase
# #       type: time
# #       timeframes: [date, week, month, year]
# #       sql: ${TABLE}.most_recent_purchase_at
# #
# #     - measure: total_lifetime_orders
# #       type: sum
# #       sql: ${lifetime_orders}