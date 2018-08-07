-- 注册的链接统计
drop table if exists sp_nginxlog_register_url;
create table sp_nginxlog_register_url as
select *
,d::timestamp as ts
from nginxlog_register_url
;