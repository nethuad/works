-- 用户宽表
drop table if exists portrait_member_wide;
create table portrait_member_wide as
select a.id as member_id
,real_name,uname,username,mobile,idcard,a.reg_time,is_valid_idcard
,case when reg_way like 'Android%' then 'Android' else reg_way end as reg_way
,case when r.member_id is not null then 1 else 0 end as is_recommended
,r.referrer_id as recommender_id
,case when mid.member_id is not null then 1 else 0 end as is_identified
,case when mid.member_id is not null then mid.date_identified else null end as date_identified
,mv.grade_name
,mi.birthday,mi.age,mi.gender,mi.current_address
,case when bi_t.investor_id is not null then 1 else 0 end as is_investor
,bi_t.invest_times as invest_times
,bi_t.invest_capital as invest_capital
,bi_f.borrow_type as borrow_type_firstinvest
,bi_f.capital as capital_firstinvest
,bi_f.invest_date as first_invest_date
,bi_f.reg_invest_span_days as reg_invest_span_days_firstinvest
from member a
left outer join recommend r on a.id=r.member_id
left outer join (select * from borrow_invest_wide_correct where invest_order=1) bi_f on a.id=bi_f.investor_id
left outer join (select investor_id,count(1) as invest_times,sum(capital) as invest_capital 
    from borrow_invest_wide_correct group by investor_id) bi_t on a.id=bi_t.investor_id
left outer join member_identify mid on a.id=mid.member_id
left outer join member_vip_map mv on a.id=mv.member_id
left outer join member_info_map mi on mid.member_id=mi.member_id  --根据认证结果匹配用户信息表
;


drop table portrait_member_wide_analys;
create table portrait_member_wide_analys as 
select member_id,real_name,uname,username
,reg_time,is_valid_idcard,reg_way,is_recommended,recommender_id,is_identified,date_identified
,grade_name,birthday,age,gender,idcard_region
,is_investor,invest_times,invest_capital,borrow_type_firstinvest,capital_firstinvest,first_invest_date
from portrait_member_wide
;



-- select a.member_id,real_name,uname,username,mobile,idcard,reg_time,is_valid_idcard,is_admin,reg_way,is_recommended,a.recommender_id,is_inner
-- ,b.birthday,b.gender
-- ,ma.cash_available,ma.cash_freeze
-- ,last_invest_date,last_invest_capital,last_cycle_type,last_cycle
-- ,invest_times,invest_capital
-- ,invest_capital_days
-- ,invest_capital_days_360
-- ,invest_capital_days_180
-- ,invest_capital_days_90
-- ,oninvest_capital
-- ,invest_month_2_capital,invest_month_3_capital,invest_month_6_capital,invest_month_12_capital
-- ,first_invest_date,first_invest_capital,first_cycle_type,first_cycle
-- ,second_invest_date,second_invest_capital,second_cycle_type,second_cycle
-- ,third_invest_date,third_invest_capital,third_cycle_type,third_cycle
-- ,mr.unreceipt_capital
-- ,mrl.need_receipt_time as last_receipt_time
-- ,mrl.capital as last_receipt_capital
-- ,mrl.cycle_type as last_receipt_cycle_type
-- ,mrl.cycle as last_receipt_cycle
-- ,case when ri.recommender_id is not null then 1 else 0 end as is_recommender
-- ,case when ri.recommender_id is not null then recommended_num else 0 end as recommended_num
-- ,case when ri.recommender_id is not null then recommended_valid_num else 0 end as recommended_valid_num
-- ,case when ri.recommender_id is not null then recommended_invest_capital else 0 end as recommended_invest_capital
-- from member_wide a 
-- left outer join member_info b on a.member_id= b.member_id
-- left outer join p_member_account_base ma on a.member_id = ma.member_id
-- left outer join p_member_invest i on a.member_id = i.investor_id
-- left outer join p_member_recommend_invest ri on a.member_id = ri.recommender_id 
-- left outer join p_member_receipt_base mr on a.member_id = mr.investor_id
-- left outer join (select * from p_member_receipt_row_base where receipt_order_desc=1) mrl on a.member_id = mrl.investor_id
-- ; 


