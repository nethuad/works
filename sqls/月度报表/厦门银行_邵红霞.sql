use xueshandai

select getdate() as getdate
,count(distinct case when a.status in (1,2) then investor_id else null end) as 出借人数＿待收
,sum(case when a.status in (1,2) then capital else 0 end) as 出借金额＿待收本金
,count(distinct case when a.status in (2) then investor_id else null end) as 逾期人数
,sum(case when a.status in (2) then capital else 0 end) as 逾期金额＿逾期本金
,sum(case when a.status in (1,2) then should_receipt_balance else 0 end) as should_receipt_balance
,sum(case when a.status in (2) then should_receipt_balance-fact_receipt_balance else 0 end) as due_receipt_balance
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)