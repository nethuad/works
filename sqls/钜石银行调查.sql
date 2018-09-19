use xueshandai

-- 待收
drop table #receipt
select a.*
,b.full_time
,case when a.status=1 then '待收' when a.status =2 then '逾期' when a.status =4 then '已还款' end as receipt_status
,case when b.category in ('ordinary','transfer') then '企业贷' when b.category='worth' then '净值标' end as borrow_category
,case when b.category='ordinary' then '担保标' when b.category='transfer' then '信用标' when b.category='worth' then '净值标' end as borrow_category2
,b.cycle_type
,b.cycle
into #receipt
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)


-- 投资
drop table #invest
select a.*
,b.full_time
,case when b.category in ('ordinary','transfer') then '企业贷' when b.category='worth' then '净值标' end as borrow_category
,case when b.category='ordinary' then '担保标' when b.category='transfer' then '信用标' when b.category='worth' then '净值标' end as borrow_category2
,b.cycle_type
,b.cycle
into #invest
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)

-- 查看状态
select borrow_category,receipt_status
,count(distinct borrow_id) as borrow_num
from #receipt
group by borrow_category,receipt_status

-- 校验
select count(1) as c ,sum(capital) as capital from #receipt
--1652293	5974366599.92
select count(1) as c ,sum(capital) as capital from #invest
--445553	5974366600.00

-- 用户身份信息
drop table #member_info
select *
,case when age<20 then '1-20-' when age>=20 and age<50 then '2-20~50' when age>=50 and age<60 then '3-50~60' when age>=60 then '4-60+' end as age_area
into #member_info
from (
select *
,CONVERT(varchar,region)+convert(varchar,year(birthday))+'*********' as idcard
,DATEDIFF(year,birthday,GETDATE()) as age 
from member_id_card_info 
) a 

select count(1) as c ,count(distinct member_id) as c2 from #member_info


-- 企业信息
drop table #enterp_info
select * 
into #enterp_info
from (
select *
,row_number() over(partition by member_id order by id desc ) as rown 
from enterprise_info
) a where rown=1


select count(1) as c ,count(distinct member_id) as c2 from enterprise_info
select count(1) as c ,count(distinct member_id) as c2 from #enterp_info


-- ==========================

--汇总数据

select getdate() as getdate
,count(1) as c
,count(distinct borrow_id) as 借款笔数
,count(distinct loaner_id) as 借款人数
,sum(capital) as 借款金额
,count(distinct case when receipt_status in ('待收','逾期') then investor_id else null end) as 在投人数
,sum(case when receipt_status in ('待收','逾期') then should_receipt_balance else 0 end) as 在投金额
,count(distinct case when receipt_status in ('待收','逾期') then borrow_id else null end) as 待收的标数
,count(distinct case when receipt_status in ('待收','逾期') then loaner_id else null end) as 在借的借款人数
,count(distinct case when receipt_status in ('逾期') then loaner_id else null end) as 逾期的借款人数
,count(distinct case when receipt_status in ('逾期') then borrow_id else null end) as 逾期的标数
,count(distinct case when receipt_status in ('逾期') then borrow_id else null end)*1.0/count(distinct borrow_id) as 逾期率
,count(distinct borrow_id) - count(distinct case when receipt_status in ('待收','逾期') then borrow_id else null end) as 完结的标数
from #receipt

