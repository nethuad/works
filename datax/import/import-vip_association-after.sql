-- psql  -v pt="'20180424'" -f proc-vip_association.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180424'

-- 全量

--vip_association
/*
create table vip_association as 
select id
,membervip_id,vip_grade_id,version,date_created
,pt
from dbo_vip_association
;
*/

--vip_association不会更新数据，因此采用插入方式即可


delete from vip_association 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO vip_association 
SELECT id
,membervip_id,vip_grade_id,version,date_created
,pt
FROM dbo_vip_association_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_vip_association_dadd where pt=:pt;



