{{
  config(
    materialized = 'table',
    database = 'TRANSFORMATION_LAYER',
    schema = 'TRANS_SERVICE_LAYER'
  )
}}

-- select to_date(substr("eventTime",0,10)) as "event_date" , "source_name", "sourceIPAddress"  ,
-- case when "errorMessage" is null then 'SUCCESS'
-- else 'FAILURE'
-- end as result
-- from {{ source("SERVICES_SCH_TRANSFORM", "CLOUDWATCH_EVENT_DATA") }} as data
-- LEFT JOIN {{ source("SERVICES_SCH_TRANSFORM", "CLOUDWATCH_PARSED_ERROR_DATA") }} as error on data."requestID" = error."requestID"
-- where "sourceIPAddress" in (select "ipAddress" from {{ source("SERVICES_SCH_TRANSFORM", "OKTA_EVENT_DATA") }})
-- UNION ALL
-- select to_date(substr("published",0,10)) , "source_name" , "ipAddress" , "result"
-- from {{ source("SERVICES_SCH_TRANSFORM", "OKTA_EVENT_DATA") }};



with cte as(
select data."requestID",to_date(substr("eventTime",0,10)) as event_date , "source_name", "sourceIPAddress"  ,
case when "errorMessage" is null then 'SUCCESS'
else 'FAILURE'
end as result
from {{ source("SERVICES_SCH_TRANSFORM", "CLOUDWATCH_EVENT_DATA") }} data
LEFT JOIN {{ source("SERVICES_SCH_TRANSFORM", "CLOUDWATCH_PARSED_ERROR_DATA") }} error on data."requestID" = error."requestID"
where "sourceIPAddress" in (select "ipAddress" from RAW_LAYER.SERVICES_SCH.OKTA_EVENT_DATA)
UNION ALL
select "requestID",to_date(substr("published",0,10)) , "source_name" , "ipAddress" , "result"
from {{ source("SERVICES_SCH_TRANSFORM", "OKTA_EVENT_DATA") }}
),
cte2 as (select e_info.userid,concat(EMP_FIRST_NAME,' ',emp_last_name) as name , e_ip.emp_ipaddress 
        from {{ source("EMPLOYEE_DATA", "EMPLOYEE_INFO") }} e_info 
        inner join {{ source("EMPLOYEE_DATA", "EMPLOYEE_IPADDR") }} e_ip on e_info.userid = e_ip.userid )
select "requestID",event_date ,"source_name","sourceIPAddress",RESULT ,USERID, NAME from cte
left join cte2 on cte."sourceIPAddress" = cte2.EMP_IPADDRESS
