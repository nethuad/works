-- 企业客户
drop table IF EXISTS enterprise_loaner;
create table enterprise_loaner as 
select distinct member_id 
from (
    select member_id
    from enterprise_info 
    where status in (1)
    union all 
    select a.member_id
    from repayment_detail a 
    inner join borrow b on a.borrow_id = b.id 
    where b.status in (4,5,6) and b.category = 'transfer'
    and a.need_repayment_time>='2018-01-01'
)a 
;