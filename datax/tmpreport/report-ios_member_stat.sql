drop table if exists sp_ios_member_stat;
create table sp_ios_member_stat as
select a.d
,coalesce(b1.reg_num,0) as reg_num
,coalesce(b1.identor_num,0) as identor_num
,coalesce(b1.first_invest_num,0) as first_invest_num
,coalesce(b1.first_invest_capital,0) as first_invest_capital
,coalesce(b1.invest_capital,0) as invest_capital
,coalesce(b2.ondate_identor_num,0) as ondate_identor_num
,coalesce(b3.ondate_first_investor_num,0) as ondate_first_investor_num
,coalesce(b3.ondate_first_invest_capital,0) as ondate_first_invest_capital
,a.d::timestamp as ts
,to_char(a.d::timestamp,'YYYY-MM-DD') as d_ts
from (
select distinct d from (
select to_char(reg_time::timestamp,'YYYY-MM-DD') as d
from portrait_member_wide 
where reg_time>='2018-08-01'
union all 
select to_char(date_identified::timestamp,'YYYY-MM-DD') as d
from portrait_member_wide 
where date_identified>='2018-08-01'
union all 
select to_char(first_invest_date::timestamp,'YYYY-MM-DD') as d
from portrait_member_wide 
where first_invest_date>='2018-08-01'
) a 
) a 
left outer join (
select to_char(reg_time::timestamp,'YYYY-MM-DD') as d
,count(1) as reg_num   --注册人数
,sum(is_identified) as identor_num -- 实名人数
,sum(is_investor) as first_invest_num      -- 投资人数
,sum(capital_firstinvest) as first_invest_capital     -- 首投金额
,sum(invest_capital) as invest_capital -- 投资金额
from portrait_member_wide 
where reg_way in ('IOS')
and reg_time>='2018-08-01'
group by to_char(reg_time::timestamp,'YYYY-MM-DD')
) b1 on a.d=b1.d
left outer join (
select to_char(date_identified::timestamp,'YYYY-MM-DD') as d
,count(1) as ondate_identor_num
from portrait_member_wide 
where reg_way in ('IOS')
and date_identified>='2018-08-01'
group by to_char(date_identified::timestamp,'YYYY-MM-DD')
) b2 on a.d=b2.d
left outer join (
select to_char(first_invest_date::timestamp,'YYYY-MM-DD') as d
,count(1) as ondate_first_investor_num
,sum(capital_firstinvest) as ondate_first_invest_capital
from portrait_member_wide 
where reg_way in ('IOS')
and first_invest_date>='2018-08-01'
group by to_char(first_invest_date::timestamp,'YYYY-MM-DD')
) b3 on a.d=b3.d
;