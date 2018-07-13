-- psql  -v pt="'20180424'" -f proc-account_recharge.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_account_recharge_last;
--create table dbo_account_recharge_last as 
--select * 
--from dbo_account_recharge
--where pt=:pt
--;


drop table IF EXISTS dbo_account_recharge_merge;
create table dbo_account_recharge_merge as 
select id,member_id,account_id,cost_id,charge_type,cash,prize_cash,fee,charge_status,explain,pay_tran_no,bank_name,bank_account,bank_city_id
,charge_way,ip,is_manual,reason,date_created,last_updated,created_by,updated_by,version,gopay_tran_date_time,handle_time,handler_id
,bank_city,order_no,check_original_result,check_status,check_date,check_result,check_by_admin_remark,check_by_admin_fix_status
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_account_recharge_last
union all 
select * 
from dbo_account_recharge_dadd
) a 
) a where rown = 1
;

--备份 dbo_account_recharge_last
drop table IF EXISTS dbo_account_recharge_last_bak;
alter table dbo_account_recharge_last rename to dbo_account_recharge_last_bak;

alter table dbo_account_recharge_merge rename to dbo_account_recharge_last;

-- 清空增量数据
DELETE FROM dbo_account_recharge_dadd;

--account_recharge
create table account_recharge_tmp as 
select id,member_id,account_id,cost_id,charge_type,cash,prize_cash,fee,charge_status,explain,pay_tran_no,bank_name,bank_account,bank_city_id
,charge_way,ip,is_manual,reason,date_created,last_updated,created_by,updated_by,version,gopay_tran_date_time,handle_time,handler_id
,bank_city,order_no,check_original_result,check_status,check_date,check_result,check_by_admin_remark,check_by_admin_fix_status
,pt
from dbo_account_recharge_last
;

drop table IF EXISTS account_recharge_bak;
alter table account_recharge rename to account_recharge_bak;
alter table account_recharge_tmp rename to account_recharge;


