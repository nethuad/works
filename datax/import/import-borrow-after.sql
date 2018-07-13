-- psql  -v pt="'20180424'" -f proc-borrow.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_borrow_last;
--create table dbo_borrow_last as 
--select * 
--from dbo_borrow
--where pt=:pt
--;


drop table IF EXISTS dbo_borrow_merge;
create table dbo_borrow_merge as 
select id,loaner_id,post_id,post_time,name,logo,category,status,full_time
,amount,interest_total,rate,is_display,invest_process
,repay_process,is_be_overdue,cycle_type,cycle,repay_type,fund_cycle_type
,fund_cycle,deadline,is_reward,reward_rate,loaner_fee_total
,interest_fee_total,loaner_cost_id,ip,auditing_member_id,auditing_remark
,description,issues,portal_weight,issued,date_created,last_updated
,created_by,updated_by,version,last_payment,is_vip,fund_deadline
,last_check_fail_date,last_check_success_date,check_result_status,next_repay_time
,min_invest_day,interest_type,is_settlement,trade_out,surplus
,is_pause,need_settlement_date,loaner_total,trade_in,invest_max,invest_min
,settlement_date,keyword,is_be_overdueing,run_off_date,receipt_id,assure_type
,assure_description,assure_company,category_type,contract,description_for_seo
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_borrow_last
union all 
select * 
from dbo_borrow_dadd
) a 
) a where rown = 1
;

--备份 dbo_borrow_last
drop table IF EXISTS dbo_borrow_last_bak;
alter table dbo_borrow_last rename to dbo_borrow_last_bak;

alter table dbo_borrow_merge rename to dbo_borrow_last;

-- 清空增量数据
DELETE FROM dbo_borrow_dadd;

--borrow
create table borrow_tmp as 
select id,loaner_id,post_id,post_time,name,logo,category,status,full_time
,amount,interest_total,rate,is_display,invest_process
,repay_process,is_be_overdue,cycle_type,cycle,repay_type,fund_cycle_type
,fund_cycle,deadline,is_reward,reward_rate,loaner_fee_total
,interest_fee_total,loaner_cost_id,ip,auditing_member_id,auditing_remark
,description,issues,portal_weight,issued,date_created,last_updated
,created_by,updated_by,version,last_payment,is_vip,fund_deadline
,last_check_fail_date,last_check_success_date,check_result_status,next_repay_time
,min_invest_day,interest_type,is_settlement,trade_out,surplus
,is_pause,need_settlement_date,loaner_total,trade_in,invest_max,invest_min
,settlement_date,keyword,is_be_overdueing,run_off_date,receipt_id,assure_type
,assure_description,assure_company,category_type,contract,description_for_seo
,pt
from dbo_borrow_last
;

drop table IF EXISTS borrow_bak;
alter table borrow rename to borrow_bak;
alter table borrow_tmp rename to borrow;