select getdate() as getdate
,max(amount) as 最高借款金额
,avg(case when cycle_type=1 then cycle*1.0/30 else cycle end) as 平均借款期限_月
from borrow a 
inner join (select distinct borrow_id from #receipt) b on a.id=b.borrow_id



-- =======================

-- 逾期

select borrow_category,cycle_type,cycle
,count(distinct loaner_id) as loaner_num
,count(distinct borrow_id) as borrow_num
,sum(capital) as capital
,sum(interest) as interest
,sum(should_receipt_balance) as should_receipt_balance
,sum(should_receipt_fee) as should_receipt_fee
,sum(fact_receipt_balance) as fact_receipt_balance
,sum(fact_receipt_fee) as fact_receipt_fee
,min(need_receipt_time) as need_receipt_time_min
,max(need_receipt_time) as need_receipt_time_max
from #receipt 
where receipt_status='逾期'
group by borrow_category,cycle_type,cycle

select borrow_id,sum(should_receipt_balance)
from #receipt 
where receipt_status='逾期'
group by borrow_id

--(5020,5032,5034,5050)

-- borrow_category	cycle_type	cycle	loaner_num	borrow_num	capital	interest	should_receipt_balance	should_receipt_fee	fact_receipt_balance	fact_receipt_fee	need_receipt_time_min	need_receipt_time_max
-- 担保标	2	12	1	4	4500000.00	225000.00	4725000.00	2434395.05	0.00	0.00	2015-10-29 10:32:04.317	2016-02-05 09:18:03.253

-- =======================

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



select distinct borrow_category, cycle_type,cycle
from #receipt
where receipt_status in ('待收','逾期')


-- 限定 企业贷  月标 标期 in (1,2,3,6,12,18)

select top 10 *
from #receipt
where borrow_category in ('企业贷')
and cycle_type=2 and cycle in (1,2,3,6,12,18)


select borrow_category,cycle_type,cycle
,count(1) as c
,count(distinct borrow_id) as 借款笔数
,count(distinct loaner_id) as 借款人数
,sum(capital) as 借款金额
,count(distinct case when receipt_status in ('待收','逾期') then investor_id else null end) as 在投人数
,sum(case when receipt_status in ('待收','逾期') then should_receipt_balance else 0 end) as 在投金额
,count(distinct case when receipt_status in ('待收','逾期') then borrow_id else null end) as 待收的标数
,count(distinct case when receipt_status in ('待收','逾期') then loaner_id else null end) as 在借的借款人数
,count(distinct borrow_id) - count(distinct case when receipt_status in ('待收','逾期') then borrow_id else null end) as 完结的标数
from #receipt
where borrow_category in ('企业贷')
and cycle_type=2 and cycle in (1,2,3,6,12,18)
group by borrow_category,cycle_type,cycle


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
from #receipt



select count(1) as 近3个月新增投资人数
from (
select a.*
,row_number() over(partition by a.investor_id order by a.date_created ) as rown
from #invest a 
) a 
where datediff(day,date_created,getdate())<=90 and rown=1



--近3个月的投资客户
drop table #invest_investor_m3

select *
,row_number() over(order by capital desc) as rown
into #invest_investor_m3
from (
select investor_id,sum(capital) as capital
from #invest
where datediff(day,full_time,getdate())<=90
group by investor_id
) a 


select count(1) as c ,count(distinct investor_id) as uv,sum(capital) as capital from #invest_investor_m3
--c	uv	capital
--104543	104543	323263400.00

DECLARE @total bigint
--SET @total = 104543
SELECT @total = count(1) from #invest_investor_m3

select count(1) as total, sum(capital) as capital
,sum(case when rown*1.0/@total<=0.1 then capital else 0 end ) as amount_10  --近3个月前10%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.3 then capital else 0 end ) as amount_30 --近3个月前30%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.5 then capital else 0 end ) as amount_50 --近3个月前50%投资人投资总额(按投资额排名)
,sum(case when rown*1.0/@total<=0.8 then capital else 0 end ) as amount_80 --近3个月前80%投资人投资总额
from #invest_investor_m3


-- 年龄分布

select age_area
,count(distinct investor_id) as 在投人数
,sum(should_receipt_balance) as 在投金额
from #receipt a 
left outer join #member_info b on a.investor_id=b.member_id
where receipt_status in ('待收','逾期')
group by age_area


--select a.*,b.birthday
--from (
--select distinct investor_id 
--from receipt_detail  a 
--where status in (1)
--) a 
--left outer join member_id_card_info b on a.investor_id=b.member_id



--近6个月的月均增长客户

select count(1)/6 as 近6个月新增投资人数_月均
from (
select a.*
,row_number() over(partition by a.investor_id order by a.date_created ) as rown
from #invest a 
) a 
where datediff(day,date_created,getdate())<=180 and rown=1


-- 发标周期(小时)

DECLARE @start_time datetime
DECLARE @end_time datetime
SET @start_time = DATEADD(dd,-30,GETDATE())
SET @end_time = GETDATE()

select @start_time as start_time
,@end_time as end_time
,count(1) as c 
,DATEDIFF(hour,@start_time,@end_time) as hours
,DATEDIFF(hour,@start_time,@end_time)*1.0/count(1) as rate
from borrow
where status in (1,4,5,6)
and dateadd(dd,-min_invest_day,fund_deadline) >= @start_time  and dateadd(dd,-min_invest_day,fund_deadline) < @end_time




-- 满标周期(小时)
DECLARE @start_time datetime
DECLARE @end_time datetime
SET @start_time = DATEADD(dd,-30,GETDATE())
SET @end_time = GETDATE()

select @start_time as start_time
,@end_time as end_time
,count(1) as c 
,DATEDIFF(hour,@start_time,@end_time) as hours
,DATEDIFF(hour,@start_time,@end_time)*1.0/count(1) as rate
from borrow
where status in (4,5,6)
and full_time>=@start_time  and full_time<@end_time


-- 约标

select a.*,b.borrow_num,a.appoint_borrow_num*1.0/b.borrow_num as rate
from (
select  'a' as tag,count(1) as appoint_borrow_num
from appointment_borrow a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)
) a 
inner join (
select 'a' as tag,count(distinct borrow_id) as borrow_num
from #receipt
) b on a.tag=b.tag



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

