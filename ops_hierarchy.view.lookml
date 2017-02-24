- view: ops_hierarchy
  sql_table_name: public.ops_hierarchy
  fields:

  
  - filter: selected_csm_user_name
    suggest_dimension: csm_user_name
  
  - dimension: dynamic_dimension
    label: ' Dynamic User'
    description: 'Use with selected csm name filter for dynamic grouping in dashboards'
    sql: |
      CASE
      WHEN {% condition selected_csm_user_name %} '' {% endcondition %}
      THEN ${csm_user_name}
      
      WHEN {% condition selected_csm_user_name %} ${csm_user_name} {% endcondition %}
      THEN ${csa_user_name}
      
      END
  
  - dimension: cm_user_id
    type: string
    hidden: true
    sql: ${TABLE}.cm_user_id



  - dimension: crm_ext_id
    type: string
    hidden: true
    sql: ${TABLE}.crm_ext_id

  - dimension: csa_user_id
    hidden: true
    type: string
    sql: ${TABLE}.csa_user_id



  - dimension: csm_user_id
    type: string
    hidden: true
    sql: ${TABLE}.csm_user_id

  - dimension: cust_customer_id
    hidden: true
    type: number
    sql: ${TABLE}.cust_customer_id



  - dimension: od_user_id
    type: string
    hidden: true
    sql: ${TABLE}.od_user_id

  - dimension: tl_user_id
    type: string
    hidden: true
    sql: ${TABLE}.tl_user_id



  - dimension: od_user_name
    type: string
    label: '(1) OD Name'
    sql: ${TABLE}.od_user_name
    drill_fields: [csm_user_name, cm_user_name, tl_user_name, csa_user_name, map_ers_collections.cust_customer_name]


  - dimension: csm_user_name
    label: '(2) CSM Name'
    type: string
    sql: ${TABLE}.csm_user_name
    drill_fields: [cm_user_name, tl_user_name, csa_user_name, map_ers_collections.cust_customer_name]

  - dimension: cm_user_name
    label: '(3) CM Name'
    type: string
    sql: ${TABLE}.cm_user_name
    drill_fields: [tl_user_name, csa_user_name, map_ers_collections.cust_customer_name]


  - dimension: tl_user_name
    type: string
    label: '(4) TL Name'
    sql: ${TABLE}.tl_user_name
    drill_fields: [csa_user_name, map_ers_collections.cust_customer_name]
    
  - dimension: csa_user_name
    label: '(5) CSA Name'
    type: string
    sql: ${TABLE}.csa_user_name
    drill_fields: [map_ers_collections.cust_customer_name]

  - dimension: line_of_business
    drill_fields: [csm_user_name, cm_user_name, tl_user_name, csa_user_name, map_ers_collections.cust_customer_name]
    sql: |
      CASE
      WHEN ${tl_user_name} in ('(None)','a.lankester-bell','amy.tyler','april.eden','Bev.Jay','caleb.djanmah','felicity.talbot','gemma.silburn','jade.fitzpatrick','Jade.Premodel','john.east'
          ,'kelly.mayhew','leigh.rendell','monique.dickerson','simon.grimwood','SMEHH.BlendTL','Spare.TL','stuart.wilson','taylor.hastings'
          ,'Tori.Ball','val.rose','victoria.brown','yaqub') THEN 'SME'
      WHEN ${tl_user_name} in ('beth.manning','c.mawson','Charlotte.Mawson','Judith Gooding','Sally.Keeble','Thames Team Leader')
          THEN 'I&C'
      END

  - dimension: customer_name
    type: string
    hidden: true
    sql: ${TABLE}.customer_name

  
  - measure: count
    type: count


  # ----- Sets of fields for drilling ------
  sets:
    detail:
    - customer_name
    - od_user_name
    - csm_user_name
    - cm_user_name
    - tl_user_name
    - csa_user_name

