use xueshandai

--（一）资金端产品信息
--年利率:
--期限:
--在投人数:
--在投金额:
--单笔限额:
--产品限额:
--待收标的数:
--完结标的数:
--最短持有期限:

select count(distinct investor_id) as 在投人数
,sum(capital) as 在投金额
,count(distinct borrow_id) as 待收标的数
from receipt_detail a 
where status in (1,2)


select count(distinct borrow_id) as 完结标的数
from receipt_detail a 
where status in (4)


--（二）资产类型以及风险把控
--借款利率:
--服务费率:
--借款期限:
--借款上限:
--历史平均借款:
--历史主体个数:
--在借主体个数:
--历史借款笔数:
--在借借款笔数:
--展期率:
--坏账率:
--是否担保: □是 □否
--是否外接: □是 □否
--准备金:   □有 □无

select count(distinct borrow_id) as 在借借款笔数
,count(distinct loaner_id) as 在借主体个数
from receipt_detail a 
where status in (1,2)


select count(1) as 历史借款笔数
,count(distinct loaner_id) as 历史主体个数
,avg(amount) as 历史平均借款
from borrow
where status in (4,5,6)


--（三）产品资金端信息
--注册人数：		实际投资人数：	
--获客成本（元/人）：		近3个月新增投资人数：	
--近3个月前10%投资人投资总额(按投资额排名)：		近3个月前30%投资人投资总额(按投资额排名)：	
--近3个月前50%投资人投资总额(按投资额排名)：		近3个月前80%投资人投资总额(按投资额排名)：	
--60岁以上在投人数：		60岁以上在投金额：	
--50-60岁在投人数：		50-60岁在投金额：	
--20-50岁在投人数：		20-50岁在投金额：	
--20岁以下在投人数：		20岁以下在投金额：	
--投资人第一集中区域：		投资人第二集中区域：	
--投资人增长速度（最近半年，人/月）：		复投比率（最近半年）：	
--发标周期（小时）：		满标周期（小时）：	
--是否有约标行为：		约标占总标比率：	


select count(1) as 注册人数
from member


select count(distinct investor_id) as 实际投资人数
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)

select count(1) as 近3个月新增投资人数
from (
select a.*
,row_number() over(partition by a.investor_id order by a.date_created ) as rown
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
) a 
where datediff(day,date_created,getdate())<=90 and rown=1



select count(1) as 近半年新增投资人数
from (
select a.*
,row_number() over(partition by a.investor_id order by a.date_created ) as rown
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
) a 
where datediff(day,date_created,getdate())<=180 and rown=1



select count(case when invest_times>1 then investor_id else null end)*1.0/count(1) as 复投比率_最近半年
from (
select a.investor_id,count(1) as invest_times
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and datediff(day,a.date_created,getdate())<=180
group by a.investor_id
) a 






DECLARE @total bigint
SET @total = 104911

select count(1) as total, sum(capital) as capital
,sum(case when rown*1.0/@total<=0.1 then capital else 0 end ) as amount_10  --近3个月前10%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.3 then capital else 0 end ) as amount_30 --近3个月前30%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.5 then capital else 0 end ) as amount_50 --近3个月前50%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.8 then capital else 0 end ) as amount_80 --近3个月前80%投资人投资总额
from (
select *
,row_number() over(order by capital desc) as rown
from (
select investor_id,sum(capital) as capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and datediff(day,a.date_created,getdate())<=90
group by investor_id
) a 
) a 




select count(1) as total, sum(amount) as amount
,sum(case when rown*1.0/@total<=0.1 then amount else 0 end ) as amount_10  --近3个月前10%借款主体借款总额
,sum(case when rown*1.0/@total<=0.3 then amount else 0 end ) as amount_30 --近3个月前30%借款主体借款总额
,sum(case when rown*1.0/@total<=0.5 then amount else 0 end ) as amount_50 --近3个月前50%借款主体借款总额
,sum(case when rown*1.0/@total<=0.8 then amount else 0 end ) as amount_80 --近3个月前80%借款主体借款总额
,sum(case when rown*1.0/@total<=1 then amount else 0 end ) as amount_100
from (
select *
,row_number() over(order by amount desc) as rown
from (
select loaner_id,sum(amount) as amount
from borrow
where status in (4,5,6)
and datediff(day,full_time,getdate())<=90
group by loaner_id
) a 
) a 


