--用户建模数据

-- 用户投资信息
drop table if exists p_member_invest;
create table p_member_invest as 
select investor_id 
,max(a.date_created) as last_invest_date -- 最后一次投标日期
,count(1) as invest_times --投资笔数
,sum(a.capital) as invest_capital -- 投资金额
,sum(case when a.status in (0,1) then a.capital else 0 end)  as oninvest_capital -- 在投金额
,sum(case when cycle_type = 2 and cycle=2 then a.capital else 0 end)  as invest_month_2_capital -- 投资金额_月2
,sum(case when cycle_type = 2 and cycle=3 then a.capital else 0 end)  as invest_month_3_capital -- 投资金额_月3
,sum(case when cycle_type = 2 and cycle=6 then a.capital else 0 end)  as invest_month_6_capital -- 投资金额_月6
,sum(case when cycle_type = 2 and cycle=12 then a.capital else 0 end)  as invest_month_12_capital -- 投资金额_月12
from borrow_invest a
left outer join borrow b on a.borrow_id = b.id
group by investor_id
;

-- 推荐信息
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


-- 用户宽表
/* drop table if exists p_member_wide;
create table p_member_wide as
select a.member_id,reg_time,is_valid_idcard,is_admin,reg_way,is_recommended,is_inner
,s.signin_date
,b.birthday,b.gender
,i.last_invest_date,invest_times,invest_capital,oninvest_capital
,invest_month_2_capital,invest_month_3_capital,invest_month_6_capital,invest_month_12_capital
,case when ri.recommender_id is not null then 1 else 0 end as is_recommender
,case when ri.recommender_id is not null then recommended_num else 0 end as recommended_num
,case when ri.recommender_id is not null then recommended_valid_num else 0 end as recommended_valid_num
,case when ri.recommender_id is not null then recommended_invest_capital else 0 end as recommended_invest_capital
from member_wide a 
left outer join member_info b on a.member_id= b.member_id
left outer join p_member_invest i on a.member_id = i.investor_id
left outer join p_member_recommend_invest ri on a.member_id = ri.recommender_id 
left outer join user_signin s on a.member_id = s.member_id
; */

-- select * from p_member_wide where member_id in (980723,41400);





/* select member_id,birthday
,EXTRACT(EPOCH FROM (now()-birthday::TIMESTAMP)) /3600/24/365 as age
,case when gender ='男' then 1 when gender='女' then 0 else -1 end as gender
from member_info where member_id = 980723 */




