use xueshandai


select * from #member_inner

select id as member_id 
into #member_inner
from member
where id in (
131,11282,15600,22345,22346,22347,22348,22367,22369,22372,22444,22457,22462,22538,22539,22571,22804,
24523,25053,25054,25055,25936,26249,26260,26812,29187,29490,29495,29597,29600,29696,29761,30265,30357,
30514,30515,30517,31033,31073,31094,84593,84595,84596,84598,84599,84602,84603,84608,84610,85199,85200,
85201,85203,85204,85207,85209,85218,85219,85220,85356,85357,85358,85360,89600,89601,279385
)


investor_id	real_name	capital
31033	曹得天	10843494.00
29597	窦志红	9493617.00
131	韩书文	8591846.00
22457	戈修平	7807484.00
22348	樊韩博	7655885.00
30357	王毅飞	7433904.00
33007	郭树平	7324521.00
36962	杨婷	7209032.00
85220	陈小莲	7165752.00
22367	胡苑	6958712.00



select count(1) from #member_inner

-- 待收本金


drop table #1 

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @end_date = '2018-08-01'

select investor_id,sum(a.capital) as capital
into #1
from receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
where b.full_time <@end_date
and b.status in (4,5,6)
and ( (need_receipt_time>=@end_date and a.status=1) --
   or (need_receipt_time>=@end_date and a.status=4 and receipt_time>=@end_date) --截止日期之后还的
   or (need_receipt_time<@end_date and a.status=2) -- 截止日期之前需还，但是目前逾期的
   or (need_receipt_time<@end_date and a.status=4 and receipt_time>=@end_date) -- 截止日期之前需还，但是截止日期之后还的
)
group by investor_id
;

select investor_id as 用户id,b.uname as 用户名
,case when c.member_id is not null then '内投' else '外投' end as 用户类型
,capital as 待收本金
from #1 a 
left outer join member b on a.investor_id = b.id
left outer join #member_inner c on a.investor_id=c.member_id



-- 投资金额
drop table #2

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-07-01'
SET @end_date = '2018-08-01'

select investor_id,borrow_id,capital
,b.cycle_type,b.cycle
,a.status
into #2
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where b.full_time>=@begin_date and b.full_time<@end_date and b.status in (4,5,6)
and a.status not in (0,2)

select status,count(1) as c from #2 group by status
select sum(capital) as capital from #2

select investor_id as 用户id,b.uname as 用户名
,case when c.member_id is not null then '内投' else '外投' end as 用户类型
,case when cycle_type=1 then '天' when cycle_type=2 then '月' end as 周期类型
,cycle as 借款周期
,sum(capital) as 投资金额
from #2 a 
left outer join member b on a.investor_id = b.id
left outer join #member_inner c on a.investor_id=c.member_id
group by investor_id,b.uname,case when c.member_id is not null then '内投' else '外投' end,cycle_type,cycle



-- 内投回款(本金、利息) -- 月末计算

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-08-01'
SET @end_date = '2018-09-01'


select @begin_date as begin_date,@end_date as end_date
,case when mi.member_id is not null then '内投' else '外投' end as 用户类型
,sum(capital) as capital,sum(interest) as interest 
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
left outer join #member_inner mi on a.investor_id=mi.member_id
where  a.status =1
and b.status in (4,5,6)
and need_receipt_time>=@begin_date and need_receipt_time<@end_date
group by case when mi.member_id is not null then '内投' else '外投' end

--begin_date	end_date	用户类型	capital	interest
--2018-08-01	2018-09-01	内投	64366007.00	2075463.98
--2018-08-01	2018-09-01	外投	43093993.00	3800622.99

DECLARE @begin_date varchar(10)
DECLARE @end_date varchar(10)
SET @begin_date = '2018-08-01'
SET @end_date = '2018-09-01'

select a.investor_id as 用户id
,m.uname as 用户名
,capital as 本金
,interest as 利息
,need_receipt_time as 回款时间
from receipt_detail a 
inner join borrow b on a.borrow_id = b.id
left outer join member m on a.investor_id = m.id
left outer join #member_inner mi on a.investor_id=mi.member_id
where  a.status =1
and b.status in (4,5,6)
and need_receipt_time>=@begin_date and need_receipt_time<@end_date
and mi.member_id is not null
order by 回款时间




