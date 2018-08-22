select investor_id as member_id
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as 最后一笔回款标类型
,need_receipt_time as 最后一笔回款时间
,capital as 最后一笔回款本金
from (
select investor_id,a.borrow_id
,b.cycle_type,b.cycle
,issue,capital,interest,should_receipt_balance
,need_receipt_time
,a.status as status_receipt,b.status as status_borrow
,ROW_NUMBER() OVER(partition by investor_id order by need_receipt_time desc)  as rown 
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
where a.status in (1,2,4) 
and b.status in (4,5,6)
and capital>0
) a where need_receipt_time<convert(varchar(10),GETDATE(),120)
and rown=1


-- 流失客户，最后一笔回款>100,
select investor_id as member_id
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as 最后一笔回款标类型
,need_receipt_time as 最后一笔回款时间
,capital as 最后一笔回款本金
from (
select investor_id,a.borrow_id
,b.cycle_type,b.cycle
,issue,capital,interest,should_receipt_balance
,need_receipt_time
,a.status as status_receipt,b.status as status_borrow
,ROW_NUMBER() OVER(partition by investor_id order by need_receipt_time desc)  as rown 
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
where a.status in (1,2,4) 
and b.status in (4,5,6)
and capital>100
) a where need_receipt_time<'2017-08-01'
and rown=1