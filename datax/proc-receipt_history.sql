-- psql  -v pt="'20180424'" -f proc-receipt_history.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_receipt_history_last;
--create table dbo_receipt_history_last as 
--select * 
--from dbo_receipt_history
--where pt=:pt
--;


drop table IF EXISTS dbo_receipt_history_merge;
create table dbo_receipt_history_merge as 
select id,version,borrow_id,capital,interest,investor_id,is_proxy_repay,member_overdue_fee
,receipt_id,receipt_time,repay_history_id,total
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_receipt_history_last
union all 
select * 
from dbo_receipt_history_dadd
) a 
) a where rown = 1
;

--备份 dbo_receipt_history_last
drop table IF EXISTS dbo_receipt_history_last_bak;
alter table dbo_receipt_history_last rename to dbo_receipt_history_last_bak;

alter table dbo_receipt_history_merge rename to dbo_receipt_history_last;

-- 清空增量数据
DELETE FROM dbo_receipt_history_dadd;

--receipt_history
create table receipt_history_tmp as 
select id,version,borrow_id,capital,interest,investor_id,is_proxy_repay,member_overdue_fee
,receipt_id,receipt_time,repay_history_id,total
,pt
from dbo_receipt_history_last
;

drop table IF EXISTS receipt_history_bak;
alter table receipt_history rename to receipt_history_bak;
alter table receipt_history_tmp rename to receipt_history;


