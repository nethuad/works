select ip,host,url,url_ps
,json_extract_path_text(url_ps::json,'path') as path
,d 
from nginxlog_base limit 10;


drop table tmp_1;
create table tmp_1 as 
select d,host
,json_extract_path_text(url_ps::json,'path') as path
,count(1) as pv
,count(distinct ip) as uv
from nginxlog_base
where d>='2018-04-01'
group by d,host,path
;