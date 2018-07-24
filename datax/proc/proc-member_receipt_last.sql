-- 昨日最后一笔还款并且没有投资
-- select :dstat as dstat,:dstatnext as dstatnext;


DELETE FROM receipt_detail_mirrow WHERE d_stat=:dstat;

insert into receipt_detail_mirrow
select a.id as receipt_id,a.invest_id,a.borrow_id,a.investor_id,a.capital,a.receipt_time
,a.need_receipt_time
,b.date_created as invest_date
,c.status as borrow_status
,:dstat as d_stat
,to_char(now(),'YYYY-MM-DD') as d_extract
from receipt_detail a 
inner join borrow_invest b on a.invest_id=b.id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and a.capital>0
and (need_receipt_time>=:dstat or need_receipt_time is null)
and b.date_created<:dstatnext
;



DELETE FROM member_receipt_noinvest WHERE d_stat=:dstat;

insert into member_receipt_noinvest
select receipt_id,invest_id,borrow_id,investor_id,capital,receipt_time
,need_receipt_time,invest_date
,borrow_status,d_stat,d_extract
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown
from (
select a.* from (
select *
from receipt_detail_mirrow
where d_stat=:dstat
) a 
left outer join (
select distinct investor_id 
from receipt_detail_mirrow
where d_stat=:dstat
and need_receipt_time is null
) b on a.investor_id=b.investor_id
where b.investor_id is null
) a 
) a where rown=1 and to_char(need_receipt_time::timestamp,'YYYY-MM-DD')=:dstat
;


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


