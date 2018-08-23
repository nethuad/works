DECLARE @end_date varchar(10)
SET @end_date = '2018-08-13'

select @end_date as end_date
,sum(a.capital) as unrepay_capital  -- 借贷余额
,sum(a.should_receipt_balance) as should_receipt_balance  -- 借贷总额
,count(distinct a.loaner_id) as unrepay_loaner_num -- 借款余额中借款人总数
,count(distinct a.investor_id) as  unrepay_investor_num -- 借款余额中投资人总数
,count(distinct case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as overdue_borrow_num --逾期笔数
,sum(case when need_receipt_time<@end_date and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then (capital+interest) else 0 end) as overdue_capital_interest_num --逾期金额(含利息)
,count(distinct case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then borrow_id else null end) as bad_debt_num --不良笔数
,sum(case when datediff(dd,need_receipt_time,@end_date)>=90 and (a.status=2 or (a.status=4 and receipt_time>=@end_date) ) then capital else 0 end) as bad_debt_capital --不良本金

from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and ( (need_receipt_time>=@end_date and a.status=1) --待收
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --已还，截止日期之后还的
   or (need_receipt_time<@end_date and a.status=2) -- 截止日期之前需还，但是目前逾期的
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- 截止日期之前需还，但是截止日期之后还的（逾期还款）
)

60326
106514

should_receipt_balance
111.20

select top 10 * from receipt_detail

end_date	unrepay_capital	unrepay_loaner_num	unrepay_investor_num	overdue_borrow_num	overdue_capital_interest_num	bad_debt_num	bad_debt_capital
2018-08-13	602760000.00	602	106484	4	4725000.00	4	4500000.00