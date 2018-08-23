/*
累计成交量（万元）		截止目前借贷余额	
累计出借人数量		累计借款人数量	
注册用户总数（人）		当期借款人数（人）	
当期出借人数（人）		截止目前借款标的总数（个）	
截止目前借款标的数（企业）		截止目前借款标的数（个人）	0
标的均额（个人/万元）		标的均额（企业/万元）	
人均投资金额（万元）		标的平均收益率（%）	
平均满标时间（小时）		平均借款期限（月）	
前10大投资人出借金额占比(%)		前10大借款人待还金额占比（%)	
前10大投资人出借金额		前10大借款人待还金额	
最大单户借款人（企业）余额		最大单户借款人（个人）余额	
关联关系借款余额 无		关联关系借款笔数	无
截止目前逾期金额		截止目前逾期笔数	
项目借款30天逾期率		逾期30天未兑付投资人金额及笔数	
逾期90天（不含）以上金额		逾期90天（不含）以上笔数	
累计代偿金额 0		累计代偿笔数	0
个人最大借款额（万元）		企业最大借款额（万元）	
当期最长借款金额		
投资用户年龄分布	"0-50岁占比        % 51-60岁占比        %  61岁以上占比        %"

*/

use xueshandai

select count(1) as 注册用户总数 from member
--943713

select count(1) as c
,sum(capital)/10000 as 累计成交量_万
,count(distinct investor_id) as 累计出借人数量
,count(distinct a.loaner_id) as 累计借款人数量
,sum(capital)/count(distinct investor_id) as 人均投资金额_万元
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)



DECLARE @end_date varchar(10)
SET @end_date = '2018-08-15'

select count(1) as c
,sum(a.capital) as 借贷余额
,sum(a.should_receipt_balance) as 借贷总额
,count(distinct a.loaner_id) as 借款人总数
,count(distinct a.investor_id) as 投资人总数
,count(distinct borrow_id) as 标数
,count(distinct case when a.status=2 then borrow_id else null end) as 逾期笔数
,sum(case when a.status=2 then capital else 0 end) as 逾期金额
,sum(case when a.status=2 then should_receipt_balance else 0 end) as 逾期金额_含利息
,count(distinct case when datediff(dd,need_receipt_time,getdate())>=90 and a.status=2 then borrow_id else null end) as 不良笔数gt90
,sum(case when datediff(dd,need_receipt_time,getdate())>=90 and a.status=2 then capital else 0 end) as 不良本金gt90
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6) and a.status in (1,2)



-- (待收+逾期)的标
select case when category='worth' then '个人' else '企业' end as 标类型
,case when cycle_type=1 then '日标' when cycle_type=2 then '月标' end as 标周期
,count(1) as 标数
,count(distinct loaner_id) as 借款人总数
,avg(amount) as  标的均额
,avg(rate) as 标的平均收益率
,avg(cycle*1.0) as 平均借款期限
,avg(datediff(minute,DATEADD(day,-7,fund_deadline),full_time)*1.0/60) as 平均满标时间_小时
from borrow a 
inner join (select distinct borrow_id from receipt_detail where status in (1,2)) b on a.id=b.borrow_id
group by case when category='worth' then '个人' else '企业' end
,case when cycle_type=1 then '日标' when cycle_type=2 then '月标' end


-- 前十大投资人

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

select sum(case when rown<=10 then capital else 0 end) as 前10大投资人出借金额
,sum(capital) as 投资总额
,sum(case when rown<=10 then capital else 0 end)/sum(capital) as 前10大投资人出借金额占比
from (
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

--前10大投资人出借金额	投资总额	前10大投资人出借金额占比
--81380620.00	601260000.00	0.135350


-- 前十大借款人
select *
from (
select * 
,row_number() over(order by capital desc ) as rown
from (
select a.loaner_id,sum(a.capital) as capital,sum(should_receipt_balance) as should_receipt_balance
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
and b.id not in (13354) -- 需剔除此标???
group by a.loaner_id
) a 
) a 
where rown<=10

select sum(case when rown<=10 then capital else 0 end) as 前10大借款人待还本金
,sum(capital) as 待还本金
,sum(case when rown<=10 then should_receipt_balance else 0 end) as 前10大借款人待还金额
,sum(should_receipt_balance) as 待还金额
,sum(case when rown<=10 then should_receipt_balance else 0 end)/sum(should_receipt_balance) as 前10大借款人待还金额占比
from (
select * 
,row_number() over(order by should_receipt_balance desc ) as rown
from (
select a.loaner_id,sum(a.capital) as capital,sum(should_receipt_balance) as should_receipt_balance
from receipt_detail a 
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6) 
and b.id not in (13354) -- 需剔除此标???
group by a.loaner_id
) a 
) a 


-- 投资用户年龄分布	"0-50岁占比 % 51-60岁占比 %  61岁以上占比 %"

select age_area
,count(1) as 在投人数
from (
select a.*
,case when age<=50 then '0-50岁'
 when age>50 and age<=60 then '51-60岁'
 when age>60 then '61岁以上'
 end as age_area
from (
select a.*
,b.birthday
,datediff(year,b.birthday,getdate()) as age
from (
select distinct investor_id
from receipt_detail a
inner join borrow b on a.borrow_id=b.id 
where a.status in (1,2)
and b.status in (4,5,6)
) a 
inner join member_id_card_info b on a.investor_id =b.member_id
) a 
) a 
group by age_area


select count(1) as c ,count(distinct member_id) as uv from member_id_card_info


--附件14：网络借贷信息中介机构运营数据
/*
撮合交易额（万元）	
投资人数（个）	
融资人数（个）	
标的数（个）	
发生逾期交易额（万元）
*/


-- 按照满标时间计算
select convert(varchar(4),b.full_time,120) as y
,sum(a.capital)/10000 as 撮合交易额_万元
,count(distinct a.investor_id) as 投资人数
,count(distinct a.loaner_id) as 融资人数
,count(distinct a.borrow_id) as 标的数
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.status in (4,5,6)
group by convert(varchar(4),b.full_time,120)
order by y desc


-- 逾期交易
select convert(varchar(4),need_receipt_time,120) as y,sum(capital) as capital,sum(receipt
from receipt_detail 
where status in (2)
group by  convert(varchar(4),need_receipt_time,120)
order by y
