

DELETE FROM nginxlog_base WHERE d='2018-04-17'

insert into nginxlog_base
select topic,client as ip,host,http_referer,http_user_agent,protocol,proxy,request_method,size,status,timestamp,url,d
,urlparse(http_referer) as referer_ps
,urlparse(url) as url_ps
from nginxlog
where d='2018-04-17'
;


DELETE FROM nginxlog_ext WHERE d='2018-04-17'

insert into nginxlog_ext
select *
,'' as ip_city
,'' as channel
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,'' as url_type
,json_build_object('is_recommend_register',case when url ~  '(xueshandai\.com/invite-profit/invite-register\?inviteCode=|xueshandai\.com/landing-page/landing-progress\?inviteCode=)' then 1 else 0 end ) as url_details
from nginxlog_base
where d='2018-04-17'
;


DELETE FROM nginxlog_flow_count WHERE d='2018-04-17'

insert into nginxlog_flow_count
select count(1) as pv,count(distinct client) as uv 
,d
from nginxlog 
where d='2018-04-17'
group by d
;

DELETE FROM nginxlog_referer_host_count WHERE d='2018-04-17'

insert into nginxlog_referer_host_count
select referer_host
,count(1) as pv,count(distinct ip) as uv 
,d
from nginxlog_ext 
where d='2018-04-17'
group by referer_host,d
;


DELETE FROM nginxlog_invite_register_base WHERE d='2018-04-17'

insert into nginxlog_invite_register_base
select ip,host,url,d
from nginxlog_ext 
where d='2018-04-17' 
and url_details->>'is_recommend_register' = '1'
;


=================
where d>=to_char(dateadd(getdate(),-1,'day'),'yyyy-mm-dd' ) and d<to_char(getdate(),'yyyy-mm-dd' )