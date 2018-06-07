select d
,count(1) as pv
,count(distinct client) as uv
from nginxlog
group by d
;

select * from nginxlog where d='2018-05-14'
limit 10;