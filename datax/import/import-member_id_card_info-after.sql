-- psql  -v pt="'20180424'" -f proc-member_id_card_info.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
/*
drop table IF EXISTS dbo_member_id_card_info_last;
create table dbo_member_id_card_info_last as 
select * 
from dbo_member_id_card_info
;

drop table IF EXISTS member_id_card_info;
create table member_id_card_info as 
select * 
from dbo_member_id_card_info
;
*/

drop table IF EXISTS dbo_member_id_card_info_merge;
create table dbo_member_id_card_info_merge as 
select id
,member_id,surname,name,region,years,months,days,birthday,gender,version,date_created,last_updated,created_by,updated_by
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_member_id_card_info_last
union all 
select * 
from dbo_member_id_card_info_dadd
) a 
) a where rown = 1
;

--备份 dbo_member_id_card_info_last
drop table IF EXISTS dbo_member_id_card_info_last_bak;
alter table dbo_member_id_card_info_last rename to dbo_member_id_card_info_last_bak;

alter table dbo_member_id_card_info_merge rename to dbo_member_id_card_info_last;

-- 清空增量数据
DELETE FROM dbo_member_id_card_info_dadd;

--member_id_card_info
create table member_id_card_info_tmp as 
select id
,member_id,surname,name,region,years,months,days,birthday,gender,version,date_created,last_updated,created_by,updated_by
,pt
from dbo_member_id_card_info_last
;

drop table IF EXISTS member_id_card_info_bak;
alter table member_id_card_info rename to member_id_card_info_bak;
alter table member_id_card_info_tmp rename to member_id_card_info;


