-- activity-618.sql

-- 增值加息
可以根据invest_id匹配对应的奖励
select * from 
third_prize_detail where activity_type='18' 






create table activity_618_url_code(
urlname varchar,
urlcode varchar
);

insert into activity_618_url_code(urlname,urlcode) values
('弹屏APP','apptc'),
('BANNER_APP','appbanner'),
('BANNER_M','mbanner'),
('BANNER_PC','wbanner'),
('水军海报','post'),
('公众号推荐海报','wxhb'),
('公众号菜单','wxmenu'),
('推荐奖励_APP','appinvite'),
('推荐奖励_M','minvite'),
('推荐奖励_PC','winvite'),
('搜索_PC','wsearch'),
('搜索_M','msearch'),
('短信','sms'),
('活动分享','wxshare')
;


弹屏 APP	http://m.xueshandai.com/active/transfer?app=true&code=apptc	
BANNER APP	http://m.xueshandai.com/active/transfer?app=true&code=appbanner	
BANNER M	http://m.xueshandai.com/active/transfer?code=mbanner	
BANNER PC	http://m.xueshandai.com/active/transfer?code=wbanner	
水军海报	http://m.xueshandai.com/active/transfer?code=post	
公众号推荐海报	https://m.xueshandai.com/active/transfer?code=wxhb	
公众号菜单	https://m.xueshandai.com/active/transfer?code=wxmenu	
推荐奖励 APP	https://m.xueshandai.com/active/transfer?code=appinvite	
推荐奖励 M	https://m.xueshandai.com/active/transfer?code=minvite	
推荐奖励 PC	https://m.xueshandai.com/active/transfer?code=winvite	
搜索 PC	https://m.xueshandai.com/active/transfer?code=wsearch	
搜索 M	https://m.xueshandai.com/active/transfer?code=msearch	
短信	https://m.xueshandai.com/active/transfer?code=sms	
活动分享	https://m.xueshandai.com/active/transfer?code=wxshare




http://192.168.0.62:8090/pages/viewpage.action?pageId=1279198&focusedCommentId=1279468#comment-1279468

-- 查询活动
select * from activity18interest

-- 查询京东卡 
select * from red_envelopes where type=3 and award_type=1



8 0429
18	0430
30	0431
88	0432
200	0433
1000	0434

select id
,b.category as batch_category
,b.prefix as batch_prefix
,b.batch_desc
,b.amount as batch_amount
,b.red_rate as batch_red_rate
,b.convert_channel as batch_convert_channel
,b.cycle_type as batch_cycle_type
,b.cycle as batch_cycle
,b.investment_amount as batch_investment_amount
from card_coupons_batch b 
where prefix in ('0429','0430','0431','0432','0433','0434')
;


drop table if exists activity_member_618_new;
create table activity_member_618_new as 
select id as member_id_new 
from member 
where reg_time>='2018-06-16' and reg_time<'2018-06-26'
;

-- 活动的红包
drop table if exists activity_618;
create table activity_618 as 
select a.*
,case when b.member_id_new is not null then 1 else 0 end as is_member_new
from card_coupons_invest_detail a 
left outer join activity_member_618_new b on a.member_id=b.member_id_new
where batch_prefix in ('0429','0430','0431','0432','0433','0434')
;

select date_trunc('day',invest_date::TIMESTAMP) as d
,round(sum(coupon_invest_capital),0) as coupon_invest_capital
from card_coupons_invest_detail
where batch_prefix in ('0429','0430','0431','0432','0433','0434')
and invest_date is not null
group by date_trunc('day',invest_date::TIMESTAMP)
;

-- 每天抽奖次数
select date_trunc('day',valid_date::TIMESTAMP) as d
,count(1) as c
from card_coupons_invest_detail
where batch_prefix in ('0429','0430','0431','0432','0433','0434')
group by date_trunc('day',valid_date::TIMESTAMP)
;



-- 参与人数，投资时间限定在6月25日之前 
select count(1) as c
,count(distinct member_id) as uv
,count(case when is_member_new =1 then member_id else null end) as uv_new
,sum(case when is_used=1 and use_date<'2018-06-26' then 1 else 0 end) as c_used
,count(distinct case when is_used=1 and use_date<'2018-06-26' then member_id else null end) as used_uv
,count(case when is_member_new =1 and is_used=1 and use_date<'2018-06-26' then member_id else null end) as uv_new_used 
,count(distinct case when is_used=1 and use_date<'2018-06-26' then coupon_invest_id else null end) as c_invest
,count(distinct case when is_used=1 and use_date<'2018-06-26' then coupon_member_id else null end) as coupon_uv  
,sum(case when is_used=1 and use_date<'2018-06-26' then coupon_profit else 0 end) as coupon_profit
,sum(case when is_used=1 and use_date<'2018-06-26' then coupon_invest_capital else 0 end) as coupon_invest_capital
from activity_618
;

   c   |  uv  | uv_new | uv_new_used | c_used | used_uv | c_invest | coupon_uv | coupon_profit
