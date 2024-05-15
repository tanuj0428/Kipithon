{{
  config(
    materialized = 'table',
    database = 'CONSUMPTION_LAYER',
    schema = 'CONSUMPTION_LAYER_SCHEMA'
  )
}}

with cte as (select * from {{ source('SERVICES_SCH_CONSUMP', 'OKTA_PARSED_ERROR_DATA') }})
select *
from cte