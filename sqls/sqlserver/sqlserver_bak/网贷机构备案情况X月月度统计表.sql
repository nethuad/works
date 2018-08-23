use xueshandai

DECLARE @end_date varchar(10)
SET @end_date = '2018-08-01'

select a.report_date
,a.capital
,a.amount/10000 as 借款余额_万
,a.loaner_num as 借款余额的借款人数
,a.investor_num as 借款余额的出借人数
,a.amount_due /10000 as 逾期金额_万
,a.capital_due
,b.loaner_num 
,b.amount
,b.amount_due
,c.cycle_day_avg as 网贷平台的平均借款时长_天 
,c.amount_person_avg/10000 as 平均借款额度_万_个人
,c.amount_corp_avg/10000 as 平均借款额度_万_企业
,c.rate_avg as 平均借款利率
from (
select @end_date as report_date
,sum(capital) as capital  -- 借款本金
,sum(should_receipt_balance) as amount  -- 待收余额
,count(distinct a.loaner_id) as loaner_num
,count(distinct investor_id) as investor_num
,sum(case when (need_receipt_time<@end_date and a.status=2) or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) then should_receipt_balance else 0 end) as amount_due  -- 逾期(本金+利息)
,sum(case when (need_receipt_time<@end_date and a.status=2) or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) then capital else 0 end) as capital_due  -- 逾期(本金+利息)
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and (a.status in (1,2) or receipt_time>=@end_date)
) a 
left outer join (
select @end_date as report_date
,sum(should_repay_balance-fact_repay_balance) as amount
,count(distinct loaner_id) as loaner_num
,sum(case when a.status in (2) or repayment_time>=@end_date then should_repay_balance-fact_repay_balance else 0 end) as amount_due
from repayment_detail a   -- 逾期金额根据借款人的角度计算
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and (a.status in (1,2) or repayment_time>=@end_date)
) b on a.report_date = b.report_date
left outer join (
select @end_date as report_date
,sum(case when cycle_type=1 then cycle when cycle_type=2 then cycle*30 else 0 end)*1.0/sum(case when cycle_type in (1,2) then 1 else 0 end) as cycle_day_avg  -- 平均借款期限:网贷平台的平均借款时长。单位：天
-- 平均借款额度:网贷平台借贷的单一借款人平均借款额度，区分自然人与法人及其他组织。单位：万元
,sum(case when category = 'worth' then amount else 0 end )/count(distinct case when category = 'worth' then loaner_id else null end) as  amount_person_avg  
,sum(case when category <> 'worth' then amount else 0 end )/count(distinct case when category <> 'worth' then loaner_id else null end) as  amount_corp_avg --
,sum(rate)/count(1) as rate_avg -- 平均借款利率
from borrow
where full_time < @end_date
and status in (4,5,6)
) c on a.report_date = c.report_date


report_date	amount	loaner_num	借款余额的出借人数	amount_due	借款余额的借款人数	借款余额_万	逾期金额_万	网贷平台的平均借款时长_天	平均借款额度_万_个人	平均借款额度_万_企业	平均借款利率
2018-06-01	626373972.52	599	5105	4725000.00	601	62637.420793	472.521499	106.369131892697	25.292493	424.670069	0.142497

report_date	capital	amount	loaner_num	借款余额的出借人数	amount_due	capital_due	借款余额的借款人数	借款余额_万	逾期金额_万	网贷平台的平均借款时长_天	平均借款额度_万_个人	平均借款额度_万_企业	平均借款利率
2018-06-01	594000000.00	626373972.52	599	5105	4725000.00	4500000.00	601	62637.420793	472.521499	106.369131892697	25.292493	424.670069	0.142497

==== 以下流程可不看=============================

-- 本金+利息

-- 62637.397252

----借款人数（个）:尚有借款余额的借款人数量总和。单位：人

select count(distinct loaner_id) from borrow where full_time <'2018-6-1 00:00:00' and status in (1,4,5)  and trade_out>0 and is_display='1'

--601

------出借人数:撮合仍有待收金额的出借人数量总和。单位：人

select count(distinct investor_id) from receipt_detail where status in (1,2) and borrow_id in (
	select id from borrow where full_time <'2018-6-1 00:00:00' and status in (1,4,5)
)

--5105

------平均借款期限:网贷平台的平均借款时长。单位：天

-- 106.369131892697

-------平均借款额度:网贷平台借贷的单一借款人平均借款额度，区分自然人与法人及其他组织。单位：万元

select SUM(amount)/COUNT(distinct loaner_id)/10000 from borrow where full_time <'2018-6-1 00:00:00' and status in (1,4,5,6)  and trade_out>0 and is_display='1' and category='worth'
-- 25.433342

select SUM(amount)/COUNT(distinct loaner_id)/10000 from borrow where full_time <'2018-6-1 00:00:00' and status in (1,4,5,6)  and trade_out>0 and is_display='1' and category !='worth'
-- 425.029491

------平均借款利率:平台借款的平均利率。单位：%

select avg(rate) as 平均借款利率
from borrow where  full_time <'2018-6-1 00:00:00' and status in (4,5,6)

-- 0.142545

-------逾期金额:网贷平台逾期金额总和。单位：万元
select SUM(should_repay_balance-fact_repay_balance)/10000 from repayment_detail where status in (2) and borrow_id in (
	select id from borrow where full_time <'2018-6-1 00:00:00' and status in (4,5,6)
)


-- 472.521499



