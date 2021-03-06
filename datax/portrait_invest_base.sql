-- 用户投资基础信息
drop table if exists p_member_invest_base;
create table p_member_invest_base as 
select investor_id,cycle_type,cycle,capital,status,invest_date
,row_number() over(partition by investor_id order by invest_date asc) as invest_order
,row_number() over(partition by investor_id order by invest_date desc) as invest_order_desc
from (
select investor_id
,b.cycle_type,b.cycle  --投资类型
,a.capital  -- 投资金额
,a.status
,a.date_created as invest_date
from borrow_invest a
left outer join borrow b on a.borrow_id = b.id
) a 
;

-- 用户投资信息
drop table if exists p_member_invest;
create table p_member_invest as 
select a.*
,b1.invest_date as first_invest_date  -- 首次投标日期
,b1.capital as first_invest_capital
,b1.cycle_type as first_cycle_type
,b1.cycle as first_cycle
,b2.invest_date as second_invest_date
,b2.capital as second_invest_capital
,b2.cycle_type as second_cycle_type
,b2.cycle as second_cycle
,b3.invest_date as third_invest_date
,b3.capital as third_invest_capital
,b3.cycle_type as third_cycle_type
,b3.cycle as third_cycle
,c1.invest_date as last_invest_date  -- 最后一次投标日期
,c1.capital as last_invest_capital
,c1.cycle_type as last_cycle_type
,c1.cycle as last_cycle
from ( select investor_id 
,count(1) as invest_times --投资笔数
,sum(capital) as invest_capital -- 投资金额
,sum(case when status in (0,1) then capital else 0 end)  as oninvest_capital -- 在投金额
,sum(case when cycle_type = 2 and cycle=2 then capital else 0 end)  as invest_month_2_capital -- 投资金额_月2
,sum(case when cycle_type = 2 and cycle=3 then capital else 0 end)  as invest_month_3_capital -- 投资金额_月3
,sum(case when cycle_type = 2 and cycle=6 then capital else 0 end)  as invest_month_6_capital -- 投资金额_月6
,sum(case when cycle_type = 2 and cycle=12 then capital else 0 end)  as invest_month_12_capital -- 投资金额_月12
,sum((case when cycle_type = 2 then cycle*30 else cycle end)*capital) as invest_capital_days -- 投资金额*天数
,sum(case when (now()::date -invest_date::timestamp::date) <= 360 then (case when cycle_type = 2 then cycle*30 else cycle end)*capital else 0 end) as invest_capital_days_360 -- 360天内的投资金额*天数
,sum(case when (now()::date -invest_date::timestamp::date) <= 180 then (case when cycle_type = 2 then cycle*30 else cycle end)*capital else 0 end) as invest_capital_days_180 -- 180天内的投资金额*天数
,sum(case when (now()::date -invest_date::timestamp::date) <= 90 then (case when cycle_type = 2 then cycle*30 else cycle end)*capital else 0 end) as invest_capital_days_90 -- 90天内的投资金额*天数
from p_member_invest_base
group by investor_id
) a 
left outer join (select * from p_member_invest_base where invest_order=1) b1 on a.investor_id = b1.investor_id
left outer join (select * from p_member_invest_base where invest_order=2) b2 on a.investor_id = b2.investor_id
left outer join (select * from p_member_invest_base where invest_order=3) b3 on a.investor_id = b3.investor_id -- 第三次投资
left outer join (select * from p_member_invest_base where invest_order_desc=1) c1 on a.investor_id = c1.investor_id -- 最后一次投资
;



-- 推荐投资金额
drop table if exists p_member_recommend_invest;
create table p_member_recommend_invest as 
select referrer_id as recommender_id
,count(1) as recommended_num
,count(distinct investor_id) as recommended_valid_num
,coalesce(sum(invest_capital),0) as recommended_invest_capital
from recommend a
left outer join p_member_invest b on a.member_id=b.investor_id
group by referrer_id
;


