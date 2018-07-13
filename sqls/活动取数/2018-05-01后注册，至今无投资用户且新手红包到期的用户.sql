-- 2018-05-01后注册至今无投资用户且新手红包到期的用户

select a.id as member_id,a.reg_time as 注册时间
from member a 
left outer join (select distinct investor_id 
    from borrow_invest a 
     inner join borrow b on a.borrow_id = b.id
    where b.status in (1,4,5,6)) b on a.id=b.investor_id
inner join (
select distinct member_id
from card_coupons_detail a 
inner join card_coupons_batch b on a.batch_id=b.id
where (b.prefix in ('0416','0417','0417','0418','0419','0420','0421','0422')
or b.prefix in ('0351','0352','0353') )
and (a.status=3 or (a.status =0 and a.invalid_date<getdate()))
) c on a.id=c.member_id
where  a.reg_time >='2018-05-01'
and b.investor_id is null

