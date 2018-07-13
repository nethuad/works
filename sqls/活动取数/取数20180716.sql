1) 投资在2018年6月16日至2018年6月25日的用户


select distinct investor_id as member_id
from borrow_invest a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6) 
and a.date_created >='2018-06-16' and a.date_created<'2018-06-26'



2) 最后一笔回款在2017年1月1日至2018年5月30日的用户
select investor_id as member_id,need_receipt_time_max as 最后一笔回款时间
from (
select investor_id,max( need_receipt_time) as need_receipt_time_max
from receipt_detail 
where status in (1,4)
group by investor_id
) a 
where need_receipt_time_max>='2017-01-01' and need_receipt_time_max<'2018-06-01'

