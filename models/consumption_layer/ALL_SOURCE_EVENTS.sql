{{
  config(
    materialized = 'table',
    database = 'CONSUMPTION_LAYER',
    schema = 'CONSUMPTION_LAYER_SCHEMA'
  )
}}


with cte as(
select "requestID" as REQUESTID ,
        event_date as EVENT_DATE,
        "source_name" as SOURCE_NAME,
        "sourceIPAddress" as SOURCEIPADDRESS,
        result as RESULT,
        userid as USERID,
        name as NAME,
       case 
       when RESULT = 'FAILURE' then ABS(random())%5 + 1 
       else 0
       END AS SEVERITY
       from {{ref('transformed')}}
)
select * , 
    case 
    when ABS(random())%5 + 1  = 1 then 'MALWARE' 
    when ABS(random())%5 + 1  = 2 then 'FAILED LOGIN'
    when ABS(random())%5 + 1  = 3 then 'SUSPICIOUS ACTIVITY'
    when ABS(random())%5 + 1  = 4 then 'PHISING'
    else 'CLOUDSECURITY ALERTS'
    end as CATEGORY
    from cte

       
    