DECLARE @dead_time datetime
SET @dead_time = GETDATE()
--SET @dead_time = dateadd(dd,-1,GETDATE())

select @dead_time as dead_time
,sum(capital) as 交易总额
,sum(case when a.date_created>= dateadd(dd,-360,@dead_time) then capital else 0 end ) as 近一年交易总额
,sum(case when a.date_created>= dateadd(dd,-30,@dead_time) then capital else 0 end ) as 最近一月借款总额
,sum(case when a.date_created>= dateadd(dd,-60,@dead_time) then capital else 0 end ) as 最近两个月借款总额
,sum(case when a.date_created>= dateadd(dd,-90,@dead_time) then capital else 0 end ) as 最近三个月借款总额
from #invest a 


-- 当前待收
select sum(should_receipt_balance) as 待收金额 from #receipt where receipt_status in ('待收','逾期')

--近3个月的借款人
drop table #invest_loaner_m3

select *
,row_number() over(order by capital desc) as rown
into #invest_loaner_m3
from (
select loaner_id,sum(capital) as capital
from #invest
where datediff(day,full_time,getdate())<=90
group by loaner_id
) a 

select count(1) as c ,count(distinct loaner_id) as uv,sum(capital) as capital from #invest_loaner_m3
--c	uv	capital
--268	268	322260000.00

DECLARE @total bigint
select @total = count(1) from #invest_loaner_m3

select @total as total_tag
,count(1) as total, sum(capital) as capital
,sum(case when rown*1.0/@total<=0.1 then capital else 0 end ) as loaner_amount_10  --近3个月前10%借款主体借款总额
,sum(case when rown*1.0/@total<=0.3 then capital else 0 end ) as loaner_amount_30 --近3个月前30%借款主体借款总额
,sum(case when rown*1.0/@total<=0.5 then capital else 0 end ) as loaner_amount_50 --近3个月前50%借款主体借款总额
,sum(case when rown*1.0/@total<=0.8 then capital else 0 end ) as loaner_amount_80 --近3个月前80%借款主体借款总额
from #invest_loaner_m3




-- 汇总数据见上


--（五）平台综合数据指标
--关键指标名称	数值	指标说明
--运营指数　（上线至今总成交额(单位：万元)/上线时长(单位：天)		该数值反映的是平台的资金管理和运营能力
--投资指数　（投资人总数/借款人总数）		该数值越低，说明平台投资人受单一借款人违约影响较小
--借款指数　（过去90天借款总额/过去90天借款总人数）		该数值越低说明平台受单一借款人违约影响较小
--偿兑指数　（近90天日还款额累加和/近360天日还款额累加和）		该数值越大说明平台在上季度承担的偿还压力越大
--流动指数　（风险备付金总额/待收总额）		该数值越高说明平台受单一借款人违约影响较小

select 上线至今总成交额_万元/上线时长_天 as 运营指数
,投资人总数*1.0/借款人总数 as 投资指数
,*
from (
select sum(capital)/10000 as 上线至今总成交额_万元
,datediff(day,min(date_created),getdate()) as 上线时长_天
,count(distinct investor_id) as 投资人总数
,count(distinct loaner_id) as 借款人总数
from #invest
) a 


select capital/loaner_num as 借款指数
,capital as 过去90天借款总额
,loaner_num as 过去90天借款总人数
from (
select sum(capital) as capital
,count(distinct loaner_id) as loaner_num
from #invest
where datediff(day,full_time,getdate())<=90
) a 


select fact_receipt_balance_90/fact_receipt_balance_360 as 偿兑指数
,fact_receipt_balance_90 as 近90天日还款额累加和
,fact_receipt_balance_360 as 近360天日还款额累加和
from (
select getdate() as d
,sum(case when datediff(day,receipt_time,getdate())<=90 then fact_receipt_balance else 0 end) as fact_receipt_balance_90
,sum(case when datediff(day,receipt_time,getdate())<=360 then fact_receipt_balance else 0 end) as fact_receipt_balance_360
from #receipt
) a 


--（六）待收债权分布情况
--到期期限	本金金额	利息金额	合计	占比

DECLARE @total numeric
select @total=sum(capital+interest) from #receipt where receipt_status in ('待收')  

