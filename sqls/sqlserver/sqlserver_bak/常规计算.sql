use xueshandai

-- 待收本金


DECLARE @end_date varchar(10)
DECLARE @date_mark varchar(10)
DECLARE @end_date_month varchar(10)
SET @date_mark = '2017-07-01'

SET @end_date_month = '2018-05-01'
SET @end_date = '2018-06-01'

select @end_date as report_date
,sum(capital) as capital,sum(interest) as interest,sum(capital+interest) as amount
from (
select a.loaner_id,sum(capital) as capital,sum(interest) as interest
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and (a.status in (1,2) or receipt_time>=@end_date)
group by a.loaner_id
) a 



select @end_date as report_date
,sum(capital) as capital,sum(interest) as interest
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and (a.status in (1,2) or receipt_time>=@end_date)


and ( (need_receipt_time>=@end_date and a.status=1) -- 待还
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --待还已还
   or (need_receipt_time<@end_date and a.status=2) -- 逾期
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- 逾期已还
)


585595965.91


select id,borrow_id,loaner_id,investor_id,capital,interest,sum(a.capital) as capital
into #1


group by investor_id
;

select top 10 * from receipt_detail



select top 10 * from card_coupons_detail where member_id in (980723,748920)


select * from borrow_invest where date_created>='2018-06-08' and capital>400000

select top 10  * from borrow_invest 


select * from borrow_invest where investor_id=86246 order by  id desc 


select * from receipt_detail where investor_id=86246 and capital >0 order by  need_receipt_time desc 

select * from account where member_id = 86246