select 'proc-nginxlog_ip_cid_uid.sql' as job ,:d as bd;


/*
drop table ip_to_map;
create table ip_to_map as 
select distinct ip
from nginxlog_uid
where ip ~ '^\d+\.\d+\.\d+\.\d+$'
;

-- ip_map_province
*/



/* ip 当日
drop table nginxlog_ip_cid_uid_d;
create table nginxlog_ip_cid_uid_d as 
select ip,cid,uid
,count(1) as pv
,d 
from nginxlog_uid
where ip ~ '^\d+\.\d+\.\d+\.\d+$' 
group by ip,cid,uid,d 
;
*/

delete from nginxlog_ip_cid_uid_d WHERE d=:d;
insert into nginxlog_ip_cid_uid_d
select ip,cid,uid
,count(1) as pv
,d 
from nginxlog_uid
where d=:d
and ip ~ '^\d+\.\d+\.\d+\.\d+$' 
group by ip,cid,uid,d 
;


drop table if exists ip_to_map_province;
create table ip_to_map_province as 
select a.ip
from (
select distinct ip
from nginxlog_ip_cid_uid_d
where d=:d
) a 
left outer join ip_map_province b on a.ip=b.ip
where b.ip is null
;


drop table if exists ip_do_map_province;