select need_month as 到期期限
,sum(capital) as 本金金额
,sum(interest) as 利息金额
,sum(capital+interest) as 本金利息合计
,sum(capital+interest)/@total as 占比
from (
select *
,case when DATEDIFF(day,getdate(),need_receipt_time)<30 then '00 - 01个月'
      when DATEDIFF(day,getdate(),need_receipt_time)>=30 and DATEDIFF(day,getdate(),need_receipt_time)<60 then '01 - 02个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=60 and DATEDIFF(day,getdate(),need_receipt_time)<90 then '02 - 03个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=90 and DATEDIFF(day,getdate(),need_receipt_time)<120 then '03 - 04个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=120 and DATEDIFF(day,getdate(),need_receipt_time)<150 then '04 - 05个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=150 and DATEDIFF(day,getdate(),need_receipt_time)<180 then '05 - 06个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=180 and DATEDIFF(day,getdate(),need_receipt_time)<210 then '06 - 07个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=210 and DATEDIFF(day,getdate(),need_receipt_time)<240 then '07 - 08个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=240 and DATEDIFF(day,getdate(),need_receipt_time)<270 then '08 - 09个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=270 and DATEDIFF(day,getdate(),need_receipt_time)<300 then '09 - 10个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=300 and DATEDIFF(day,getdate(),need_receipt_time)<330 then '10 - 11个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=330 and DATEDIFF(day,getdate(),need_receipt_time)<360 then '11 - 12个月'
	  when DATEDIFF(day,getdate(),need_receipt_time)>=360 then '12个月以上'
      end as need_month
from #receipt
where receipt_status in ('待收')  
) a 
group by need_month



--（七）近一年投资分布情况
--投资月份	当月投资人数	当月投资总金额	当月个人月均投资金额
select convert(varchar(7),full_time,120)  as 投资月份
,count(distinct investor_id) as 当月投资人数
,sum(capital) as 当月投资总金额
from #invest a 
where full_time>='2017-09-01' and full_time<'2018-09-01'
group by convert(varchar(7),full_time,120)
order by 投资月份



-- （八）前十大投资人信息（按在投金额排序）
--排名	姓名（企业名称）	证件号码（组织机构代码证）	在投金额	累积投资金额	投资次数

select a.rown,a.investor_id
,m.name as 姓名
,m.idcard as 证件号码
,a.should_receipt_balance as 在投金额
,b.invest_capital as 累积投资金额
,b.invest_times as 投资次数
from (
select * from (
select *
,row_number() over(order by should_receipt_balance desc ) as rown
from (
select investor_id
,sum(should_receipt_balance) as should_receipt_balance
from #receipt
where receipt_status in ('待收','逾期')
group by investor_id
) a 
) a where rown<=10
) a 
left outer join (
select investor_id
,count(1) as invest_times
,sum(capital) as invest_capital
from #invest
group by investor_id
)b on a.investor_id=b.investor_id
left outer join #member_info m on a.investor_id=m.member_id
order by a.rown


--（九）前十大借款人信息（按在贷金额排序）
--排名	姓名（企业名称）	证件号码（组织机构代码证）	在贷金额	累积贷款金额	贷款次数


select a.rown,a.loaner_id
,m.company_name as 姓名
,m.business_license_no as 组织机构代码证
,a.should_receipt_balance as 在贷金额
,b.borrow_capital as 累积贷款金额
,b.borrow_times as 贷款次数
from (
select * from (
select *
,row_number() over(order by should_receipt_balance desc ) as rown
from (
select loaner_id
,sum(should_receipt_balance) as should_receipt_balance
from #receipt
where receipt_status in ('待收','逾期')
group by loaner_id
) a 
) a where rown<=10
) a 
left outer join (
select loaner_id
,count(distinct borrow_id) as borrow_times
,sum(capital) as borrow_capital
from #invest
group by loaner_id
)b on a.loaner_id=b.loaner_id
left outer join #enterp_info m on a.loaner_id=m.member_id
order by a.rown


select top 10 * from #enterp_info









-- =======================

-- 新安银行平台简介 (zhuyz@xueshandai.com)

--1. 限定企业贷在投标(765/4)

select cycle_type
,count(1) as c
,avg(amount) as amount_avg  -- 平均标的金额
,avg(cycle*1.0) as cycle_avg -- 平均标的期限
,avg(rate) as rate_avg -- 平均年化收益率
from borrow a 
inner join (
select distinct borrow_id 
from #receipt 
where borrow_category in ('企业贷')
and receipt_status in ('待收','逾期')
) b on a.id=b.borrow_id
group by cycle_type


-- 当前待收
select sum(should_receipt_balance) as 待收 
from #receipt 
where receipt_status in ('待收','逾期')


-- 注册用户数(946570)
select count(1) as c from member

-- 投资用户数
select count(distinct investor_id) as 投资用户数 from #receipt

-- 年均交易量(2014-2017)
select count(1) as c,avg(capital) as capital_avg
from (
select YEAR(date_created) as invest_y
,sum(capital) as capital
from #invest
group by YEAR(date_created)
) a 
where invest_y>=2014 and invest_y<=2017





-- =======================