select top 10 id
,full_time,fund_deadline,DATEADD(day,-7,fund_deadline) as start_time 
,datediff(minute,DATEADD(day,-7,fund_deadline),full_time)*1.0/60 as full_span_hour
from borrow
where status in (4,5,6)
and full_time is not null and fund_deadline is not null 




select  count(1) as 约标量
from appointment_borrow

select count(1) as c from borrow where status in (4,5,6)


select agearea
,count(1) as 在投人数
,sum(capital) as 在投金额
from (
select a.*
,case when age<20 then '20岁以下'
 when age>=20 and age<50 then '20-50岁'
 when age>=50 and age<60 then '50-60岁'
 when age>=60 then '60岁以上'
 end as agearea
from (
select a.*
,b.birthday
,datediff(day,b.birthday,getdate())*1.0/365 as age
from (
select investor_id,sum(capital) as capital
from receipt_detail a 
where status in (1,2)
group by investor_id
) a 
inner join member_info b on a.investor_id =b.member_id
) a 
) a 
group by agearea





--（四）产品资产端信息
--交易总额：		
--近一年交易总额：	
--调查当日待收金额：		
--最近一月借款总额：	
--最近两个月借款总额：		
--最近三个月借款总额：	
--近3个月前10%借款主体借款总额：		
--近3个月前30%借款主体借款总额：	
--近3个月前50%借款主体借款总额：		
--近3个月前80%借款主体借款总额：	
--所有借款主体数：		
--所有借款总笔数：	
--在贷借款主体数：		
--在贷借款总笔数：	
--平均借款期限：		
--最高借款金额：	
--展期比例：		
--逾期比例：	

select sum(capital) as 交易总额
,sum(case when datediff(day,a.date_created,getdate())<=30 then capital else 0 end ) as 最近一月借款总额
,sum(case when datediff(day,a.date_created,getdate())<=60 then capital else 0 end ) as 最近两个月借款总额
,sum(case when datediff(day,a.date_created,getdate())<=90 then capital else 0 end ) as 最近三个月借款总额
,sum(case when datediff(day,a.date_created,getdate())<=360 then capital else 0 end ) as 近一年交易总额
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)


DECLARE @total bigint
SET @total = 287

select count(1) as total, sum(amount) as amount
,sum(case when rown*1.0/@total<=0.1 then amount else 0 end ) as amount_10  --近3个月前10%借款主体借款总额
,sum(case when rown*1.0/@total<=0.3 then amount else 0 end ) as amount_30 --近3个月前30%借款主体借款总额
,sum(case when rown*1.0/@total<=0.5 then amount else 0 end ) as amount_50 --近3个月前50%借款主体借款总额
,sum(case when rown*1.0/@total<=0.8 then amount else 0 end ) as amount_80 --近3个月前80%借款主体借款总额
,sum(case when rown*1.0/@total<=1 then amount else 0 end ) as amount_100
from (
select *
,row_number() over(order by amount desc) as rown
from (
select loaner_id,sum(amount) as amount
from borrow
where status in (4,5,6)
and datediff(day,full_time,getdate())<=90
group by loaner_id
) a 
) a 



select count(1) as 所有借款总笔数
,count(distinct loaner_id) as 所有借款主体数
,max(amount) as 最高借款金额
,avg(case when cycle_type=1 then cycle*1.0/30 else cycle end) as cycle_avg_month
from borrow
where status in (4,5,6)


select sum(capital) as 在贷本金
,sum(case when status in (2) then capital else 0 end) as 逾期本金
,count(distinct borrow_id) as 在贷借款总笔数
,count(distinct loaner_id) as 在贷借款主体数
from receipt_detail
where status in (1,2)







--（五）平台综合数据指标
--关键指标名称	数值	指标说明
--运营指数　（上线至今总成交额(单位：万元)/上线时长(单位：天)		该数值反映的是平台的资金管理和运营能力
--投资指数　（投资人总数/借款人总数）		该数值越低，说明平台投资人受单一借款人违约影响较小
--借款指数　（过去90天借款总额/过去90天借款总人数）		该数值越低说明平台受单一借款人违约影响较小
--偿兑指数　（近90天日还款额累加和/近360天日还款额累加和）		该数值越大说明平台在上季度承担的偿还压力越大
--流动指数　（风险备付金总额/待收总额）		该数值越高说明平台受单一借款人违约影响较小

