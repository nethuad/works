-- 注册的链接统计
drop table if exists sp_nginxlog_register_urls;
create table sp_nginxlog_register_urls as
select *
,timestamp::timestamp as ts
from nginxlog_register_urls_ext
;