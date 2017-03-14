- view: green_information
  sql_table_name: public.d_green
  fields:

  - dimension: d_green_id
    primary_key: true
    hidden: true
    type: number
    sql: ${TABLE}.d_green_id

  - dimension_group: d_green_from
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.d_green_from_date

  - dimension: green_notes
    type: string
    sql: ${TABLE}.d_green_notes

  - dimension: green_category
    drill_fields: [green_product, consumption.mpan, consumption.meter_type]
    sql: |
      CASE
      WHEN ${green_product} = 'Conventional Power' THEN 'Conventional'
      WHEN ${green_product} = 'Green' THEN 'Green'
      WHEN ${green_product} ilike '%levy%' THEN 'Levy Exempt'
      WHEN ${green_product} ilike '%renewable%' THEN 'Renewable'
      ELSE 'Unknown'
      END
      
  
  - dimension: green_product
    type: string
    sql: ${TABLE}.d_green_product

  - dimension_group: d_green_to
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.d_green_to_date

  - measure: count
    type: count
    drill_fields: [d_green_id]

