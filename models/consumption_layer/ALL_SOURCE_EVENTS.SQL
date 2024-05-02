{{
  config(
    materialized = 'table',
    database = 'CONSUMPTION_LAYER',
    schema = 'CONSUMPTION_LAYER_SCHEMA'
  )
}}


with cte as(
select * from {{ref('transformed')}}
)
select * from cte 