select 上线至今总成交额_万元/上线时长_天 as 运营指数
,投资人总数*1.0/借款人总数 as 投资指数
, 上线至今总成交额_万元,上线时长_天,投资人总数,借款人总数
from (
select sum(capital)/10000 as 上线至今总成交额_万元
,datediff(day,min(a.date_created),getdate()) as 上线时长_天
,count(distinct a.investor_id) as 投资人总数
,count(distinct b.loaner_id) as 借款人总数
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
) a 


select capital/loaner_num as 借款指数
from (
select sum(a.capital) as capital,count(distinct b.loaner_id) as loaner_num
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and datediff(day,a.date_created,getdate())<=90
) a 


select total_90/total_360 as 偿兑指数
from (
select sum(case when datediff(day,date_created,getdate())<=90 then total else 0 end) as total_90
,sum(case when datediff(day,date_created,getdate())<=360 then total else 0 end) as total_360
from repayment_history
) a 

select sum(should_receipt_balance) as 待收总额
from receipt_detail
where status in (1,2)



--（六）待收债权分布情况
--到期期限	本金金额	利息金额	合计	占比

select need_month as 到期期限
,sum(capital) as 本金金额
,sum(interest) as 利息金额
from (
select *
,case when DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=30 then '00 - 01个月'
      when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>30 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=60 then '01 - 02个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>60 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=90 then '02 - 03个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>90 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=120 then '03 - 04个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>120 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=150 then '04 - 05个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>150 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=180 then '05 - 06个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>180 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=210 then '06 - 07个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>210 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=240 then '07 - 08个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>240 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=270 then '08 - 09个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>270 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=300 then '09 - 10个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>300 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=330 then '10 - 11个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>330 and DATEDIFF(hour,getdate(),need_receipt_time)/24.0<=360 then '11 - 12个月'
	  when DATEDIFF(hour,getdate(),need_receipt_time)/24.0>360 then '12个月以上'
      end as need_month
from receipt_detail
where status in (1)  
) a 
group by need_month

/* 总计
select sum(capital) as capital,sum(interest) as interest
from receipt_detail
where status in (1)
*/

--（七）近一年投资分布情况
--投资月份	当月投资人数	当月投资总金额	当月个人月均投资金额
select convert(varchar(7),a.date_created,120)  as 投资月份
,count(distinct investor_id) as 当月投资人数
,sum(capital) as 当月投资总金额
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.date_created>='2017-07-01' and a.date_created<'2018-07-01'
group by convert(varchar(7),a.date_created,120)
order by 投资月份



-- （八）前十大投资人信息（按在投金额排序）
--排名	姓名（企业名称）	证件号码（组织机构代码证）	在投金额	累积投资金额	投资次数

select a.rown as 排名
,m.real_name as 姓名
,m.idcard as 证件号码
,a.capital as 在投金额
,b.invest_capital as 累积投资金额
,b.invest_times as 投资次数
from (
select * from (
select * 
,row_number() over(order by capital desc ) as rown
from (
select investor_id,sum(a.capital) as capital
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
group by investor_id
) a 
) a 
where rown<=10
) a 
left outer join (
select investor_id
,count(1) as invest_times,sum(capital) as invest_capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6) 
group by investor_id
) b on a.investor_id=b.investor_id
inner join member m  on a.investor_id=m.id
order by rown

--（九）前十大借款人信息（按在贷金额排序）
--排名	姓名（企业名称）	证件号码（组织机构代码证）	在贷金额	累积贷款金额	贷款次数
--? 逾期的是否计入在贷，安徽的那笔，a.status in (1,2)

select 
--a.*,b.*
a.rown as 排名
,c.company_name as 企业名称
,c.business_license_no as 组织机构代码证
,a.capital as 在贷金额
,b.loan_amount as 累积贷款金额
,b.loan_times as 贷款次数
,m.real_name  as 姓名
,m.idcard as 证件号码

from (
select * 
from (
select member_id,capital
,row_number() over(order by capital desc ) as rown
from (
select a.member_id,sum(a.capital) as capital
from repayment_detail a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
and a.status in (1,2)
group by member_id
) a 
) a where rown<=10
) a 
left outer join (
select loaner_id
,count(1) as loan_times,sum(amount) as loan_amount
from borrow
where status in (4,5,6)
group by loaner_id
) b on a.member_id=b.loaner_id
left outer join enterprise_info c on a.member_id=c.member_id
left outer join member m on a.member_id=m.id
order by rown





select * from borrow where loaner_id=769371

select * from enterprise_info

select top 10 * from borrow

,m.uname,m.real_name
inner join member m on a.member_id=m.id


order by capital desc

