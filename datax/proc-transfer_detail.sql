-- psql  -v pt="'20180424'" -f proc-transfer_detail.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_transfer_detail_last;
--create table dbo_transfer_detail_last as 
--select * 
--from dbo_transfer_detail
--where pt=:pt
--;


drop table IF EXISTS dbo_transfer_detail_merge;
create table dbo_transfer_detail_merge as 
select id,version,capital,capital_type,created_by,date_created,description,explain,handle_time,handler_id,ip
,last_updated,payer_id,receiver_id,transfer_time,updated_by
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_transfer_detail_last
union all 
select * 
from dbo_transfer_detail_dadd
) a 
) a where rown = 1
;

--备份 dbo_transfer_detail_last
drop table IF EXISTS dbo_transfer_detail_last_bak;
alter table dbo_transfer_detail_last rename to dbo_transfer_detail_last_bak;

alter table dbo_transfer_detail_merge rename to dbo_transfer_detail_last;

-- 清空增量数据
DELETE FROM dbo_transfer_detail_dadd;

--transfer_detail
create table transfer_detail_tmp as 
select id,version,capital,capital_type,created_by,date_created,description,explain,handle_time,handler_id,ip
,last_updated,payer_id,receiver_id,transfer_time,updated_by
,pt
from dbo_transfer_detail_last
;

drop table IF EXISTS transfer_detail_bak;
alter table transfer_detail rename to transfer_detail_bak;
alter table transfer_detail_tmp rename to transfer_detail;


