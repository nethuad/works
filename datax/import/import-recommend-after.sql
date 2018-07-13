-- psql  -v pt="'20180424'" -f proc-recommed.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_recommend_last;
--create table dbo_recommend_last as 
--select * 
--from dbo_recommend
--where pt=:pt
--;


drop table IF EXISTS dbo_recommend_merge;
create table dbo_recommend_merge as 
select id,version,approve_time,created_by,date_created,last_updated,member_id
,referrer_id,status,updated_by,ip,admin_id
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_recommend_last
union all 
select * 
from dbo_recommend_dadd
) a 
) a where rown = 1
;

--备份 dbo_recommend_last
drop table IF EXISTS dbo_recommend_last_bak;
alter table dbo_recommend_last rename to dbo_recommend_last_bak;

alter table dbo_recommend_merge rename to dbo_recommend_last;

-- 清空增量数据
DELETE FROM dbo_recommend_dadd;

--recommend
create table recommend_tmp as 
select id,version,approve_time,created_by,date_created,last_updated,member_id
,referrer_id,status,updated_by,ip,admin_id
,pt
from dbo_recommend_last
;

drop table IF EXISTS recommend_bak;
alter table recommend rename to recommend_bak;
alter table recommend_tmp rename to recommend;


