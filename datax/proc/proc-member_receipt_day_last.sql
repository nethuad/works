select  :dmirror as dmirror,:dstat as dstat;

-- 当天的最后一笔回款
-- drop table member_receipt_day_last;
-- create table member_receipt_day_last as 

DELETE FROM member_receipt_day_last WHERE d_stat=:dstat;
insert into member_receipt_day_last

select receipt_id,invest_id,borrow_id,investor_id,capital,need_receipt_time,invest_date
,rown,rown2
,case when rown=1 then 1 else 0 end as is_last --是否最后一笔汇款
,to_char(now(),'YYYY-MM-DD') as d_stat
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown2
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown
from receipt_detail_mirrow
where d_stat = :dmirror
) a 
where to_char(need_receipt_time::timestamp,'YYYY-MM-DD')=:dstat
) a 
where rown2=1
;



-- 回款打上标签
-- drop table if exists member_receipt_day_tag;
-- create table member_receipt_day_tag as 

DELETE FROM member_receipt_day_tag WHERE d_stat=:dstat;
insert into member_receipt_day_tag

select receipt_id,invest_id,borrow_id,investor_id,capital,need_receipt_time,invest_date
,rown,rown2
,case when rown=1 then 1 else 0 end as is_last --是否最后一笔汇款
,to_char(now(),'YYYY-MM-DD') as d_stat
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown2
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown
from receipt_detail_mirrow
where d_stat = :dmirror
) a 
where to_char(need_receipt_time::timestamp,'YYYY-MM-DD')=:dstat
) a 
;



 
