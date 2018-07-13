-- 2018年1月1日-2018年6月15日有投资且2018年6月16日-2018年6月25日无投资的客户
select a.investor_id as member_id 
from (select distinct investor_id 
from borrow_invest a 
inner join borrow b on a.borrow_id = b.id
where b.status in (1,4,5,6) 
and a.date_created >='2018-01-01' and a.date_created<'2018-06-16'
) a 
left outer join (select distinct investor_id 
from borrow_invest a 
inner join borrow b on a.borrow_id = b.id
where b.status in (1,4,5,6) 
and a.date_created >='2018-06-16' and a.date_created<'2018-06-26'
) b on a.investor_id = b.investor_id
where b.investor_id is null