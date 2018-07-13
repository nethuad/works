-- psql  -v pt="'20180424'" -f proc-card_coupons_batch.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_card_coupons_batch_last;
--create table dbo_card_coupons_batch_last as 
--select * 
--from dbo_card_coupons_batch
--;


drop table IF EXISTS dbo_card_coupons_batch_merge;
create table dbo_card_coupons_batch_merge as 
select id,
prefix,category,amount,num,valid_date,invalid_date,status,batch_desc,date_created,
last_updated,created_by,updated_by,convert_channel,convert_ratio,use_range,valid_day,
version,red_rate,cycle,cycle_type,investment_amount,open_setting,left_day,
template_id,
pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_card_coupons_batch_last
union all 
select * 
from dbo_card_coupons_batch_dadd
) a 
) a where rown = 1
;

--备份 dbo_card_coupons_batch_last
drop table IF EXISTS dbo_card_coupons_batch_last_bak;
alter table dbo_card_coupons_batch_last rename to dbo_card_coupons_batch_last_bak;

alter table dbo_card_coupons_batch_merge rename to dbo_card_coupons_batch_last;

-- 清空增量数据
DELETE FROM dbo_card_coupons_batch_dadd;

--card_coupons_batch
create table card_coupons_batch_tmp as 
select id,
prefix,category,amount,num,valid_date,invalid_date,status,batch_desc,date_created,
last_updated,created_by,updated_by,convert_channel,convert_ratio,use_range,valid_day,
version,red_rate,cycle,cycle_type,investment_amount,open_setting,left_day,
template_id,
pt
from dbo_card_coupons_batch_last
;

drop table IF EXISTS card_coupons_batch_bak;
alter table card_coupons_batch rename to card_coupons_batch_bak;
alter table card_coupons_batch_tmp rename to card_coupons_batch;


