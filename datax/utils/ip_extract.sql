drop table if exists ip_map_tmp1;
create table ip_map_tmp1 as 
select data::json->'data'->>'ip' as ip
,data::json->'data'->>'country' as country
,data::json->'data'->>'region' as region
,data::json->'data'->>'city' as city
from ip_to_get_out
;

drop table if exists ip_map_tmp2;
create table ip_map_tmp2 as 
select a.*
from ip_map_tmp1 a 
left outer join ip_map b on a.ip=b.ip
where b.ip is null
;

insert into ip_map 
select ip,country,region,city
from ip_map_tmp2
;

drop table ip_to_get_out;
