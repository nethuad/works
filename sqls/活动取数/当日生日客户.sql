select distinct a.investor_id
-- ,b.m_month,b.m_day,b.birthday
from(
select distinct investor_id
from borrow_invest) a 
inner join (
select member_id,birthday,month(birthday) as m_month,day(birthday) as m_day
from member_info 
where month(birthday) = month(getDate()) and day(birthday) = day(getDate())
) b on a.investor_id=b.member_id
