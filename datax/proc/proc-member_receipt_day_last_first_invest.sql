-- 当日最后一笔回款无投资的客户之后的第一笔投资

-- 计算最近一笔投资
drop table if exists member_receipt_day_last_first_invest;
create table member_receipt_day_last_first_invest as 
select * from (
select a.*
,b.date_created as date_first_invest
,to_char(b.date_created::timestamp,'YYYY-MM-DD') as date_first_invest_d
,row_number() over(partition by a.d_stat,a.investor_id order by b.date_created asc) as rown_invest
from member_receipt_day_last a 
inner join borrow_invest b on a.investor_id=b.investor_id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and b.date_created>a.need_receipt_time
) a where rown_invest=1
;

-- 匹配
drop table if exists member_receipt_day_last_first_invest_time;
create table member_receipt_day_last_first_invest_time as 
select a.*
,b.date_first_invest,b.date_first_invest_d
,EXTRACT(DAY FROM (b.date_first_invest_d::timestamp-a.d_stat::timestamp)) as days_span
from member_receipt_day_last a 
left outer join member_receipt_day_last_first_invest b on a.d_stat=b.d_stat and a.investor_id=b.investor_id
;
