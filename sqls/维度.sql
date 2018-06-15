

-- vip用户

select * 
from (
select a.id,a.member_id,a.remark,a.begin_date,a.end_date,a.is_end
,b.membervip_id,b.vip_grade_id
,c.grade_name,c.lower,c.upper,c.rank as vip_rank
,ROW_NUMBER() OVER(PARTITION BY a.member_id ORDER BY a.id desc) as  rown
from member_vip a 
inner join vip_association b on a.id=b.membervip_id
inner join vip_grade c on b.vip_grade_id = c.id
) a where rown=1 and is_end=0
order by end_date