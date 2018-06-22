-- psql  -v pt="'20180424'" -f proc-borrow_invest.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_borrow_invest_last;
--create table dbo_borrow_invest_last as 
--select * 
--from dbo_borrow_invest
--where pt=:pt
--;


drop table IF EXISTS dbo_borrow_invest_merge;
create table dbo_borrow_invest_merge as 
select id,borrow_id,investor_id,loaner_id,capital,activate_time,interest,back_prize,status,date_created,last_updated,
created_by,updated_by,version,is_vip,loan_fee,loan_fee_rate,is_be_overdue,is_be_overdueing,capital_type,invest_way,contract
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_borrow_invest_last
union all 
select * 
from dbo_borrow_invest_dadd
) a 
) a where rown = 1
;

--备份 dbo_borrow_invest_last
drop table IF EXISTS dbo_borrow_invest_last_bak;
alter table dbo_borrow_invest_last rename to dbo_borrow_invest_last_bak;

alter table dbo_borrow_invest_merge rename to dbo_borrow_invest_last;

-- 清空增量数据
DELETE FROM dbo_borrow_invest_dadd;

--borrow_invest
create table borrow_invest_tmp as 
select id,borrow_id,investor_id,loaner_id,capital,activate_time,interest,back_prize,status,date_created,last_updated,
created_by,updated_by,version,is_vip,loan_fee,loan_fee_rate,is_be_overdue,is_be_overdueing,capital_type,invest_way,contract
,pt
from dbo_borrow_invest_last
;

drop table IF EXISTS borrow_invest_bak;
alter table borrow_invest rename to borrow_invest_bak;
alter table borrow_invest_tmp rename to borrow_invest;


