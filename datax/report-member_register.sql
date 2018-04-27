--用户注册 member_register_report

drop table IF EXISTS member_register_report;

create table member_register_report as 
select substring(reg_time from 1 for 10) as d
,case when is_recommended =1 then '推荐注册量' else '普通注册量' end as flow_type
,count(1) as flow
from member_wide
where reg_time>='2017-01-01' and reg_time<to_char(now(),'YYYY-MM-DD')
group by substring(reg_time from 1 for 10),flow_type
union all 
select d
,'推荐链接点击量' as flow_type
,count(distinct ip) as flow
from nginxlog_invite_register_base
where d>='2017-01-01' and d<to_char(now(),'YYYY-MM-DD')
group by d
;