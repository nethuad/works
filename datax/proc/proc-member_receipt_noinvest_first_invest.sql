-- 当日最后一笔回款无投资的客户之后的第一笔投资

-- 计算离最后一笔还款的最近一笔投资
drop table if exists member_receipt_noinvest_first_invest;
create table member_receipt_noinvest_first_invest as 
select * from (
select a.*
,b.date_created as date_first_invest
,row_number() over(partition by a.d_stat,a.investor_id order by b.date_created asc) as rown
from member_receipt_noinvest a 
inner join borrow_invest b on a.investor_id=b.investor_id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and b.date_created>=to_char(a.d_stat::timestamp+'1 days'::interval,'YYYY-MM-DD')
) a where rown=1
;

-- 匹配表
drop table if exists member_receipt_noinvest_first_invest_time;
create table member_receipt_noinvest_first_invest_time as 
select a.*
,b.date_first_invest
,EXTRACT(EPOCH FROM (b.date_first_invest::timestamp-a.d_stat::timestamp)) /60/60/24-1 as days_span
from member_receipt_noinvest a 
left outer join member_receipt_noinvest_first_invest b on a.d_stat=b.d_stat and a.investor_id=b.investor_id
;
