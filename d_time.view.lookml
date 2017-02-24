- view: d_time
  sql_table_name: public.d_time
  fields:

  - dimension: d_time_cy_datetext
    type: string
    sql: ${TABLE}.d_time_cy_datetext

  - dimension: d_time_cy_dayofmonth
    type: number
    sql: ${TABLE}.d_time_cy_dayofmonth

  - dimension: d_time_cy_halfyear
    type: number
    sql: ${TABLE}.d_time_cy_halfyear

  - dimension: d_time_cy_month
    type: number
    sql: ${TABLE}.d_time_cy_month

  - dimension: d_time_cy_monthname
    type: string
    sql: ${TABLE}.d_time_cy_monthname

  - dimension: d_time_cy_quarter
    type: number
    sql: ${TABLE}.d_time_cy_quarter

  - dimension: d_time_cy_relative_day
    type: number
    sql: ${TABLE}.d_time_cy_relative_day

  - dimension: d_time_cy_relative_month
    type: number
    sql: ${TABLE}.d_time_cy_relative_month

  - dimension: d_time_cy_relative_week
    type: number
    sql: ${TABLE}.d_time_cy_relative_week

  - dimension: d_time_cy_relative_year
    type: number
    sql: ${TABLE}.d_time_cy_relative_year

  - dimension: d_time_cy_week
    type: number
    sql: ${TABLE}.d_time_cy_week

  - dimension: d_time_cy_weekday
    type: number
    sql: ${TABLE}.d_time_cy_weekday

  - dimension: d_time_cy_weekdayname
    type: string
    sql: ${TABLE}.d_time_cy_weekdayname

  - dimension: d_time_cy_year
    type: number
    sql: ${TABLE}.d_time_cy_year

  - dimension: d_time_cy_yearmonth
    type: number
    sql: ${TABLE}.d_time_cy_yearmonth

  - dimension: d_time_cy_yearmonthtext
    type: string
    sql: ${TABLE}.d_time_cy_yearmonthtext

  - dimension: d_time_cy_yearweek
    type: number
    sql: ${TABLE}.d_time_cy_yearweek

  - dimension: d_time_cy_yearweektext
    type: string
    sql: ${TABLE}.d_time_cy_yearweektext

  - dimension_group: d_time
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.d_time_date

  - dimension: d_time_dateint
    type: number
    sql: ${TABLE}.d_time_dateint

  - dimension: d_time_fy_halfyear
    type: number
    sql: ${TABLE}.d_time_fy_halfyear

  - dimension: d_time_fy_month
    type: number
    sql: ${TABLE}.d_time_fy_month

  - dimension: d_time_fy_quarter
    type: number
    sql: ${TABLE}.d_time_fy_quarter

  - dimension: d_time_fy_relative_year
    type: number
    sql: ${TABLE}.d_time_fy_relative_year

  - dimension: d_time_fy_week
    type: number
    sql: ${TABLE}.d_time_fy_week

  - dimension: d_time_fy_year
    type: number
    sql: ${TABLE}.d_time_fy_year

  - measure: count
    type: count
    drill_fields: [d_time_cy_weekdayname, d_time_cy_monthname]

