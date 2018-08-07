-- psql  -v pt="'20180424'" -f proc-member_xmgj_zhaiquan.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM member_xmgj_zhaiquan;

insert into member_xmgj_zhaiquan
select id
,invest_id,borrow_id,payer_id,receiver_id,date_created,created_by,version
,pt
from dbo_member_xmgj_zhaiquan
where pt=:pt
;

delete
from dbo_member_xmgj_zhaiquan
where pt=:pt
;



