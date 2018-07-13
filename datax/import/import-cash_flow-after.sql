-- psql  -v pt="'20180424'" -f proc-cash_flow.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量

--cash_flow
/*
create table cash_flow as 
select id,account_id,event_type_id,change,available_after,freeze_after,date_created,last_updated
,created_by,updated_by,version,data_digest,available_before,freeze_before
,event_source,description,expand1,expand2,is_voucher,way
,pt
from dbo_cash_flow
;
*/

--cash_flow不会更新数据，因此采用插入方式即可


delete from cash_flow 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO cash_flow 
SELECT id,account_id,event_type_id,change,available_after,freeze_after,date_created,last_updated
,created_by,updated_by,version,data_digest,available_before,freeze_before
,event_source,description,expand1,expand2,is_voucher,way
,pt
FROM dbo_cash_flow_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_cash_flow_dadd where pt=:pt;



