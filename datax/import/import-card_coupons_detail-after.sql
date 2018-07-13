-- psql  -v pt="'20180424'" -f proc-card_coupons_detail.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_card_coupons_detail_last;
--create table dbo_card_coupons_detail_last as 
--select * 
--from dbo_card_coupons_detail
--;


drop table IF EXISTS dbo_card_coupons_detail_merge;
create table dbo_card_coupons_detail_merge as 
select id,
batch_id,amount,member_id,valid_date,invalid_date,status,
date_created,last_updated,created_by,updated_by,use_to,use_date,version,invest_id,
pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_card_coupons_detail_last
union all 
select * 
from dbo_card_coupons_detail_dadd
) a 
) a where rown = 1
;

--备份 dbo_card_coupons_detail_last
drop table IF EXISTS dbo_card_coupons_detail_last_bak;
alter table dbo_card_coupons_detail_last rename to dbo_card_coupons_detail_last_bak;

alter table dbo_card_coupons_detail_merge rename to dbo_card_coupons_detail_last;

-- 清空增量数据
DELETE FROM dbo_card_coupons_detail_dadd;

--card_coupons_detail
create table card_coupons_detail_tmp as 
select id,
batch_id,amount,member_id,valid_date,invalid_date,status,
date_created,last_updated,created_by,updated_by,use_to,use_date,version,invest_id,
pt
from dbo_card_coupons_detail_last
;

drop table IF EXISTS card_coupons_detail_bak;
alter table card_coupons_detail rename to card_coupons_detail_bak;
alter table card_coupons_detail_tmp rename to card_coupons_detail;


