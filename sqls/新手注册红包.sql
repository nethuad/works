select count(distinct member_id)
from (
select a.id,a.batch_id,b.batch_desc,a.amount
,member_id,valid_date,invalid_date
,case when status in (1,5) then 1 else 0 end as is_used
,status,use_to,invest_id,use_date
,date_created,last_updated
from xueshandai.dbo.card_coupons_detail a 
inner join (select id,amount,batch_desc from xueshandai.dbo.card_coupons_batch where batch_desc like '注册赠送%') b on a.batch_id=b.id 
where member_id is not null 
and valid_date>='2018-03-01'
) a 


select amount,is_used,count(1) as c
from (
select a.id,a.batch_id,b.batch_desc,a.amount
,member_id,valid_date,invalid_date
,case when status in (1,5) then 1 else 0 end as is_used
,status,use_to,invest_id,use_date
,date_created,last_updated
from xueshandai.dbo.card_coupons_detail a 
inner join (select id,amount,batch_desc from xueshandai.dbo.card_coupons_batch where batch_desc like '注册赠送%') b on a.batch_id=b.id 
where member_id is not null 
and valid_date>='2018-05-01'
) a 
group by amount,is_used

