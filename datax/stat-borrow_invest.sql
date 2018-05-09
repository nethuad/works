--投标宽表 borrow_invest_wide

drop table IF EXISTS borrow_invest_wide_tmp;
create table borrow_invest_wide_tmp as 
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
from (
select *
,ROW_NUMBER() over(partition by investor_id order by date_created) as invest_order
from (
select a.id,a.borrow_id,a.investor_id,a.capital,interest,loan_fee,invest_way,a.status
,b.borrow_type,b.amount as amount_borrow,b.start_time,b.full_time,b.full_minutes,b.category_cn
,EXTRACT(EPOCH FROM (a.date_created::TIMESTAMP- b.start_time::timestamp)) /60 as investor_minutes
,m.is_inner as is_member_inner
,m.is_recommended
,a.date_created
,date_trunc('day', a.date_created::timestamp) as invest_day
,date_trunc('hour', a.date_created::timestamp) as invest_hour
,EXTRACT(dow FROM a.date_created::timestamp) as invest_dow
,EXTRACT(HOUR FROM a.date_created::timestamp) as invest_hod
from borrow_invest a 
inner join borrow_wide b on a.borrow_id = b.borrow_id
left outer join member_base m on a.investor_id = m.member_id
) a 
) a 
--where date_created>='2017-01-01' and date_created < to_char(now(),'YYYY-MM-DD')
where date_created < to_char(now(),'YYYY-MM-DD')
;

drop table IF EXISTS borrow_invest_wide_bak;
alter table borrow_invest_wide rename to borrow_invest_wide_bak;
alter table borrow_invest_wide_tmp rename to borrow_invest_wide;




