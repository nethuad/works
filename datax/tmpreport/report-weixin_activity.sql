drop table if exists sp_weixin_activity;
create table sp_weixin_activity as
select *
,CAST(date_created as timestamp) as ts
,to_char(CAST(date_created as timestamp),'YYYY-MM-DD') as d_ts
from weixin_activity a 
;

