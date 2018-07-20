-- psql  -v pt="'20180424'" -f proc-platform_customer.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM platform_customer;

insert into platform_customer
select id
,member_id,plat_customer,type,operate_type,user_type,date_created,version
,pt
from dbo_platform_customer
where pt=:pt
;

delete
from dbo_platform_customer
where pt=:pt
;



