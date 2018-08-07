select a.investor_id as member_id
,a.should_receipt_balance as 待收总额
,b.date_created as 最近一次投资时间
,b.borrow_type as 最近一次投资标类型
,b.capital as 最近一次投资金额
from (
select investor_id,sum(should_receipt_balance) as should_receipt_balance
from receipt_detail
where status in (1)
group by investor_id
) a 
inner join (
select * from (
select a.*
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as borrow_type
,ROW_NUMBER() over(partition by investor_id order by a.date_created desc ) as rown
from borrow_invest a 
inner join borrow b on a.borrow_id =b.id 
where b.status in (4,5,6)
) a where rown=1
) b on a.investor_id=b.investor_id
left outer join member_xmgj_transfer c1 on a.investor_id=c1.member_id
left outer join member_xmgj_zhaiquan c2 on a.investor_id=c2.payer_id
where not(c1.member_id is not null and c2.payer_id is null)





