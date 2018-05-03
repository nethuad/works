-- psql  -v pt="'20180424'" -f proc-receipt_detail.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_receipt_detail_last;
--create table dbo_receipt_detail_last as 
--select * 
--from dbo_receipt_detail
--where pt=:pt
--;


drop table IF EXISTS dbo_receipt_detail_merge;
create table dbo_receipt_detail_merge as 
select id,invest_id,borrow_id,investor_id,loaner_id,capital,interest,receipt_time,need_receipt_time,interest_cost_fee,need_overdue
,issue,is_be_overdue,status,date_created,last_updated,created_by,updated_by,version,overdue_time,receipt_type,should_receipt_balance
,should_receipt_fee,fact_receipt_balance,fact_receipt_fee,displace_type,receipt_process,is_proxy_repay,is_overdue_repay,capital_type
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_receipt_detail_last
union all 
select * 
from dbo_receipt_detail_dadd
) a 
) a where rown = 1
;

--备份 dbo_receipt_detail_last
drop table IF EXISTS dbo_receipt_detail_last_bak;
alter table dbo_receipt_detail_last rename to dbo_receipt_detail_last_bak;

alter table dbo_receipt_detail_merge rename to dbo_receipt_detail_last;

-- 清空增量数据
DELETE FROM dbo_receipt_detail_dadd;

--receipt_detail
create table receipt_detail_tmp as 
select id,invest_id,borrow_id,investor_id,loaner_id,capital,interest,receipt_time,need_receipt_time,interest_cost_fee,need_overdue
,issue,is_be_overdue,status,date_created,last_updated,created_by,updated_by,version,overdue_time,receipt_type,should_receipt_balance
,should_receipt_fee,fact_receipt_balance,fact_receipt_fee,displace_type,receipt_process,is_proxy_repay,is_overdue_repay,capital_type
,pt
from dbo_receipt_detail_last
;

drop table IF EXISTS receipt_detail_bak;
alter table receipt_detail rename to receipt_detail_bak;
alter table receipt_detail_tmp rename to receipt_detail;


