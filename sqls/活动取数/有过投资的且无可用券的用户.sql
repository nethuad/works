select a.investor_id as member_id
from (
select distinct investor_id
from borrow_invest
) a 
left outer join (
select distinct member_id
from card_coupons_detail
where member_id is not null
and status=0
and invalid_date>getdate()
) b on a.investor_id=b.member_id
left outer join (
select distinct a.member_id 
from member_xmgj_transfer a 
left outer join member_xmgj_zhaiquan b on a.member_id=b.payer_id
where b.payer_id is null
) c on a.investor_id=c.member_id
where b.member_id is null and c.member_id is null
