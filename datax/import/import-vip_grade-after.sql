-- psql  -v pt="'20180424'" -f proc-vip_grade.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量更新
DELETE FROM vip_grade;

insert into vip_grade
select id,
grade_name,
lower,
upper,
rank,
version,
pt
from dbo_vip_grade
where pt=:pt
;

delete
from dbo_vip_grade
where pt=:pt
;



