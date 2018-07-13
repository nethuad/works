-- psql  -v pt="'20180424'" -f proc-weixin_binding.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM weixin_binding;

insert into weixin_binding
select id
,version,member_id,openid
,pt
from dbo_weixin_binding
where pt=:pt
;

delete
from dbo_weixin_binding
where pt=:pt
;



