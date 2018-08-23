--监管164号附件3
/*
019雪山贷164号附件20180903

关于9月3日填报数据一些问题的解释
各机构：
现将各机构在填报9月3日上报的几张表格中关心的一些问题说明如下：
1、总体原则：根据企业掌握的相关信息，尽量填写详尽，具体口径企业自行把握。
2、“地区”信息：企业为完整的工商注册信息；个人可以填报至某省某市。
3、“借款金额”、“出借金额”和“投资人金额”，是指存量的本金和利息的合计（非合同金额）。
4、同一借款人多次借款和同一出借人多次出借，合计统计，“到期日”以最后到期日期计算。
*/


--估计待偿金额（亿元）	出借人/投资人数（万人）


select getdate() as stat_date
,sum(should_receipt_balance) as should_receipt_balance_sum
,sum(fact_receipt_balance) as fact_receipt_balance_sum
,sum(should_receipt_balance-fact_receipt_balance)/100000000 as 待偿金额_亿
,count(distinct a.borrow_id) as unrepay_borrow_num
,count(distinct a.loaner_id) as unrepay_loaner_num -- 借款余额中借款人总数
,count(distinct a.investor_id)*1.0/10000 as  投资人数_万 -- 借款余额中投资人总数
,count(distinct case when a.status=2 then borrow_id else null end) as overdue_borrow_num --逾期笔数
,sum(case when a.status=2 then capital else 0 end) as overdue_capital --逾期金额
,sum(case when a.status=2 then (capital+interest) else 0 end) as overdue_capital_interest --逾期金额(含利息)
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)
and a.status in (1,2)

stat_date	should_receipt_balance_sum	fact_receipt_balance_sum	待偿金额_亿	unrepay_borrow_num	unrepay_loaner_num	投资人数_万	overdue_borrow_num	overdue_capital	overdue_capital_interest
2018-08-23 16:42:46.930	638788550.56	0.00	6.387885	737	599	10.6361000	4	4500000.00	4725000.00


select loaner_id
,m.real_name,m.idcard,mi.region
,me.company_name,me.business_license_no
,unpay_amount/10000 as 借款金额_万
,need_receipt_time_max as 到期日
,case when a.status =1 then '正常' when a.status=2 then '逾期' end as 借款状态
from (
select a.loaner_id
,a.status
,sum(should_receipt_balance-fact_receipt_balance) as unpay_amount
,max(need_receipt_time) as need_receipt_time_max
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)
and a.status in (1,2)
group by a.loaner_id,a.status
) a 
inner join member m on a.loaner_id=m.id
left outer join member_id_card_info mi on a.loaner_id=mi.member_id
left outer join enterprise_info me on a.loaner_id=me.member_id
order by need_receipt_time_max




select top 10 * from member_id_card_info where member_id=41599

select top 10 * from borrow where loaner_id=995346



--名称（企业为注册名称，自然人为姓名）	
--证件号码（企业为组织机构代码，自然人为身份证号码）	
--地区（企业为工商注册所在地，自然人为身份证住址）	
--借款金额（万元）	
--到期日	
--借款状态（正常、逾期、恶意拖欠）
