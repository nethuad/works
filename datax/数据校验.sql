DECLARE @end_date varchar(10)
SET @end_date = '2018-06-21'

select 'member' as tbl, count(1) as c from member where date_created < @end_date
union all 
select 'borrow' as tbl, count(1) as c from borrow where date_created < @end_date
union all 
select 'borrow_invest' as tbl, count(1) as c from borrow_invest where date_created < @end_date
union all 
select 'card_coupons_batch' as tbl, count(1) as c from card_coupons_batch where date_created < @end_date
union all 
select 'card_coupons_detail' as tbl, count(1) as c from card_coupons_detail where date_created < @end_date
union all 
select 'repayment_detail' as tbl, count(1) as c from repayment_detail where date_created < @end_date
union all 
select 'receipt_detail' as tbl, count(1) as c from receipt_detail where date_created < @end_date
union all 
select 'account' as tbl, count(1) as c from account where date_created < @end_date
union all 
select 'account_withdraw' as tbl, count(1) as c from account_withdraw where date_created < @end_date
union all 
select 'recommend' as tbl, count(1) as c from recommend where date_created < @end_date
union all 
select 'transfer_detail' as tbl, count(1) as c from transfer_detail where date_created < @end_date
union all 
select 'member_signin' as tbl, count(1) as c from member_signin where date_created < @end_date
union all 
select 'credit_card_payment' as tbl, count(1) as c from credit_card_payment where date_created<=@end_date
union all 
select 'cash_flow' as tbl, count(1) as c from cash_flow where date_created < @end_date
union all 
select 'repayment_history' as tbl, count(1) as c from repayment_history where date_created < @end_date
union all 
select 'receipt_history' as tbl, count(1) as c from receipt_history where receipt_time<@end_date
union all 
select 'account_recharge' as tbl, count(1) as c from account_recharge where date_created < @end_date
union all 
select 'member_info' as tbl, count(1) as c from member_info where date_created < @end_date
union all 
select 'vip_grade' as tbl, count(1) as c from vip_grade
union all 
select 'mold' as tbl, count(1) as c from mold
union all 
select 'vip_association' as tbl, count(1) as c from vip_association where date_created < @end_date
union all 
select 'member_vip' as tbl, count(1) as c from member_vip where date_created < @end_date
union all 
select 'weixin_binding' as tbl, count(1) as c from weixin_binding
union all 
select 'notice' as tbl, count(1) as c from notice where date_created < @end_date
union all 
select 'notice_his' as tbl, count(1) as c from notice_his where date_created < @end_date
