-- 注册未投资用户


select a.id as member_id,a.reg_time 注册时间
from member a 
left outer join (select distinct investor_id from borrow_invest ) b on a.id = b.investor_id
where b.investor_id is null
and a.is_admin=0



-- 注册未投资用户（实名用户）
select a.*
into #1
from (
select a.id as member_id,a.reg_time 注册时间
from member a 
left outer join (select distinct investor_id from borrow_invest ) b on a.id = b.investor_id
where b.investor_id is null
and a.is_admin=0
) a 
inner join (
select a.id as member_id
,coalesce(b.date_created,c.date_created) as date_identified
from member a 
left outer join (select * from platform_customer where operate_type=2) b on a.id=b.member_id
left outer join (
select * from (
select *
,ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY id desc) as  rown
from account_bank where operate_status=1 and authenticate_status=2 and auditing_status=1
) a where rown=1
) c on a.id=c.member_id
where b.member_id is not null or c.member_id is not null
) b on a.member_id=b.member_id