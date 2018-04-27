-- psql  -v pt="'20180424'" -f proc-repayment_detail.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_repayment_detail_last;
--create table dbo_repayment_detail_last as 
--select * 
--from dbo_repayment_detail
--where pt=:pt
--;


drop table IF EXISTS dbo_repayment_detail_merge;
create table dbo_repayment_detail_merge as 
select id,invest_id,borrow_id,capital,interest,repayment_time,need_repayment_time,need_overdue_time,is_be_overdue,is_proxy_repay
,status,member_id,issue,date_created,last_updated,created_by,updated_by,version,cost_id,repay_type,is_overdue_repay
,is_be_overdueing,is_displace_repay,is_displaced,overdue_time,should_repay_balance,should_repay_fee,fact_repay_balance
,fact_repay_fee,displace_type,repay_process,newly_overdue_time,displace_status,displace_money
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_repayment_detail_last
union all 
select * 
from dbo_repayment_detail_dadd
) a 
) a where rown = 1
;

--备份 dbo_repayment_detail_last
drop table IF EXISTS dbo_repayment_detail_last_bak;
alter table dbo_repayment_detail_last rename to dbo_repayment_detail_last_bak;

alter table dbo_repayment_detail_merge rename to dbo_repayment_detail_last;

-- 清空增量数据
DELETE FROM dbo_repayment_detail_dadd;

--repayment_detail
create table repayment_detail_tmp as 
select id,invest_id,borrow_id,capital,interest,repayment_time,need_repayment_time,need_overdue_time,is_be_overdue,is_proxy_repay
,status,member_id,issue,date_created,last_updated,created_by,updated_by,version,cost_id,repay_type,is_overdue_repay
,is_be_overdueing,is_displace_repay,is_displaced,overdue_time,should_repay_balance,should_repay_fee,fact_repay_balance
,fact_repay_fee,displace_type,repay_process,newly_overdue_time,displace_status,displace_money
,pt
from dbo_repayment_detail_last
;

drop table IF EXISTS repayment_detail_bak;
alter table repayment_detail rename to repayment_detail_bak;
alter table repayment_detail_tmp rename to repayment_detail;


