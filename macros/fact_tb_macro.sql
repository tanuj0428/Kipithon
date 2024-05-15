{% macro insert_into_fact() %}
   {% set var %}
   select 
  current_date-1
 ,(select count(*) CLOUDWATCH from RAW_LAYER.SERVICES_SCH.CLOUDWATCH_EVENT_DATA as tb
      where substr(tb."eventTime",1,10) = current_date-1) 
 ,(select count(*) from RAW_LAYER.SERVICES_SCH.CLOUDWATCH_PARSED_DATA 
  where  "requestID" in (select "requestID" from RAW_LAYER.SERVICES_SCH.CLOUDWATCH_PARSED_ERROR_DATA)
  group by substr("eventTime",0,10)
  having substr("eventTime",0,10) = current_date-1)
 ,(select count(*) from RAW_LAYER.SERVICES_SCH.OKTA_EVENT_DATA 
  group by substr("published",0,10)
  having substr("published",0,10) = current_date-1)
 ,(select count(*) from RAW_LAYER.SERVICES_SCH.OKTA_PARSED_DATA 
  where "requestID" in (select "requestID" from RAW_LAYER.SERVICES_SCH.OKTA_PARSED_ERROR_DATA)
  group by substr("published",0,10)
  having substr("published",0,10) = current_date-1) from dual
  {% endset %}

  {{ var }}
{% endmacro%}