-------+------+--------+-------------+--------+---------+----------+-----------+---------------
 10310 | 1353 |     90 |           0 |    437 |     204 |      345 |       182 |      81035.00
 
 
    c   |  uv  | uv_new | uv_new_used | c_used | used_uv | c_invest | coupon_uv | coupon_profit
-------+------+--------+-------------+--------+---------+----------+-----------+---------------
 15394 | 1572 |    203 |           2 |    834 |     319 |      699 |       319 |     186676.00


 
--  投资金额
select count(1) as c,count(distinct investor_id) as uv, sum(capital) as capital 
from borrow_invest a 
inner join (select distinct coupon_invest_id from activity_618 where use_date<'2018-06-26') b on a.id=b.coupon_invest_id
;

  c  | uv  |  capital
-----+-----+------------
 345 | 182 | 4738900.00


  c  | uv  |   capital
-----+-----+-------------
 699 | 319 | 10692500.00



 
 
 --  每日投资金额
select date_trunc('day',date_created::TIMESTAMP) as d
,count(1) as c
,count(distinct investor_id) as c_uv
, sum(capital) as capital 
from borrow_invest a 
inner join (select distinct coupon_invest_id from activity_618) b on a.id=b.coupon_invest_id
group by date_trunc('day',date_created::TIMESTAMP)
;
 
          d          | c  | c_uv |  capital
---------------------+----+------+------------
 2018-06-16 00:00:00 | 49 |   34 |  424100.00
 2018-06-17 00:00:00 | 64 |   49 | 1082800.00
 2018-06-18 00:00:00 | 43 |   40 |  647100.00
 2018-06-19 00:00:00 | 64 |   49 |  760500.00
 2018-06-20 00:00:00 | 85 |   59 | 1408600.00
 2018-06-21 00:00:00 | 40 |   32 |  415800.00
 
 
           d          |  c  | c_uv |  capital
---------------------+-----+------+------------
 2018-06-16 00:00:00 |  49 |   34 |  424100.00
 2018-06-17 00:00:00 |  64 |   49 | 1082800.00
 2018-06-18 00:00:00 |  43 |   40 |  647100.00
 2018-06-19 00:00:00 |  64 |   49 |  760500.00
 2018-06-20 00:00:00 |  85 |   59 | 1408600.00
 2018-06-21 00:00:00 |  78 |   58 | 1373900.00
 2018-06-22 00:00:00 |  57 |   53 |  870700.00
 2018-06-23 00:00:00 |  80 |   63 | 1131900.00
 2018-06-24 00:00:00 |  49 |   36 |  848400.00
 2018-06-25 00:00:00 | 130 |   86 | 2144500.00
 2018-06-26 00:00:00 |  58 |   32 |  729600.00
 2018-06-27 00:00:00 |  36 |   24 |  415700.00
 2018-06-28 00:00:00 |  38 |   20 |  489300.00
 2018-06-29 00:00:00 |  35 |   26 |  504900.00
 2018-06-30 00:00:00 |  37 |   29 |  702900.00
 2018-07-01 00:00:00 |  35 |   27 |  484000.00
 2018-07-02 00:00:00 |  17 |   16 |  252200.00




 --  标类型投资金额
select cycle_type,cycle
,count(1) as c
,count(distinct investor_id) as c_uv
, sum(capital) as capital 
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
inner join (select distinct coupon_invest_id from activity_618 where use_date<'2018-06-26') c on a.id=c.coupon_invest_id
group by cycle_type,cycle
;

 cycle_type | cycle |  c  | c_uv |  capital
------------+-------+-----+------+------------
          2 |     2 |  84 |   47 |  333700.00
          2 |     6 | 150 |   76 |  975500.00
          2 |    12 | 290 |  173 | 6339300.00
          2 |    18 | 175 |   97 | 3044000.00




