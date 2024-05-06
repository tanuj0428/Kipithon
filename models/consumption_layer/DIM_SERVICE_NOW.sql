{{
  config(
    materialized = 'table',
    database = 'CONSUMPTION_LAYER',
    schema = 'CONSUMPTION_LAYER_SCHEMA'
  )
}}

with cte as (select * from {{ source('SERVICE_NOW_CONSUMP', 'SERVICENOW_TABLE') }})
select TICKET_ID 
      ,PROBLEM_SHORT_DESCRIPTION 
      ,STATUS 
      ,SUMMARY 
      ,OPEN_TIME 
      ,CLOSE_TIME
      from cte