-- psql  -f 投资与推荐关系.sql "dbname=xueshandai user=xsd password=Xsd123$"

-- 投资基本信息
drop table if exists task1_member_invest_base;
create table task1_member_invest_base as 
select investor_id,cycle_type,cycle,capital,status,invest_date
,row_number() over(partition by investor_id order by invest_date asc) as invest_order
from (
select investor_id
,b.cycle_type,b.cycle  --投资类型
,a.capital  -- 投资金额
,a.status
,a.date_created as invest_date
from borrow_invest a
left outer join borrow b on a.borrow_id = b.id
where a.date_created>='2017-12-01' and a.date_created<'2018-05-01'
) a 
;

-- 用户投资信息
drop table if exists task1_member_invest;
create table task1_member_invest as 
select a.*
,b.invest_date as first_invest_date  -- 首次投标日期
,b.capital as first_invest_capital
,b.cycle_type as first_cycle_type
,b.cycle as first_cycle
,c.invest_date as second_invest_date
,c.capital as second_invest_capital
,c.cycle_type as second_cycle_type
,c.cycle as second_cycle
from ( select investor_id 
,max(invest_date) as last_invest_date -- 最后一次投标日期
,count(1) as invest_times --投资笔数
,sum(capital) as invest_capital -- 投资金额
,sum(case when status in (0,1) then capital else 0 end)  as oninvest_capital -- 在投金额
,sum(case when cycle_type = 2 and cycle=2 then capital else 0 end)  as invest_month_2_capital -- 投资金额_月2
,sum(case when cycle_type = 2 and cycle=3 then capital else 0 end)  as invest_month_3_capital -- 投资金额_月3
,sum(case when cycle_type = 2 and cycle=6 then capital else 0 end)  as invest_month_6_capital -- 投资金额_月6
,sum(case when cycle_type = 2 and cycle=12 then capital else 0 end)  as invest_month_12_capital -- 投资金额_月12
from task1_member_invest_base
group by investor_id
) a 
left outer join (select * from task1_member_invest_base where invest_order=1) b on a.investor_id = b.investor_id
left outer join (select * from task1_member_invest_base where invest_order=2) c on a.investor_id = c.investor_id
;



-- 推荐投资金额
drop table if exists task1_member_recommend_invest;
create table task1_member_recommend_invest as 
select referrer_id as recommender_id
,count(1) as recommended_num
,count(distinct investor_id) as recommended_valid_num
,coalesce(sum(invest_capital),0) as recommended_invest_capital
from recommend a
left outer join task1_member_invest b on a.member_id=b.investor_id
group by referrer_id
;

-- 用户宽表
drop table if exists task1_member_wide;
create table task1_member_wide as
select a.member_id,reg_time,is_valid_idcard,is_admin,reg_way,is_recommended,is_inner
,b.birthday,b.gender
,i.last_invest_date,invest_times,invest_capital,oninvest_capital
,invest_month_2_capital,invest_month_3_capital,invest_month_6_capital,invest_month_12_capital
,first_invest_date,first_invest_capital,first_cycle_type,first_cycle
,second_invest_date,second_invest_capital,second_cycle_type,second_cycle
,case when ri.recommender_id is not null then 1 else 0 end as is_recommender
,case when ri.recommender_id is not null then recommended_num else 0 end as recommended_num
,case when ri.recommender_id is not null then recommended_valid_num else 0 end as recommended_valid_num
,case when ri.recommender_id is not null then recommended_invest_capital else 0 end as recommended_invest_capital
from member_wide a 
left outer join member_info b on a.member_id= b.member_id
left outer join task1_member_invest i on a.member_id = i.investor_id
left outer join task1_member_recommend_invest ri on a.member_id = ri.recommender_id 
; 


/*
select is_recommended
,is_recommender
,COALESCE(invest_times,0) as invest_times
,recommended_num
,recommended_valid_num
,count(1) as c 
,sum(COALESCE(invest_capital,0)) as invest_capital
,sum(recommended_invest_capital) as recommended_invest_capital
from task1_member_wide
where is_inner=0 and is_admin=false
group by 
is_recommended
,is_recommender
,COALESCE(invest_times,0)
,recommended_num
,recommended_valid_num
;
*/
