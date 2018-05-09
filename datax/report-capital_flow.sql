--借贷流水 capital_flow_report

drop table IF EXISTS capital_flow_report;

create table capital_flow_report as 
select 
--to_date(coalesce(a.full_day,b.repay_day),'YYYY-MM-DD') as d
coalesce(a.full_day,b.repay_day) as d
,coalesce(a.capital_borrow,0) as capital_borrow
,coalesce(b.capital_repay,0) as capital_repay
,coalesce(a.capital_borrow,0)-coalesce(b.capital_repay,0) as capital_in
from (
select to_char(full_time::timestamp,'YYYY-MM-DD') as full_day 
,sum(amount) as capital_borrow
from borrow
where full_time>='2017-01-01' and full_time<to_char(now(),'YYYY-MM-DD')
group by to_char(full_time::timestamp,'YYYY-MM-DD')
) a 
full join (
select to_char(repay_time::timestamp,'YYYY-MM-DD') as repay_day 
,sum(capital) as capital_repay
from repayment_history
where repay_time>='2017-01-01' and repay_time<to_char(now(),'YYYY-MM-DD')
group by to_char(repay_time::timestamp,'YYYY-MM-DD')
) b on a.full_day = b.repay_day
;
