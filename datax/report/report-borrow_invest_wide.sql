select 'report-borrow_invest_wide.sql' as script;

drop table if exists sp_borrow_invest_wide;
create table sp_borrow_invest_wide as
select *
,case when is_member_inner = 1 then '内投' else '外投' end as invest_member_inout
,case when is_member_inner =1 then '内投' 
 when is_recommended=1 and invest_order=1 and reg_invest_span_days<=30 then '推荐首投_注册30天内'
 when is_recommended=1 and invest_order=1 and reg_invest_span_days>30 then '推荐首投_注册30天之后'
 when  is_recommended=1 and invest_order>1 then '推荐复投'
 when is_recommended=0 and invest_order=1 and reg_invest_span_days<=30 then '普通首投_注册30天内'
 when is_recommended=0 and invest_order=1 and reg_invest_span_days>30 then '普通首投_注册30天之后'
 when  is_recommended=0 and invest_order>1 then '普通复投'
 end as invest_type_30
,borrow_type || '-' || (capital::integer) as borrow_type_capital
,invest_date::timestamp as ts
,to_char(invest_date::timestamp,'YYYY-MM-DD') as d_ts
-- from borrow_invest_wide 
from borrow_invest_wide_correct
where invest_date<to_char(now(),'YYYY-MM-DD')
;
