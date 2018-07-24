drop table if exists sp_nginxlog_foreign;
create table sp_nginxlog_foreign as
select host,path
,referer_host
,referer_path
,cid,uid,uid_new,ip
,timestamp::timestamp as ts
,d
from nginxlog_foreign_base
where referer_host !~ '\.bxss\.me' and referer_host !~ '\d+\.\d+\.\d+\.\d+' and referer_host !~ 'localhost'
;

