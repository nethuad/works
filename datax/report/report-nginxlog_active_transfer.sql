drop table if exists sp_nginxlog_active_transfer;
create table sp_nginxlog_active_transfer as
select transfer_name
,case when referer_host is null or referer_host='' then '无' else referer_host end as referer_host
,referer_path
,cid,uid,uid_new,ip
,timestamp::timestamp as ts
,d
from nginxlog_active_transfer_ext_detail
;

