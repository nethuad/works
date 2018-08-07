-- psql  -v pt="'20180424'" -f proc-member_xmgj_transfer.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM member_xmgj_transfer;

insert into member_xmgj_transfer
select id
,member_id,available,show,apply_id,apply_date
,pt
from dbo_member_xmgj_transfer
where pt=:pt
;

delete
from dbo_member_xmgj_transfer
where pt=:pt
;



