-- 用户收款数据
drop table if exists p_member_receipt_row_base;
create table p_member_receipt_row_base as 
select borrow_id,investor_id,need_receipt_time,a.capital
,b.cycle_type,b.cycle
,row_number() over(partition by investor_id order by need_receipt_time asc) as receipt_order
,row_number() over(partition by investor_id order by need_receipt_time desc) as receipt_order_desc
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id
where b.status in(4,5,6)
;



drop table if exists p_member_receipt_base;
create table p_member_receipt_base as 
select investor_id
,max(need_receipt_time) as last_receipt_time
,sum(case when receipt_time is null then capital else 0 end ) as unreceipt_capital
from receipt_detail a
inner join borrow b on a.borrow_id=b.id
where b.status in(4,5,6)
group by investor_id
;



