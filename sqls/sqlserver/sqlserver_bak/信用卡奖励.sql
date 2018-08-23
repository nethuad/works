
select id,capital,capital_type,receiver_id,description,date_created
into #1
from transfer_detail 
where payer_id =16993
and capital_type in (9,12)
;

94693

select * 
into #11
from #1 
where capital_type=9

select count(1) as c,count(distinct receiver_id) as c2 from #11
--50858 55334

select * 
into #12
from #1 
where capital_type=12
39359

select count(1) as c,count(distinct receiver_id) as c2 from #12
--39359 5871

select min(date_created) ,max(date_created)
from transfer_detail 
where payer_id =16993
and capital_type in (9,12)
;


when capital_type ='9' then '2017信用卡还款奖励'  when capital_type ='10' then '2017新春红包'  when capital_type ='11' then '微信关注红包'
	when capital_type ='12' then '2017信用卡还款推荐人奖励'


select top 10 * from credit_card_payment;

select member_id,status from credit_card_payment ;


status : NONE(""), WAIT_TO_VERIFY("待审核"), PASS_HANDLE("处理中"), NOT_PASS("未通过"), COMPLETE("已还款"), CANCEL("撤销"

select status ,count(1) as c from credit_card_payment group by status;