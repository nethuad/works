
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


-- 待收余额，根据满标计算

DECLARE @end_date varchar(10)
SET @end_date = '2018-05-01'

select @end_date as stat_date,investor_id,sum(a.capital) as balance
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6) and b.full_time <@end_date
and ( (need_receipt_time>=@end_date and a.status=1) --待收
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --已还，截止日期之后还的
   or (need_receipt_time<@end_date and a.status=2) -- 截止日期之前需还，但是目前逾期的
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- 截止日期之前需还，但是截止日期之后还的（逾期还款）
)
group by investor_id

-- 过期的新手红包
select distinct member_id
from card_coupons_detail a 
inner join card_coupons_batch b on a.batch_id=b.id
where b.prefix in ('0416','0417','0417','0418','0419','0420','0421','0422')
and (a.status=3 or (a.status =0 and a.invalid_date<getdate())) -- 根据状态以及失效时间判断

