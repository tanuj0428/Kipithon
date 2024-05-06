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
select * , 
       case 
       when RESULT = 'FAILURE' then ABS(random())%5 + 1 
       else 0
       END AS severity
       from cte 
