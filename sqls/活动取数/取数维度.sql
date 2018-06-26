
-- vip类型

select member_id,vip_rank,grade_name
from (
select a.id,a.member_id,a.remark,a.begin_date,a.end_date,a.is_end
,b.membervip_id,b.vip_grade_id
,c.grade_name,c.lower,c.upper,c.rank as vip_rank
,ROW_NUMBER() OVER(PARTITION BY a.member_id ORDER BY a.id desc) as  rown
from member_vip a 
inner join vip_association b on a.id=b.membervip_id
inner join vip_grade c on b.vip_grade_id = c.id
) a where rown=1 and is_end=0

-- 最后一次回款

select investor_id,borrow_id,cycle_type,cycle
,issue,capital,interest,should_receipt_balance
,need_receipt_time
,status_receipt,status_borrow
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
) a where rown=1

-- 