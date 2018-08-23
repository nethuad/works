CREATE TABLE #member_inner
(
    member_id bigint
)

select * from #member_inner

insert into #member_inner(member_id) values
(131),
(11282),
(15600),
(22345),
(22346),
(22347),
(22348),
(22367),
(22369),
(22372),
(22444),
(22457),
(22462),
(22538),
(22539),
(22571),
(22804),
(24523),
(25053),
(25054),
(25055),
(25936),
(26249),
(26260),
(26812),
(29187),
(29490),
(29495),
(29597),
(29600),
(29696),
(29761),
(30265),
(30357),
(30514),
(30515),
(30517),
(31033),
(31073),
(31094),
(84593),
(84595),
(84596),
(84598),
(84599),
(84602),
(84603),
(84608),
(84610),
(85199),
(85200),
(85201),
(85203),
(85204),
(85207),
(85209),
(85218),
(85219),
(85220),
(85356),
(85357),
(85358),
(85360),
(89600),
(89601),
(279385)



 select investor_id,uname
 ,case when c.member_id is null then 'outer' else 'inner' end as investor_type
 ,sum(capital) as capital_sum
 from borrow_invest  a 
 inner join  member b on a.investor_id=b.id
 left outer join #member_inner c on a.investor_id=c.member_id
 where a.date_created>='2018-06-16' and a.date_created<'2018-06-26'
 group by investor_id,uname,case when c.member_id is null then 'outer' else 'inner' end
 order by capital_sum desc 



-- =====================================
use xueshandai
select * from card_coupons_batch


select * from xueshandai.dbo.card_coupons_batch where batch_desc like '66营销%'

use xueshandai

-- 66营销活动
select * from xueshandai.dbo.card_coupons_batch where prefix in ('0423','0424','0425','0426','0427','0428','0229')

select top 10 * from card_coupons_detail where id='0184L9JNXLS7'
use_to	use_date	version	invest_id
12492	2017-11-30 18:42:32.1370000	2	37466

select * from borrow_invest where id =37466



select * from account where member_id = 103777 order by id desc 

291710

select * from cash_flow where account_id = 291710 and date_created>='2018-04-04' and  date_created<'2018-04-05' order by id desc

drop table #1
select a.id,a.batch_id,b.prefix,b.batch_desc,b.category,b.amount as amount_red,b.red_rate
,a.amount,a.valid_date,a.invalid_date
,member_id
,a.status,case when a.status in (1,5) then 1 else 0 end as is_used
,use_to,invest_id,use_date
,a.date_created,a.last_updated
into #1
from card_coupons_detail a 
inner join (
  select * from card_coupons_batch where prefix in ('0423','0424','0425','0426','0427','0428','0229')
) b on a.batch_id=b.id 
and member_id is not null

select *
from card_coupons_detail a 
inner join (
  select * from card_coupons_batch where prefix in ('0431')
) b on a.batch_id=b.id 
and member_id is not null

drop table tmp1;
create table tmp1 as 
select a.* 
,a.status,case when a.status in (1,5) then 1 else 0 end as is_used
,b.category as batch_category
,b.prefix as batch_prefix
,b.batch_desc
,b.amount as batch_amount
,b.red_rate as batch_red_rate
,b.convert_channel as batch_convert_channel
,b.cycle_type as batch_cycle_type
,b.cycle as batch_cycle
,b.investment_amount as batch_investment_amount
from card_coupons_detail a 
inner join card_coupons_batch b on a.batch_id=b.id
where a.member_id is not null 
;
;

select batch_category,batch_red_rate,count(1) as c from tmp1 group by batch_category,batch_red_rate


select * from card_coupons_batch a where category=1
inner join (select distinct batch_id  from card_coupons_detail) b on a.id=b.batch_id

select distinct category from card_coupons_batch

select batch_id,count(1) as c from card_coupons_detail group by batch_id


select top 10 * from card_coupons_detail where date_created>'2018-01-01' and 

-- 去除内投
select a.*
into #2
from #1 a 
left outer join #member_inner b on a.member_id=b.member_id
where b.member_id is null


select prefix,batch_desc,amount_red,red_rate
,count(1) as 发送量 
,sum(is_used) as  使用量
,sum(case when is_used=1 then amount_red else 0 end) red_amount
from #2
group by prefix,batch_desc,amount_red,red_rate
order by prefix


select top 10 * from #member_inner

select distinct a.member_id from #1 a inner join #member_inner b on a.member_id = b.member_id



-- 有invest_id的标记 <=> 加息券
drop table #jiaxiquan
select a.*,b.investor_id,b.borrow_id,b.capital,b.id as invest_id_2,'加息券' as type
into #jiaxiquan
from #2 a 
left outer join borrow_invest b on a.invest_id=b.id
where is_used =1 and invest_id is not null 

# 加息成本
select count(distinct investor_id) as member_c,sum(capital) as capital, sum(capital*red_rate) as jiaxi from #jiaxiquan
capital	jiaxi
5238800.00	104776.000000

/* 加息校对
select top 10 * from #jiaxiquan
0.02,member_id=379500,capital=40000.00,borrow_id=13274
select * from account where member_id=379500 and type='cash'
select top 10 * from cash_flow where account_id=1118642 order by id desc
*/


-- 无invest_id的标记 <=>红包
drop table #hongbao
select a.*,b.investor_id,b.borrow_id,b.capital,b.id as invest_id_2,'红包' as type
into #hongbao
from #2 a 
left outer join borrow_invest b on a.member_id=b.investor_id and a.use_to=b.borrow_id
where is_used =1 and invest_id is null

select count(distinct investor_id) as member_c,sum(amount_red) as amount_red from #hongbao


/* 红包校对
select top 10 * from #hongbao
8 member_id=428882,borrow_id=13261
select * from account where member_id=428882 and type='cash'
select top 10 * from cash_flow where account_id=1266788 order by id desc

*/

-- 去重
drop table #invest_used
select b.invest_id,a.investor_id,a.borrow_id,a.capital,a.date_created
into #invest_used
from borrow_invest a 
inner join ( select distinct invest_id_2 as invest_id from (select * from #jiaxiquan union all select * from #hongbao) a ) b on a.id=b.invest_id
where a.date_created<'2018-06-12'

select count(1) as c, count(distinct invest_id) as c2 from #invest_used

drop table #a
select a.*,case when c.investor_id is not null then 1 else 0 end as used
into #a
from borrow_invest a
left outer join #member_inner b on a.investor_id=b.member_id
left outer join #invest_used c on a.id=c.invest_id
where a.status in (0,1,3)
and b.member_id is null
and a.date_created>='2018-06-06'

select convert(varchar(10),date_created,120) as d,used,sum(capital) as capital
from #a 
group by convert(varchar(10),date_created,120),used


inner join borrow b on a.borrow_id = b.id
where b.status in (4,5,6)




select min(date_created) as a ,max(date_created) as b
from #invest_used

select * from #invest_used where date_created>'2018-06-12'

select * from #2 where member_id = 108316 and use_to=13286

select * from borrow_invest where investor_id=108316 and borrow_id=13286

select count(1) as c
,count(distinct invest_id) as invest_c
,count(distinct investor_id) as investor_c
,count(distinct borrow_id) as borrow_c
,sum(capital) as capital 
from #invest

--c	invest_c	investor_c	borrow_c	capital
--394	394	265	23	9721700.00



select * from member_id where id=