-- 红包使用人数
select batch_prefix
,count(1) as c 
,count(distinct member_id) as uv
,sum(case when is_used=1 and use_date<'2018-06-26' then 1 else 0 end) as used
, count(distinct case when is_used=1 and use_date<'2018-06-26' then member_id else null end) as used_uv
from activity_618 
group by batch_prefix
order by batch_prefix;
;


 batch_prefix |  c   | uv  | used | used_uv
--------------+------+-----+------+---------
 0429         | 1440 | 782 |   51 |      41
 0430         | 1556 | 810 |   34 |      21
 0431         | 1641 | 811 |   87 |      59
 0432         | 1757 | 860 |   53 |      37
 0433         | 1859 | 873 |  151 |     102
 0434         | 2057 | 909 |   61 |      36
 
 
  batch_prefix |  c   |  uv  | used | used_uv
--------------+------+------+------+---------
 0429         | 2163 |  939 |  114 |      72
 0430         | 2319 |  977 |   53 |      29
 0431         | 2468 |  965 |  170 |      99
 0432         | 2594 | 1015 |   85 |      54
 0433         | 2777 | 1034 |  299 |     175
 0434         | 3073 | 1078 |  113 |      68




-- 每日抽奖人数
select date_trunc('day',date_created::TIMESTAMP) as d
,count(1) as c,count(distinct member_id) as uv
from activity_618
group by date_trunc('day',date_created::TIMESTAMP)
;

          d          |  c   | uv
---------------------+------+-----
 2018-06-16 00:00:00 | 2085 | 680
 2018-06-17 00:00:00 | 1904 | 619
 2018-06-18 00:00:00 | 1644 | 544
 2018-06-19 00:00:00 | 1483 | 487
 2018-06-20 00:00:00 | 1563 | 511
 2018-06-21 00:00:00 | 1487 | 487
 2018-06-22 00:00:00 | 144 |  48
 
 
           d          |  c   | uv
---------------------+------+-----
 2018-06-16 00:00:00 | 2085 | 680
 2018-06-17 00:00:00 | 1904 | 619
 2018-06-18 00:00:00 | 1644 | 544
 2018-06-19 00:00:00 | 1483 | 487
 2018-06-20 00:00:00 | 1563 | 511
 2018-06-21 00:00:00 | 1487 | 487
 2018-06-22 00:00:00 | 1387 | 455
 2018-06-23 00:00:00 | 1292 | 422
 2018-06-24 00:00:00 | 1214 | 395
 2018-06-25 00:00:00 | 1335 | 438

 
--  人均抽奖次数

select c,count(1) as cc
from (
select member_id,count(1) as c
from activity_618
group by member_id
) a 
group by c
order by c
;


-- 链接分析

select 
count(1) as c
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,count(distinct uid_new) as uv_uidnew
,count(distinct member_id_new) as uv_newer
,count(distinct b1.member_id) as uv_coupon
,count(distinct b2.member_id) as uv_coupon_used
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
left outer join (select distinct member_id from activity_618) b1 on a.uid_new=b1.member_id
left outer join (select distinct member_id from activity_618 where is_used=1 and use_date<'2018-06-26') b2 on a.uid_new=b2.member_id
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16' and d<'2018-06-26'
and path ~'active/transfer'
;



   c   | uv_cid | uv_uid | uv_uidnew | uv_newer | uv_coupon | uv_coupon_used
-------+--------+--------+-----------+----------+-----------+----------------
 12894 |   5928 |    360 |      1657 |      101 |      1432 |            354



select 
-- url
substring(query from 'code=([A-Za-z1-9]+)') as querycode
,urlname
,count(1) as c
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,count(distinct uid_new) as uv_uidnew
,count(distinct member_id_new) as uv_newer
,count(distinct b1.member_id) as uv_coupon
,count(distinct b2.member_id) as uv_coupon_used
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
left outer join (select distinct member_id from activity_618) b1 on a.uid_new=b1.member_id
left outer join (select distinct member_id from activity_618 where is_used=1 and use_date<'2018-06-26') b2 on a.uid_new=b2.member_id
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16' and d<'2018-06-26'
and path ~'active/transfer'
group by substring(query from 'code=([A-Za-z1-9]+)'),urlname
order by c desc 
;


 querycode |    urlname     |  c   | uv_cid | uv_uid | uv_uidnew | uv_newer | uv_coupon | uv_coupon_used
