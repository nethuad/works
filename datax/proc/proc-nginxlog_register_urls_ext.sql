-- 直接分析注册页面
drop table if exists nginxlog_register_urls_ext;
create table nginxlog_register_urls_ext as 
select *
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,json_extract_path_text(referer_ps::json,'path') as referer_path
from nginxlog_register_urls
;