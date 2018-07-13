-- psql  -v pt="'20180424'" -f proc-repayment_history.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量
--repayment_history
/*
create table repayment_history as 
select id,version,borrow_id,capital,company_overdue_fee,displace_id,interest,member_id,member_overdue_fee,repay_id,
repay_time,total,created_by,date_created,last_updated,updated_by,type
,pt
from dbo_repayment_history
;
*/


--repayment_history不会更新数据，因此采用插入方式即可

delete from repayment_history 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

INSERT INTO repayment_history 
SELECT id,version,borrow_id,capital,company_overdue_fee,displace_id,interest,member_id,member_overdue_fee,repay_id,
repay_time,total,created_by,date_created,last_updated,updated_by,type
,pt
FROM dbo_repayment_history_dadd
where pt=:pt 
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
delete from dbo_repayment_history_dadd 
where pt=:pt
;

