drop table if exists sp_nginxlog_ip_cid_uid_province_d;
create table sp_nginxlog_ip_cid_uid_province_d as
select *
,d::timestamp as ts
from nginxlog_ip_cid_uid_province_d
where uid is not null
;

