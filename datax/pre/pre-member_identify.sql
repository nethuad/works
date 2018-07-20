-- 是否实名认证：根据存管或者银行认证判断
drop table if exists member_identify;
create table member_identify as 
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
;





