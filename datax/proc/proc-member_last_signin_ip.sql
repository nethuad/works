-- 用户最后一次登录ip

drop table if exists member_last_signin_ip;
create table member_last_signin_ip as 
select member_id,ip,date_created as lastsigntime
from (
select member_id
,split_part(ip,',',1) as ip
,date_created 
,row_number() over(partition by member_id order by date_created desc) as rown
from member_signin
)a where rown=1
;

