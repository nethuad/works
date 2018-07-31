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

-- 解码

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


-- 爬虫
DELETE FROM nginxlog_spider WHERE d=:d;

insert into nginxlog_spider
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,xsd_tag,ip,referer_ps,url_ps,d
from nginxlog_base_ext
where d=:d
and (http_user_agent in ('-') or http_user_agent ~* '(spider|crawler|scrapy|yunjiankong|yunaqmonitor|http://|https://)')
;

delete from nginxlog_flow_stat WHERE d=:d and tbl='nginxlog_filter';

insert into nginxlog_flow_stat
select 'nginxlog_spider' as tbl 
,count(1) as pv
,count(distinct ip) as uv_ip
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,d
from nginxlog_spider
WHERE d=:d
group by d
;


DELETE FROM nginxlog_nospider WHERE d=:d;

insert into nginxlog_nospider
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,xsd_tag,ip,referer_ps,url_ps,d
from nginxlog_base_ext
where d=:d
and not(http_user_agent in ('-') or http_user_agent ~* '(spider|crawler|scrapy|yunjiankong|yunaqmonitor|http://|https://)')
;


-- 过滤异常数据 

DELETE FROM nginxlog_filter WHERE d=:d;

insert into nginxlog_filter
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,xsd_tag,ip,referer_ps,url_ps,d
from nginxlog_nospider
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



-- 生成cid，uid的对应表
/*
drop table tmp1;
create table tmp1 as 
select timestamp,cid,uid,d
from nginxlog_filter
where uid is not null
;

drop table tmp2;
create table tmp2 as 
select *
,lag(uid,1,0::bigint) over(partition by cid order by timestamp asc) as uid_lag 
,lead(uid,1,0::bigint) over(partition by cid order by timestamp asc) as uid_lead
from tmp1 
;

drop table nginxlog_cid_uid;
create table nginxlog_cid_uid as 
select timestamp,cid,uid,d
from tmp2
where uid_lag=0 or uid_lead=0 or uid<>uid_lag or uid<>uid_lead 
;

*/
drop table IF EXISTS nginxlog_cid_uid_tmp;
create table nginxlog_cid_uid_tmp as 
select timestamp,cid,uid,d
from (
select *
,lag(uid,1,0::bigint) over(partition by cid order by timestamp asc) as uid_lag 
,lead(uid,1,0::bigint) over(partition by cid order by timestamp asc) as uid_lead
from (
select timestamp,cid,uid,d
from nginxlog_cid_uid
union all 
select timestamp,cid,uid,d
from nginxlog_filter
where d=:d
and uid is not null
) a 
) a where uid_lag=0 or uid_lead=0 or uid<>uid_lag or uid<>uid_lead 
;

drop table IF EXISTS nginxlog_cid_uid_old;
alter table nginxlog_cid_uid rename to nginxlog_cid_uid_old;
alter table nginxlog_cid_uid_tmp rename to nginxlog_cid_uid;


-- 生成修正uid的表
/*
create table nginxlog_filter_uidnew as 
select  host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,uid as uidnew,xsd_tag
,ip,referer_ps,url_ps,d
from nginxlog_filter
;

create table tmp1 as 
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,uid as uid_new,xsd_tag
,ip,referer_ps,url_ps,d
from nginxlog_filter
where uid is not null
;

union all

create table nginxlog_uidnew as 
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,uid_new,xsd_tag
,ip,referer_ps,url_ps,d
from (
select *
,row_number() over(partition by cid,rown_cid order by interval_sec_abs asc) as rown_interval
from (
select a.*
,b.uid as uid_new
,b.timestamp as timestamp_new
,abs(EXTRACT(EPOCH FROM a.timestamp::timestamp-b.timestamp::timestamp) ) as interval_sec_abs
from (
select *
,row_number() over(partition by cid order by timestamp asc) as rown_cid
from nginxlog_filter
) a 
left outer join nginxlog_cid_uid b on a.cid=b.cid
) a 
) a where rown_interval=1
;
*/

-- 更新7天的数据

drop table IF EXISTS nginxlog_uidnew_tmp;
create table nginxlog_uidnew_tmp as 
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,uid_new,xsd_tag
,ip,referer_ps,url_ps,d
from (
select *
,row_number() over(partition by cid,rown_cid order by interval_sec_abs asc) as rown_interval
from (
select a.*
,b.uid as uid_new
,b.timestamp as timestamp_new
,abs(EXTRACT(EPOCH FROM a.timestamp::timestamp-b.timestamp::timestamp) ) as interval_sec_abs
from (
select *
,row_number() over(partition by cid order by timestamp asc) as rown_cid
from nginxlog_filter
where d>=to_char(now()-INTERVAL '7 days','YYYY-MM-DD')
) a 
left outer join nginxlog_cid_uid b on a.cid=b.cid
) a 
) a where rown_interval=1
;

DELETE FROM nginxlog_uid WHERE d>=to_char(now()-INTERVAL '7 days','YYYY-MM-DD');
insert into nginxlog_uid
select host,path,query,url,http_referer,http_user_agent,request_method,size,status
,timestamp,cid,uid,uid_new,xsd_tag
,ip,referer_ps,url_ps,d 
from nginxlog_uidnew_tmp
;


delete from nginxlog_flow_stat WHERE d>=to_char(now()-INTERVAL '7 days','YYYY-MM-DD') and tbl='nginxlog_uidnew';

insert into nginxlog_flow_stat
select 'nginxlog_uidnew' as tbl 
,count(1) as pv
,count(distinct ip) as uv_ip
,count(distinct cid) as uv_cid
,count(distinct uid_new) as uv_uid
,d
from nginxlog_uid
WHERE d>=to_char(now()-INTERVAL '7 days','YYYY-MM-DD')
group by d
;


/*

COPY (SELECT * FROM country WHERE country_name LIKE 'A%') TO '/usr1/proj/bray/sql/a_list_countries.copy';

COPY (SELECT * FROM tmp1 WHERE d='2018-06-13') TO '/tmp/a.copy' with csv header ;

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


-- 引用为外部链接

delete from nginxlog_foreign_base WHERE d=:d;

create table nginxlog_foreign_base as 
select *
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,json_extract_path_text(referer_ps::json,'path') as referer_path
from nginxlog_uid
where json_extract_path_text(referer_ps::json,'netloc') is not null 
and json_extract_path_text(referer_ps::json,'netloc')<>''
and json_extract_path_text(referer_ps::json,'netloc') !~'xueshandai'
;

array_agg
string_agg




*/


-- 引用为外部链接

delete from nginxlog_foreign_base WHERE d=:d;

insert into nginxlog_foreign_base
select *
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,json_extract_path_text(referer_ps::json,'path') as referer_path
from nginxlog_uid
where d=:d
and json_extract_path_text(referer_ps::json,'netloc') is not null 
and json_extract_path_text(referer_ps::json,'netloc')<>''
and json_extract_path_text(referer_ps::json,'netloc') !~'xueshandai'
;




-- 外部活动链接

delete from nginxlog_active_transfer WHERE d=:d;

insert into nginxlog_active_transfer
select *
from nginxlog_uid
where d=:d
and host='m.xueshandai.com' and path = '/active/transfer'
;



