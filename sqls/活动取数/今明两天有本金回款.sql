/*
  今明两天有本金回款
*/

select investor_id as member_id
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as borrow_type
,issue,capital,interest,should_receipt_balance
,need_receipt_time
,rown
,case when rown=1 then '最后一笔回款' else '' end as 回款
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
and b.status in (1,4,5,6)
and need_receipt_time>=convert(varchar(10),GETDATE(),120)
and capital>0
) a where need_receipt_time>=convert(varchar(10),GETDATE(),120) and need_receipt_time<convert(varchar(10),DATEADD(dd,2,GETDATE()),120)
order by investor_id,rown

