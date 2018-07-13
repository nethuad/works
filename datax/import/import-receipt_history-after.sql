-- psql  -v pt="'20180424'" -f proc-receipt_history.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量
/*
create table receipt_history as 
select * 
from dbo_receipt_history
;
*/


--receipt_history 不会更新数据，因此采用插入方式即可

delete from receipt_history 
where receipt_time>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;


INSERT INTO receipt_history 
select id,version,borrow_id,capital,interest,investor_id,is_proxy_repay,member_overdue_fee
,receipt_id,receipt_time,repay_history_id,total
,pt
FROM dbo_receipt_history_dadd
where pt=:pt 
and receipt_time>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;


-- 清空增量数据
DELETE FROM dbo_receipt_history_dadd
where pt=:pt
;