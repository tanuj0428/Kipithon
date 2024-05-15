{{
  config(
    materialized = 'incremental',
    strategy = 'append',
    database = 'TRANSFORMATION_LAYER',
    schema = 'TRANS_SERVICE_LAYER'
  )
}}

{{ insert_into_fact() }}