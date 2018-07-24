drop table if exists sp_nginxlog_flow_day;
create table sp_nginxlog_flow_day as
select a.d
,a.d::timestamp as ts
,a.pv
,a.uv_ip
,a.uv_cid
,a.uv_uid
,b.uv_uid as uv_uid_guess
from (
select *
from nginxlog_flow_stat
where tbl='nginxlog_filter'
) a 
left outer join (
select *
from nginxlog_flow_stat
where tbl='nginxlog_uidnew'
) b on a.d=b.d
;

