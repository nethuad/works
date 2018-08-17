select 'proc-nginxlog_ip_cid_uid_province.sql' as job ,:d as bd;


delete from nginxlog_ip_cid_uid_province_d WHERE d=:d;
insert into nginxlog_ip_cid_uid_province_d
select a.*,b.province
from (
select ip,cid,uid,pv,d
from nginxlog_ip_cid_uid_d 
where d=:d
) a 
inner join ip_map_province b on a.ip=b.ip
;
