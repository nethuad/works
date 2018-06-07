-- 用户宽表
drop table if exists p_member_wide;
create table p_member_wide as
select a.member_id,reg_time,is_valid_idcard,is_admin,reg_way,is_recommended,a.recommender_id,is_inner
,b.birthday,b.gender
,i.last_invest_date,invest_times,invest_capital
,invest_capital_days
,invest_capital_days_360
,invest_capital_days_180
,invest_capital_days_90
,oninvest_capital
,invest_month_2_capital,invest_month_3_capital,invest_month_6_capital,invest_month_12_capital
,first_invest_date,first_invest_capital,first_cycle_type,first_cycle
,second_invest_date,second_invest_capital,second_cycle_type,second_cycle
,third_invest_date,third_invest_capital,third_cycle_type,third_cycle
,mr.last_receipt_time
,mr.unreceipt_capital
,case when ri.recommender_id is not null then 1 else 0 end as is_recommender
,case when ri.recommender_id is not null then recommended_num else 0 end as recommended_num
,case when ri.recommender_id is not null then recommended_valid_num else 0 end as recommended_valid_num
,case when ri.recommender_id is not null then recommended_invest_capital else 0 end as recommended_invest_capital
from member_wide a 
left outer join member_info b on a.member_id= b.member_id
left outer join p_member_invest i on a.member_id = i.investor_id
left outer join p_member_recommend_invest ri on a.member_id = ri.recommender_id 
left outer join p_member_receipt_base mr on a.member_id = mr.investor_id
; 



-- 投资用户-画像数据
drop table if exists p_member_draw;
create table p_member_draw as
select member_id
,reg_time,EXTRACT(EPOCH FROM (now()-reg_time::TIMESTAMP)) /3600/24 as reg_days
,is_valid_idcard
,is_admin,reg_way
,is_recommended,recommender_id
,is_inner
,birthday,EXTRACT(EPOCH FROM (now()-birthday::TIMESTAMP)) /3600/24/365 as age
,gender,case when gender ='男' then 1 when gender='女' then 0 else -1 end as sex
,last_invest_date,EXTRACT(EPOCH FROM (now()-last_invest_date::TIMESTAMP)) /3600/24 as last_invest_days
,invest_times
,invest_capital
,invest_capital_days
,invest_capital_days_360
,invest_capital_days_180
,invest_capital_days_90
,oninvest_capital
,invest_month_2_capital
,invest_month_3_capital
,invest_month_6_capital
,invest_month_12_capital
,first_invest_date,first_invest_capital,first_cycle_type,first_cycle
,second_invest_date,second_invest_capital,second_cycle_type,second_cycle
,third_invest_date,third_invest_capital,third_cycle_type,third_cycle
,is_recommender
,recommended_num
,recommended_valid_num
,recommended_invest_capital
,EXTRACT(EPOCH FROM (first_invest_date::TIMESTAMP-reg_time::TIMESTAMP)) /3600/24 as first_span_days
,EXTRACT(EPOCH FROM (second_invest_date::TIMESTAMP-first_invest_date::TIMESTAMP)) /3600/24 as second_span_days
,last_receipt_time
,EXTRACT(EPOCH FROM (last_receipt_time::TIMESTAMP-now())) /3600/24 as to_receipt_days
,coalesce(unreceipt_capital,0) as unreceipt_capital
from p_member_wide
where is_admin=false
and invest_times>0
;



-- 量化数据，只分析投资客户(剔除内投)
drop table if exists p_member_mode;
create table p_member_mode as
select member_id
,reg_time,reg_days
,is_valid_idcard
,is_admin,reg_way
,is_recommended,recommender_id
,is_inner
,birthday,age
,gender,sex
,last_invest_date,last_invest_days
,invest_times
,invest_capital
,invest_capital_days
,invest_capital_days_360
,invest_capital_days_180
,invest_capital_days_90
,oninvest_capital
,invest_month_2_capital
,invest_month_3_capital
,invest_month_6_capital
,invest_month_12_capital
,first_invest_date,first_invest_capital,first_cycle_type,first_cycle
,second_invest_date,second_invest_capital,second_cycle_type,second_cycle
,third_invest_date,third_invest_capital,third_cycle_type,third_cycle
,is_recommender
,recommended_num
,recommended_valid_num
,recommended_invest_capital
,last_receipt_time
,to_receipt_days
,unreceipt_capital
from p_member_draw
where is_inner=0 and is_admin=false
and invest_times>0
and birthday is not null
and gender in ('男','女')
;




-- todo : 首笔投资到期之后的第一笔提现的的时间间隔

