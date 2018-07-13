/*
drop table if exists ip_to_get;
drop table if exists ip_to_get_out;
create table ip_to_get as 
select distinct a.ip
from member_last_signin_ip a 
left outer join ip_map b on a.ip=b.ip
where b.ip is null
;


-- 用户登录ip

-- nginx的ip

-- 进行对比



*/