-----------+----------------+------+--------+--------+-----------+----------+-----------+----------------
 appbanner | BANNER_APP     | 6170 |   2114 |     11 |       955 |       28 |       901 |            268
 sms       | 短信           | 2060 |   2048 |      1 |        10 |        0 |         7 |              2
 wxmenu    | 公众号菜单     | 1593 |    533 |    213 |       309 |        7 |       291 |            102
 apptc     | 弹屏APP        | 1178 |    810 |      6 |       753 |       59 |       622 |            142
 wbanner   | BANNER_PC      |  690 |    222 |     83 |       173 |        5 |       159 |             67
 appinvite | 推荐奖励_APP   |  429 |    347 |      7 |        19 |       13 |        11 |              2
 mbanner   | BANNER_M       |  376 |    110 |     95 |       106 |        0 |       102 |             31
 wxshare   | 活动分享       |  311 |    170 |     32 |        53 |        5 |        51 |             20
 post      | 水军海报       |   50 |     34 |      2 |        11 |        0 |         9 |              2
 winvite   | 推荐奖励_PC    |   14 |     10 |      1 |         6 |        1 |         4 |              0
 wxhb      | 公众号推荐海报 |   13 |      6 |      2 |         4 |        0 |         4 |              1
 minvite   | 推荐奖励_M     |    9 |      4 |      1 |         2 |        0 |         2 |              0
           |                |    1 |      1 |      0 |         0 |        0 |         0 |              0



select 
-- url
substring(query from 'code=([A-Za-z1-9]+)') as querycode
,urlname
,d
,count(1) as c
-- ,count(distinct cid) as uv_cid
-- ,count(distinct uid) as uv_uid
-- ,count(distinct uid_new) as uv_uidnew
-- ,count(distinct member_id_new) as uv_newer
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16' and d<'2018-06-26'
and path ~'active/transfer'
group by substring(query from 'code=([A-Za-z1-9]+)'),urlname,d
;

-- ===========

-- create table a618_active_flow as 
-- select *
-- from nginxlog_uidnew 
-- where d>='2018-06-16' and d<'2018-06-26'
-- and path ~'active/transfer'
-- ;

-- drop table a618_uid;
-- create table a618_uid as 
-- select distinct uid_new as uid 
-- from a618_active_flow
-- where uid_new>0
-- ;


-- create table a618_invest as 
-- select investor_id,sum(capital) as capital
-- from borrow_invest a 
-- inner join borrow b on a.borrow_id=b.id
-- where a.date_created>='2018-06-16' and  a.date_created<'2018-06-26'
-- and a.status not in(0,2)
-- group by investor_id
-- ;

-- drop table a618_uid_info;
-- create table a618_uid_info as 
-- select uid
-- ,case when b.reg_time>='2018-06-16' then 'new' else 'old' end as reg
-- ,case when c.investor_id is not null then 1 else 0 end as is_investor
-- ,case when c.investor_id is not null then capital else 0 end as capital
-- from a618_uid a 
-- inner join member b on a.uid=b.id
-- left outer join a618_invest c on a.uid=c.investor_id
-- ;


-- select reg,is_investor,count(1),sum(capital) as capital
-- from a618_uid_info
-- group by reg,is_investor
-- ;


-- select url,count(1) as pv 
-- from a618_active_flow
-- group by url
-- ;


-- create table a618_detail as 
-- select a.*
-- ,b.reg,b.is_investor
-- from nginxlog_uidnew a 
-- left outer join a618_uid_info b on a.uid_new = b.uid
-- where d>='2018-06-16'
-- and path ~'active/transfer'
-- ;

-- select url,reg
-- ,count(1) as pv,count(distinct uid_new) as uv
-- from a618_detail
-- group by url,reg
-- ;



--- 投资排名sqlserver
select id as member_id 
into #member_inner
from member
where id in (
131,11282,15600,22345,22346,22347,22348,22367,22369,22372,22444,22457,22462,22538,22539,22571,22804,
24523,25053,25054,25055,25936,26249,26260,26812,29187,29490,29495,29597,29600,29696,29761,30265,30357,
30514,30515,30517,31033,31073,31094,84593,84595,84596,84598,84599,84602,84603,84608,84610,85199,85200,
85201,85203,85204,85207,85209,85218,85219,85220,85356,85357,85358,85360,89600,89601,279385
)


select investor_id
,case when c.member_id is null then 'outer' else 'inner' end as member_type
,sum(capital) as capital
into #2
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
left outer join #member_inner c on a.investor_id=c.member_id
where a.date_created>='2018-06-16' and a.date_created<'2018-06-26'
and b.status in (4,5,6)
group by investor_id,case when c.member_id is null then 'outer' else 'inner' end
order by capital desc 


select sum(capital) as capital
from #2 
where member_type='outer'
and capital>=10000

