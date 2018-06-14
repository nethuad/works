use xueshandai

select sum(should_repay_balance) as should_repay_balance
from repayment_detail a 
inner join borrow b on a.borrow_id = b.id 
where need_repayment_time>='2018-06-23' and need_repayment_time<'2018-07-11'
and b.status in(4,5,6)
  

select a.id
,a.borrow_id 标号
,a.member_id 借款人id
,m.real_name 真实姓名
,m.uname 用户名1
,m.username 用户名2
,a.issue 第几期
,need_repayment_time 预计还款时间
,should_repay_balance 借款人需还金额
,fact_receipt_balance 投资人收款金额
,(fact_receipt_balance-should_repay_balance) 差额
,fact_repay_balance  借款人实还金额
,b.cycle_type 标类型
,b.cycle 标总期数
,a.status as status_repayment
,b.status as status_borrow
from repayment_detail a 
inner join borrow b on a.borrow_id = b.id 
inner join member m on a.member_id = m.id
inner join (select borrow_id,issue,sum(fact_receipt_balance) as fact_receipt_balance  
from receipt_detail 
group by borrow_id,issue 
) rc on a.borrow_id=rc.borrow_id and a.issue = rc.issue
where b.status in(4,5,6)
and need_repayment_time>='2018-06-23' and need_repayment_time<'2018-07-11'



select * from repayment_detail where borrow_id=11947