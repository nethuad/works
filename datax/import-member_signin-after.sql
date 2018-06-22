-- psql  -v pt="'20180424'" -f proc-member_signin.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_member_signin_last;
--create table dbo_member_signin_last as 
--select * 
--from dbo_member_signin
--where pt=:pt
--;


drop table IF EXISTS dbo_member_signin_merge;
create table dbo_member_signin_merge as 
select id,member_id,ip,date_created,last_updated,created_by,updated_by,version
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_member_signin_last
union all 
select * 
from dbo_member_signin_dadd
) a 
) a where rown = 1
;

--备份 dbo_member_signin_last
drop table IF EXISTS dbo_member_signin_last_bak;
alter table dbo_member_signin_last rename to dbo_member_signin_last_bak;

alter table dbo_member_signin_merge rename to dbo_member_signin_last;

-- 清空增量数据
DELETE FROM dbo_member_signin_dadd;

--member_signin
create table member_signin_tmp as 
select id,member_id,ip,date_created,last_updated,created_by,updated_by,version
,pt
from dbo_member_signin_last
;

drop table IF EXISTS member_signin_bak;
alter table member_signin rename to member_signin_bak;
alter table member_signin_tmp rename to member_signin;


