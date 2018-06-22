-- psql  -v pt="'20180424'" -f proc-account.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_account_last;
--create table dbo_account_last as 
--select * 
--from dbo_account
--where pt=:pt
--;


drop table IF EXISTS dbo_account_merge;
create table dbo_account_merge as 
select id,member_id,is_freeze,freeze2,date_created,last_updated,created_by,updated_by,version,type,available,data_digest
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_account_last
union all 
select * 
from dbo_account_dadd
) a 
) a where rown = 1
;

--备份 dbo_account_last
drop table IF EXISTS dbo_account_last_bak;
alter table dbo_account_last rename to dbo_account_last_bak;

alter table dbo_account_merge rename to dbo_account_last;

-- 清空增量数据
DELETE FROM dbo_account_dadd;

--account
create table account_tmp as 
select id,member_id,is_freeze,freeze2,date_created,last_updated,created_by,updated_by,version,type,available,data_digest
,pt
from dbo_account_last
;

drop table IF EXISTS account_bak;
alter table account rename to account_bak;
alter table account_tmp rename to account;


