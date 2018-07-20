--借款人-现金流水 sp_loaner_capital_flow
-- 目前只统计有满标的标，未统计投标计息的标
-- 2018年之后

drop table IF EXISTS sp_loaner_capital_flow;
create table sp_loaner_capital_flow as 

select 
d
,loaner_id,capital_loan,capital_repay,capital_in
,d::timestamp as ts
from (
    
select 
coalesce(a.d,b.d) as d
,coalesce(a.loaner_id,b.member_id) as loaner_id
,coalesce(a.amount,0) as capital_loan
,coalesce(b.total,0) as capital_repay
,coalesce(a.amount,0)-coalesce(b.total,0) as capital_in
from (
select loaner_id
,to_char(full_time::timestamp,'YYYY-MM-DD') as d
,sum(amount) as amount
from borrow 
where status in (4,5,6)
and full_time>='2018-01-01' and full_time<to_char(now(),'YYYY-MM-DD')
group by loaner_id,to_char(full_time::timestamp,'YYYY-MM-DD')
) a 
full join (
select to_char(repay_time::timestamp,'YYYY-MM-DD') as d 
,member_id
,sum(total) as total
from repayment_history
where repay_time>='2018-01-01' and repay_time<to_char(now(),'YYYY-MM-DD')
group by member_id,to_char(repay_time::timestamp,'YYYY-MM-DD')
) b on a.d = b.d and a.loaner_id = b.member_id
) a 
;


