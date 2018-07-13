-- psql  -v pt="'20180424'" -f proc-account_withdraw.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_account_withdraw_last;
--create table dbo_account_withdraw_last as 
--select * 
--from dbo_account_withdraw
--where pt=:pt
--;


drop table IF EXISTS dbo_account_withdraw_merge;
create table dbo_account_withdraw_merge as 
select id,member_id,account_id,cost_id,cash,fee,status,explain,handle_time,bank_name,bank_account,bank_city_id,ip,date_created
,real_name,last_updated,created_by,updated_by,version,handler_id,bank_sub_name,current_success_cash
,balance,remark,merchant_no,trade_no,bank_code,platform_type,withdraw_way
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_account_withdraw_last
union all 
select * 
from dbo_account_withdraw_dadd
) a 
) a where rown = 1
;

--备份 dbo_account_withdraw_last
drop table IF EXISTS dbo_account_withdraw_last_bak;
alter table dbo_account_withdraw_last rename to dbo_account_withdraw_last_bak;

alter table dbo_account_withdraw_merge rename to dbo_account_withdraw_last;

-- 清空增量数据
DELETE FROM dbo_account_withdraw_dadd;

--account_withdraw
create table account_withdraw_tmp as 
select id,member_id,account_id,cost_id,cash,fee,status,explain,handle_time,bank_name,bank_account,bank_city_id,ip,date_created
,real_name,last_updated,created_by,updated_by,version,handler_id,bank_sub_name,current_success_cash
,balance,remark,merchant_no,trade_no,bank_code,platform_type,withdraw_way
,pt
from dbo_account_withdraw_last
;

drop table IF EXISTS account_withdraw_bak;
alter table account_withdraw rename to account_withdraw_bak;
alter table account_withdraw_tmp rename to account_withdraw;


