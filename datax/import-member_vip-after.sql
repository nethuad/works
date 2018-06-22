-- psql  -v pt="'20180424'" -f proc-member_vip.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
/*
drop table IF EXISTS dbo_member_vip_last;
create table dbo_member_vip_last as 
select * 
from dbo_member_vip
where pt=:pt
;
*/


drop table IF EXISTS dbo_member_vip_merge;
create table dbo_member_vip_merge as 
select id
,member_id,order_id,back_order_id,remark,begin_date,end_date
,is_end,cash,date_created,last_updated,created_by,updated_by,version
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_member_vip_last
union all 
select * 
from dbo_member_vip_dadd
) a 
) a where rown = 1
;

--备份 dbo_member_vip_last
drop table IF EXISTS dbo_member_vip_last_bak;
alter table dbo_member_vip_last rename to dbo_member_vip_last_bak;

alter table dbo_member_vip_merge rename to dbo_member_vip_last;

-- 清空增量数据
DELETE FROM dbo_member_vip_dadd;

--member_vip
create table member_vip_tmp as 
select id
,member_id,order_id,back_order_id,remark,begin_date,end_date
,is_end,cash,date_created,last_updated,created_by,updated_by,version
,pt
from dbo_member_vip_last
;

drop table IF EXISTS member_vip_bak;
alter table member_vip rename to member_vip_bak;
alter table member_vip_tmp rename to member_vip;


