-- psql  -v pt="'20180424'" -f proc-enterprise_info.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM enterprise_info;

insert into enterprise_info
select id,member_id,company_name,business_license_no,status,gmt_create,gmt_update,bank_license,org_no
,pt
from dbo_enterprise_info
where pt=:pt
;

delete
from dbo_enterprise_info
where pt=:pt
;



