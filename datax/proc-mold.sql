-- psql  -v pt="'20180424'" -f proc-mold.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_mold_last;
--create table dbo_mold_last as 
--select * 
--from dbo_mold
--where pt=:pt
--;


drop table IF EXISTS dbo_mold_merge;
create table dbo_mold_merge as 
select id,version,code,created_by,date_created,last_updated,name,updated_by
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_mold_last
union all 
select * 
from dbo_mold_dadd
) a 
) a where rown = 1
;

--备份 dbo_mold_last
drop table IF EXISTS dbo_mold_last_bak;
alter table dbo_mold_last rename to dbo_mold_last_bak;

alter table dbo_mold_merge rename to dbo_mold_last;

-- 清空增量数据
DELETE FROM dbo_mold_dadd;

--mold
create table mold_tmp as 
select id,version,code,created_by,date_created,last_updated,name,updated_by
,pt
from dbo_mold_last
;

drop table IF EXISTS mold_bak;
alter table mold rename to mold_bak;
alter table mold_tmp rename to mold;


