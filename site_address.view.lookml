- view: site_address
  sql_table_name: public.site_address
  fields:

  - dimension: address_1
    type: string
    sql: ${TABLE}.address_1

  - dimension: address_2
    type: string
    sql: ${TABLE}.address_2

  - dimension: address_3
    type: string
    sql: ${TABLE}.address_3

  - dimension: address_4
    type: string
    sql: ${TABLE}.address_4

  - dimension: address_5
    type: string
    sql: ${TABLE}.address_5

  - dimension: address_6
    type: string
    sql: ${TABLE}.address_6

  - dimension: address_7
    type: string
    sql: ${TABLE}.address_7

  - dimension: address_8
    type: string
    sql: ${TABLE}.address_8

  - dimension: address_9
    type: string
    sql: ${TABLE}.address_9

  - dimension: full_address
    type: string
    sql: ${TABLE}.full_address

  - dimension: mpan_core
    type: string
    sql: ${TABLE}.mpan_core

  - dimension: post_code
    type: zipcode
    sql: ${TABLE}.post_code
    
  - dimension: postcode_start
    type: zipcode
    sql: substring(${post_code},1,2)

  - measure: count
    type: count
    drill_fields: []

