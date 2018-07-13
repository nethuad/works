--投标宽表 borrow_invest_wide

drop table IF EXISTS borrow_invest_wide;
create table borrow_invest_wide as 
select *
,case when is_member_inner =1 then '内投' 
 when is_recommended=1 and invest_order=1 then '推荐首投'
 when  is_recommended=1 and invest_order>1 then '推荐复投'
 when is_recommended=0 and invest_order=1 then '普通首投'
 when  is_recommended=0 and invest_order>1 then '普通复投'
 end as invest_type
,case when invest_dow=0 then '星期日' 
when invest_dow=1 then '星期一'
when invest_dow=2 then '星期二'
when invest_dow=3 then '星期三'
when invest_dow=4 then '星期四'
when invest_dow=5 then '星期五'
when invest_dow=6 then '星期六'
end as dayofweek
,EXTRACT(EPOCH FROM (invest_date::timestamp-reg_time::timestamp))/60/60/24 as reg_invest_span_days
from (
select a.*
,m.reg_time
,case when mi.member_id is null then 0 else 1 end as is_member_inner
,case when mr.member_id is null then 0 else 1 end as is_recommended
,mr.referrer_id as recommender
,date_trunc('day', invest_date::timestamp) as invest_day
,date_trunc('hour', invest_date::timestamp) as invest_hour
,EXTRACT(dow FROM invest_date::timestamp) as invest_dow
,EXTRACT(HOUR FROM invest_date::timestamp) as invest_hod
from (
select a.id,a.borrow_id,a.investor_id,a.capital,interest,loan_fee,invest_way,a.status
,b.cycle_type,b.cycle,b.borrow_type,b.amount as borrow_amount
,b.start_time as borrow_start_time
,b.full_time as borrow_full_time
,b.full_minutes as borrow_full_minute
,b.category_cn as borrow_category
,EXTRACT(EPOCH FROM (a.date_created::TIMESTAMP- b.start_time::timestamp)) /60 as invest_minutes_fromstart
,a.date_created as invest_date
,ROW_NUMBER() over(partition by a.investor_id order by a.date_created asc) as invest_order    
from borrow_invest a 
inner join borrow_wide b on a.borrow_id = b.id
where b.status in (1,4,5,6)
) a 
left outer join member m on a.investor_id=m.id
left outer join member_inner mi on a.investor_id=mi.member_id
left outer join (select * from recommend where status=1) mr on a.investor_id = mr.member_id
) a 
;




