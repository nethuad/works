drop table IF EXISTS sp_member_lost;
create table sp_member_lost as 
select *
,case when EXTRACT(EPOCH FROM (now()-d_stat::timestamp)) /60/60/24 >=2 
  then case when days_span is null or days_span>=1 then 1 else 0 end 
  else null end as lost_in_1_days
,case when EXTRACT(EPOCH FROM (now()-d_stat::timestamp)) /60/60/24 >=8 
  then case when days_span is null or days_span>=7 then 1 else 0 end 
  else null end as lost_in_7_days
,case when EXTRACT(EPOCH FROM (now()-d_stat::timestamp)) /60/60/24 >=16
  then case when days_span is null or days_span>=15 then 1 else 0 end 
  else null end as lost_in_15_days
,case when EXTRACT(EPOCH FROM (now()-d_stat::timestamp)) /60/60/24 >=31 
  then case when days_span is null or days_span>=30 then 1 else 0 end 
  else null end as lost_in_30_days
,case when EXTRACT(EPOCH FROM (now()-d_stat::timestamp)) /60/60/24 >=61 
  then case when days_span is null or days_span>=60 then 1 else 0 end 
  else null end as lost_in_60_days
,d_stat::timestamp as ts
from member_receipt_noinvest_first_invest_time
;


