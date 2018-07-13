/*
  筛选条件： 当日回款用户前推一周，后推一周都没有回款的用户(限定本金回款)
  用户ID  真实姓名   到期时间 到期金额  到期标的  
  
  SQLSERVER
  
*/

select investor_id as member_id
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as 标类型 -- borrow_type
-- ,issue
,capital as 回款本金 
-- ,interest,should_receipt_balance
,need_receipt_time as 回款时间
-- ,rown
from (
select investor_id,a.borrow_id
,b.cycle_type,b.cycle
,issue,capital,interest,should_receipt_balance
,need_receipt_time
,a.status as status_receipt,b.status as status_borrow
,ROW_NUMBER() OVER(partition by investor_id order by need_receipt_time desc)  as rown 
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
where a.status in (1,4) 
and b.status in (4,5,6)
and need_receipt_time>=convert(varchar(10),GETDATE(),120) and need_receipt_time<convert(varchar(10),DATEADD(dd,1,GETDATE()),120)
and capital>0
) a 
left outer join (
  select distinct investor_id 
  from receipt_detail 
  where status in (1,4) and capital>0
   and ((need_receipt_time>=convert(varchar(10),DATEADD(dd,-8,GETDATE()),120) and need_receipt_time<convert(varchar(10),GETDATE(),120)) 
    or (need_receipt_time>=convert(varchar(10),DATEADD(dd,1,GETDATE()),120) and need_receipt_time<convert(varchar(10),DATEADD(dd,8,GETDATE()),120)) )
) b on a.investor_id=b.investor_id
where a.rown=1 and b.investor_id is null


