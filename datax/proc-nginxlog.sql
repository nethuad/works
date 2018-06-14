-- psql  -v d="'2018-04-24'" -f proc-nginxlog.sql "dbname=xueshandai user=xsd password=Xsd123$"

DELETE FROM nginxlog_base WHERE d=:d;

insert into nginxlog_base
select topic,client,host,http_referer,http_user_agent,protocol,proxy,request_method,size,status,timestamp,url
,xsd_cid,xsd_uid,xsd_tag
,split_part(client,',',1) as ip
,urlparse(http_referer) as referer_ps
,urlparse(url) as url_ps
,d
from nginxlog
where d=:d
;


delete from nginxlog_base_ext WHERE d=:d;

insert into nginxlog_base_ext
select host
,json_extract_path_text(url_ps::json,'path') as path
,json_extract_path_text(url_ps::json,'query') as query
,url
,http_referer
,http_user_agent
,request_method
,cast(size as integer) as size
,cast(status as integer) as status
,timestamp
,case when xsd_cid in ('','-','0') then null else xsd_cid end as cid
,case when xsd_uid ~ '^\d+$' and xsd_uid>'0' then cast(xsd_uid as bigint) else null end as uid
,xsd_tag
,ip
,referer_ps,url_ps
,d
from nginxlog_base
WHERE d=:d
;


delete from nginxlog_flow_stat WHERE d=:d and tbl='nginxlog_base_ext';

insert into nginxlog_flow_stat
select 'nginxlog_base_ext' as tbl 
,count(1) as pv
,count(distinct ip) as uv_ip
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,d
from nginxlog_base_ext
WHERE d=:d
group by d
;



DELETE FROM nginxlog_filter WHERE d=:d;

insert into nginxlog_filter
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,xsd_tag,ip,referer_ps,url_ps,d
from nginxlog_base_ext
where d=:d
and path  !~ '\.(js|css|png|jpg|gif|ico|php|txt|rar|gz|zip)$'
and path  !~ '^/(p2p|daikuan)/'
and path  !~* '/xueshandai-app/pushtag/index' 
and host in ('www.xueshandai.com','m.xueshandai.com','xueshandai.com')
;

delete from nginxlog_flow_stat WHERE d=:d and tbl='nginxlog_filter';

insert into nginxlog_flow_stat
select 'nginxlog_filter' as tbl 
,count(1) as pv
,count(distinct ip) as uv_ip
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,d
from nginxlog_filter
WHERE d=:d
group by d
;

-- 去爬虫




/*
select host,path
,count(1) as pv
,count(distinct ip) as uv_ip
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
from nginxlog_filter
where d='2018-06-12'
group by host,path


*/


/*

app标签: xueshandai-app,?app=true

DELETE FROM nginxlog_ext WHERE d=:d;

insert into nginxlog_ext
select *
,'' as ip_city
,'' as channel
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,'' as url_type
,json_build_object('is_recommend_register',case when url ~  '(xueshandai\.com/invite-profit/invite-register\?inviteCode=|xueshandai\.com/landing-page/landing-progress\?inviteCode=)' then 1 else 0 end ) as url_details
from nginxlog_base
where d=:d
;


DELETE FROM nginxlog_flow_count WHERE d=:d;

insert into nginxlog_flow_count
select count(1) as pv,count(distinct client) as uv 
,d
from nginxlog 
where d=:d
group by d
;


DELETE FROM nginxlog_flow_mul_count WHERE d=:d;

insert into nginxlog_flow_mul_count
select count(1) as pv,count(distinct client) as uv 
,count(distinct substring(client from '\d+\.\d+\.\d+')) as ip3uv
,d
from nginxlog 
where d=:d
group by d
;



DELETE FROM nginxlog_referer_host_count WHERE d=:d;

insert into nginxlog_referer_host_count
select referer_host
,count(1) as pv,count(distinct ip) as uv 
,d
from nginxlog_ext 
where d=:d
group by referer_host,d
;


DELETE FROM nginxlog_invite_register_base WHERE d=:d;

insert into nginxlog_invite_register_base
select ip,host,url,d
from nginxlog_ext 
where d=:d 
and url_details->>'is_recommend_register' = '1'
;

*/
