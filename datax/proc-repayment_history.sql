-- psql  -v pt="'20180424'" -f proc-repayment_history.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量，第一次使用
--drop table IF EXISTS dbo_repayment_history_last;
--create table dbo_repayment_history_last as 
--select * 
--from dbo_repayment_history
--where pt=:pt
--;

--repayment_history
--create table repayment_history as 
--select id,version,borrow_id,capital,company_overdue_fee,displace_id,interest,member_id,member_overdue_fee,repay_id,
--repay_time,total,created_by,date_created,last_updated,updated_by,type
--,pt
--from dbo_repayment_history_last
--;

--repayment_history不会更新数据，因此采用插入方式即可

delete from dbo_repayment_history_last where date_created>=cast(:pt as varchar);

INSERT INTO dbo_repayment_history_last 
SELECT * 
FROM dbo_repayment_history_dadd
where pt=cast(:pt as varchar) and date_created>=cast(:pt as varchar)
;

-- 清空增量数据
DELETE FROM dbo_repayment_history_dadd where pt=cast(:pt as varchar);

delete from repayment_history where date_created>=cast(:pt as varchar);

INSERT INTO repayment_history 
SELECT id,version,borrow_id,capital,company_overdue_fee,displace_id,interest,member_id,member_overdue_fee,repay_id,
repay_time,total,created_by,date_created,last_updated,updated_by,type
,pt
FROM dbo_repayment_history_last
where date_created>=cast(:pt as varchar)
;


