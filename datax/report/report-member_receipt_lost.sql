drop table IF EXISTS sp_member_receipt_lost;
create table sp_member_receipt_lost as 
select *
,case when EXTRACT(DAY FROM (to_char(to_char(now(),'YYYY-MM-DD')::timestamp,'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=1 
  then case when days_span is null or days_span>=1 then 1 else 0 end 
  else null end as lost_in_0_days
,case when EXTRACT(DAY FROM (to_char(now(),'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=3
  then case when days_span is null or days_span>=3 then 1 else 0 end 
  else null end as lost_in_2_days
,case when EXTRACT(DAY FROM (to_char(now(),'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=8 
  then case when days_span is null or days_span>=8 then 1 else 0 end 
  else null end as lost_in_7_days
,case when EXTRACT(DAY FROM (to_char(now(),'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=16
  then case when days_span is null or days_span>=16 then 1 else 0 end 
  else null end as lost_in_15_days
,case when EXTRACT(DAY FROM (to_char(now(),'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=31 
  then case when days_span is null or days_span>=31 then 1 else 0 end 
  else null end as lost_in_30_days
,case when EXTRACT(DAY FROM (to_char(now(),'YYYY-MM-DD')::timestamp-d_stat::timestamp)) >=61 
  then case when days_span is null or days_span>=61 then 1 else 0 end 
  else null end as lost_in_60_days
,d_stat::timestamp as ts
from member_receipt_day_last_first_invest_time
;


