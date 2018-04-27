-- psql  -v pt="'20180424'" -f proc-cash_flow.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量，第一次使用
--drop table IF EXISTS dbo_cash_flow_last;
--create table dbo_cash_flow_last as 
--select * 
--from dbo_cash_flow
--where pt=:pt
--;

--cash_flow
--create table cash_flow as 
--select id,account_id,event_type_id,change,available_after,freeze_after,date_created,last_updated
--,created_by,updated_by,version,data_digest,available_before,freeze_before
--,event_source,description,expand1,expand2,is_voucher,way
--,pt
--from dbo_cash_flow_last
--;

--cash_flow不会更新数据，因此采用插入方式即可

delete from dbo_cash_flow_last where date_created>=cast(:pt as varchar);

INSERT INTO dbo_cash_flow_last 
SELECT * 
FROM dbo_cash_flow_dadd
where pt=cast(:pt as varchar) and date_created>=cast(:pt as varchar)
;

-- 清空增量数据
DELETE FROM dbo_cash_flow_dadd where pt=cast(:pt as varchar);

delete from cash_flow where date_created>=cast(:pt as varchar);

INSERT INTO cash_flow 
SELECT id,account_id,event_type_id,change,available_after,freeze_after,date_created,last_updated
,created_by,updated_by,version,data_digest,available_before,freeze_before
,event_source,description,expand1,expand2,is_voucher,way
,pt
FROM dbo_cash_flow_last
where date_created>=cast(:pt as varchar)
;


