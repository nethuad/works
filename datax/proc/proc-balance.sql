-- 待收余额
drop table if exists balance_investor_day_investortype;
create table balance_investor_day_investortype as 
select a.*
,case when b.member_id is null then 'outer' else 'inner' end as investor_type
from balance_investor_day a 
left outer join member_inner b on a.investor_id=b.member_id
;

/*
select 
from (
select investor_id,max(capital) as capital_max
from balance_investor_day_investortype
where investor_type='outer'
and d>='2017-01-01'
group by investor_id
) a where capital_max>50000
;

*/

-- 待收余额去除内部标
drop table if exists balance_investor_day_investortype_correct;
create table balance_investor_day_investortype_correct as 
select a.*
,case when b.member_id is null then 'outer' else 'inner' end as investor_type
from balance_investor_day_correct a 
left outer join member_inner b on a.investor_id=b.member_id
;