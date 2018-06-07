--还款流水 capital_repayment_report

drop table IF EXISTS capital_repayment_report;

create table capital_repayment_report as 
select a.*,substring(need_repayment_time from 1 for 10 )::timestamp as need_repay_time
,case when repayment_time is null then 0 else capital end as capital_repayment
,capital-case when repayment_time is null then 0 else capital end as capital_unrepayment
from repayment_detail a 
inner join borrow b on a.borrow_id=b.id 
where need_repayment_time>='2018-01-01'
and b.status in (4,5,6)
;
