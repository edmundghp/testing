- view: consumption
  sql_table_name: public.f_consumption_actual
  fields:

  - dimension: contract_status
    type: string
    sql: ${TABLE}.f_consumption_actual_contractstatus

  - dimension: dno
    label: 'DNO'
    type: number
    sql: ${TABLE}.f_consumption_actual_dno

  - dimension: eac
    type: number
    label: 'EAC'
    sql: ${TABLE}.f_consumption_actual_eac

  - dimension: green
    type: number
    hidden: true
    sql: ${TABLE}.f_consumption_actual_green

  - dimension: gsp
    type: string
    label: 'GSP'
    sql: ${TABLE}.f_consumption_actual_gsp

  - dimension: manually_billed
    type: number
    sql: ${TABLE}.f_consumption_actual_manuallybilled

  - dimension: market_sector
    type: string
    sql: ${TABLE}.f_consumption_actual_marketsector

  - dimension: measurement_class
    type: string
    sql: ${TABLE}.f_consumption_actual_measurementclass

  - dimension: meter_type
    type: string
    sql: ${TABLE}.f_consumption_actual_metertype

  - dimension: mpan
    label: 'MPAN'
    type: string
    sql: ${TABLE}.f_consumption_actual_mpan
    
  - measure: count_meters
    type: count_distinct
    sql: ${mpan}

  - dimension: mpan_core
    type: string
    sql: ${TABLE}.f_consumption_actual_mpancore

  - dimension: pass_through_desc
    type: string
    sql: ${TABLE}.f_consumption_actual_passthroughdesc

  - dimension: payment_type
    type: string
    sql: ${TABLE}.f_consumption_actual_paymenttype

  - dimension: pc
    type: string
    sql: ${TABLE}.f_consumption_actual_pc

  - dimension: pricing_structure
    type: string
    sql: ${TABLE}.f_consumption_actual_pricingstructure

  - dimension: read_type
    type: string
    sql: ${TABLE}.f_consumption_actual_readtype

  - dimension: revenue_status_flag
    type: number
    sql: ${TABLE}.f_consumption_actual_revenuestatusflag

  - dimension: sales_leadoriginator_id
    type: number
    value_format_name: id
    sql: ${TABLE}.f_consumption_actual_salesleadoriginatorid

#   - dimension: settlement
#     type: time
#     timeframes: [date, month, year, quarter, day_of_week]
#     datatype: yyyymmdd
#     sql: ${TABLE}.f_consumption_actual_settlementdate

  - dimension_group: settlement
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.f_consumption_actual_settlementdate_stamp

  - dimension: supplier_id
    type: string
    sql: ${TABLE}.f_consumption_actual_supplierid

  - dimension: supply_status
    type: string
    sql: ${TABLE}.f_consumption_actual_supplystatus

  - dimension: consumption  ### anything that gets used in a GROUP BY cluase
    label: 'Consumption (kWh)'
    description: 'Measured in kWh'
    type: number
    sql: ${TABLE}.f_consumption_actual_totalconsumption

  - measure: total_consumption_kwh ### aggregates across multiple rows
    label: 'Total Consumption (kWh)'
    drill_fields: [mpan, settlement_date, market_sector, total_consumption_kwh, dno]
    type: sum
    sql: ${consumption}
    value_format_name: decimal_2
    
  - measure: total_consumption_mwh ### aggregates across multiple rows
    label: 'Total Consumption (MWh)'
    drill_fields: [mpan, settlement_date, total_consumption_kwh]
    type: sum
    sql: ${consumption} / 1000.0
    value_format_name: decimal_0

  - measure: average_consumption_daily ### aggregates across multiple rows
    label: 'Avg Daily MWh'
    drill_fields: [mpan, settlement_date, total_consumption_kwh]
    type: number
    sql: ${total_consumption_mwh} / nullif(datediff('day',min(${settlement_raw}),max(${settlement_raw})),0)
    value_format_name: decimal_1  

  - measure: average_consumption_daily_per_user ### aggregates across multiple rows
    label: 'Avg Daily MWh per User'
    drill_fields: [mpan, settlement_date, total_consumption_kwh]
    type: number
    sql: ${total_consumption_mwh} / ( nullif(datediff('day',min(${settlement_raw}),max(${settlement_raw})),0) * ${count_users})
    value_format_name: decimal_1  

  - measure: average_consumption_daily_per_meter ### aggregates across multiple rows
    label: 'Avg Daily MWh per Meter'
    drill_fields: [mpan, settlement_date, total_consumption_kwh]
    type: number
    sql: ${total_consumption_mwh} / ( nullif(datediff('day',min(${settlement_raw}),max(${settlement_raw})),0) * ${count_meters} )
    value_format_name: decimal_1  


  - dimension: userid
    type: string
    sql: ${TABLE}.f_consumption_actual_userid
    links:
    - label: User Lookup Dashboard
      url: https://havenpower.looker.com/dashboards/2?User%20ID={{ value | encode_uri }}
      icon_url: http://www.looker.com/favicon.ico
    
  - filter: userid_comparison_selector
    suggest_dimension: userid
    view_label: 'User Comparison'
    description: 'Use together with Comparitor dimension'
    
  - dimension: user_comparitor
    view_label: 'User Comparison'
    sql: |
      CASE WHEN {% condition userid_comparison_selector %} ${userid} {% endcondition %}
      THEN 'User '||${userid}
      ELSE 'Rest Of Population'
      END
    
    
    
  - measure: count_users
    type: count_distinct
    sql: ${userid}

  - measure: count
    type: count
    drill_fields: []

