use xsd_xsd;
insert overwrite table referer_host_base partition (d) 
select client,http_referer,http_user_agent,request_method,size,status,timestamp,host,url
,parse_url(http_referer,'HOST') as referer_host
,REGEXP_EXTRACT(parse_url(url, 'PATH'),'(\\.[a-zA-Z]+)$',1) as file_type
,d
from nginxlog 
where d>=to_char(dateadd(getdate(),-1,'day'),'yyyy-mm-dd' ) and d<to_char(getdate(),'yyyy-mm-dd' )
and http_referer is not null
and length(parse_url(http_referer,'HOST'))>3
and parse_url(http_referer,'HOST') not rlike 'xueshandai\\.com$'
;


use xsd_xsd;
insert overwrite table flow_count partition (d) 
select count(1) as pv,count(distinct client) as uv 
,d
from nginxlog 
where d>=to_char(dateadd(getdate(),-1,'day'),'yyyy-mm-dd' ) and d<to_char(getdate(),'yyyy-mm-dd' )
group by d
;

use xsd_xsd;
insert overwrite table referer_host_count partition (d) 
select parse_url(http_referer,'HOST') as referer_host
,count(1) as pv,count(distinct client) as uv 
,d
from nginxlog 
where d>=to_char(dateadd(getdate(),-1,'day'),'yyyy-mm-dd' ) and d<to_char(getdate(),'yyyy-mm-dd' )
group by d
;



===================
use xsd_xsd;

insert overwrite table report_referer_host   partition (d) 
select parse_url(http_referer,'HOST') as refer_host
,REGEXP_EXTRACT(url,'(\\.[a-zA-Z]{3})($|\\?)',1) as url_type
,count(1) as pv
,count(distinct client) as uv 
,d
from nginxlog 
where d>='2018-01-01' and d<'2018-03-30'
and http_referer is not null
group by parse_url(http_referer,'HOST'),REGEXP_EXTRACT(url,'(\\.[a-zA-Z]{3})($|\\?)',1),d
;

