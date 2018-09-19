--投资人-现金流水 sp_investor_capital_flow
drop table IF EXISTS sp_investor_capital_flow;
create table sp_investor_capital_flow as 

select a.d as d_ts
,cast(a.d as timestamp) as ts
,a.investor_id,a.capital_invest,a.capital_receipt,a.capital_in
,case when b.member_id is null then 'outer' else 'inner' end as investor_type
from (
    
select 
coalesce(a.d,b.d) as d
,coalesce(a.investor_id,b.investor_id) as investor_id
,coalesce(a.capital,0) as capital_invest
,coalesce(b.total,0) as capital_receipt
,coalesce(a.capital,0)-coalesce(b.total,0) as capital_in
from (
select to_char(a.date_created::timestamp,'YYYY-MM-DD') as d
,investor_id
,sum(capital) as capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (1,4,5,6)
and a.date_created>='2018-01-01' and a.date_created<to_char(now(),'YYYY-MM-DD')
group by to_char(a.date_created::timestamp,'YYYY-MM-DD'),investor_id
) a 
full join (
select to_char(receipt_time::timestamp,'YYYY-MM-DD') as d 
,investor_id
,sum(fact_receipt_balance+fact_receipt_fee) as total
from receipt_detail
where status in (4) 
and (receipt_time>='2018-01-01' and receipt_time<to_char(now(),'YYYY-MM-DD'))
group by to_char(receipt_time::timestamp,'YYYY-MM-DD'),investor_id
) b on a.d = b.d and a.investor_id = b.investor_id

) a 
left outer join member_inner b on a.investor_id=b.member_id
;


