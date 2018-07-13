drop table if exists sp_balance_investor_day_investortype;
create table sp_balance_investor_day_investortype as
select *
,case when investor_type='outer' then capital else 0 end as capital_outer
,case when investor_type='outer' then should_receipt_balance else 0 end as should_receipt_balance_outer
,cast(d as timestamp) as dtime
from balance_investor_day_investortype
;


