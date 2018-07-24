select distinct investor_id as member_id
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
left outer join member_xmgj_transfer c on a.investor_id=c.member_id
where a.date_created>='2017-01-01'
and b.status in (1,4,5,6)
and c.member_id is null