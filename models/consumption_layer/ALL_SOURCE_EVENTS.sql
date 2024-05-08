{{
  config(
    materialized = 'table',
    database = 'CONSUMPTION_LAYER',
    schema = 'CONSUMPTION_LAYER_SCHEMA'
  )
}}


with cte as(
select * ,
       case 
       when RESULT = 'FAILURE' then ABS(random())%5 + 1 
       else 0
       END AS severity
       from {{ref('transformed')}}
)
select * , 
    case 
    when ABS(random())%5 + 1  = 1 then 'CLOUDSECURITY ALERTS' 
    when ABS(random())%5 + 1  = 2 then 'FAILED LOGIN'
    when ABS(random())%5 + 1  = 3 then 'SUSPICIOUS ACTIVITY'
    when ABS(random())%5 + 1  = 4 then 'PHISING'
    when ABS(random())%5 + 1  = 5 then 'MALWARE'
    end as catergory
    from cte

       
    

