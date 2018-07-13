drop table if exists sp_account_recharge;
create table sp_account_recharge as
select a.*
,case when b.member_id is not null then 'corp' else 'invest' end as rtype
,case when c.member_id is not null then 'inner' else 'outer' end as mtype
,cast(date_created as timestamp) as ts
,to_char(cast(date_created as timestamp),'YYYY-MM-DD') as d_ts
from account_recharge a 
left outer join enterprise_loaner b on a.member_id=b.member_id
left outer join member_inner c on a.member_id=c.member_id
where charge_status=3
;