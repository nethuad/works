-- 剔除名单
create table member_xmgj as 
select a.member_id 
from member_xmgj_transfer a 
left outer join member_xmgj_zhaiquan b on a.member_id=b.payer_id
where b.payer_id is null
;