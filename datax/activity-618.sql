-- activity-618.sql

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
where reg_time>='2018-06-16'
;


drop table if exists activity_618;
create table activity_618 as 
select a.*
,case when b.member_id_new is not null then 1 else 0 end as is_member_new
from s_card_coupons_detail a 
left outer join activity_member_618_new b on a.member_id=b.member_id_new
where batch_prefix in ('0429','0430','0431','0432','0433','0434')
;

-- 参与人数 
select count(1) as c
,count(distinct member_id) as uv
,count(case when is_member_new =1 then member_id else null end) as uv_new
,count(case when is_member_new =1 and is_used=1 then member_id else null end) as uv_new_used
,sum(is_used) as c_used
,count(distinct case when is_used=1 then member_id else null end) as used_uv
,count(distinct coupon_invest_id) as c_invest
,count(distinct coupon_member_id) as coupon_uv  
,sum(coupon_profit) as coupon_profit
from activity_618
;

   c   |  uv  | uv_new | uv_new_used | c_used | used_uv | c_invest | coupon_uv | coupon_profit
-------+------+--------+-------------+--------+---------+----------+-----------+---------------
 10310 | 1353 |     90 |           0 |    437 |     204 |      345 |       182 |      81035.00

 
--  投资金额
select count(1) as c,count(distinct investor_id) as uv, sum(capital) as capital 
from borrow_invest a 
inner join (select distinct coupon_invest_id from activity_618) b on a.id=b.coupon_invest_id
;

  c  | uv  |  capital
-----+-----+------------
 345 | 182 | 4738900.00

 
 
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



 --  标类型投资金额
select cycle_type,cycle
,count(1) as c
,count(distinct investor_id) as c_uv
, sum(capital) as capital 
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
inner join (select distinct coupon_invest_id from activity_618) c on a.id=c.coupon_invest_id
group by cycle_type,cycle
;





-- 红包使用人数
select batch_prefix
,count(1) as c 
,count(distinct member_id) as uv
,sum(is_used) as used
, count(distinct case when is_used=1 then member_id else null end) as used_uv
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

select count(1) as c
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,count(distinct uid_new) as uv_uidnew
,count(distinct member_id_new) as uv_newer
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
where d>='2018-06-16'
and path ~'active/transfer'
;

  c   | uv_cid | uv_uid | uv_uidnew | uv_newer
------+--------+--------+-----------+----------
 7333 |   3063 |    306 |      1327 |       40
 
 
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
left outer join (select distinct member_id from activity_618 where is_used=1) b2 on a.uid_new=b2.member_id
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16'
and path ~'active/transfer'
;


  c   | uv_cid | uv_uid | uv_uidnew | uv_newer | uv_coupon | uv_coupon_used
------+--------+--------+-----------+----------+-----------+----------------
 7333 |   3063 |    306 |      1327 |       40 |      1190 |            187




 
 
select count(distinct uid_new) as c 
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
where d>='2018-06-16'
and path ~'active/transfer'
;

drop table tmp1;
create table tmp1 as 
select a.member_id,b.uid_new
from (select distinct member_id from activity_618) a 
left outer join (
select distinct uid_new
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
where d>='2018-06-16'
and path ~'active/transfer'
) b on a.member_id = b.uid_new
;

select count(distinct member_id) as c1,count(distinct uid_new) as c2 from tmp1;
107932 |
104082 |
977561 |
980337 |

select * from activity_618 where member_id in (284319)

select a.member_id,date_created  from activity_618 a
inner join (select * from tmp1 where uid_new is null) b on a.member_id=b.member_id order by date_created limit 2000;

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
left outer join (select distinct member_id from activity_618 where is_used=1) b2 on a.uid_new=b2.member_id
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16'
and path ~'active/transfer'
group by substring(query from 'code=([A-Za-z1-9]+)'),urlname
order by c desc 
;



select 
-- url
substring(query from 'code=([A-Za-z1-9]+)') as querycode
,urlname
,d
,count(1) as c
,count(distinct cid) as uv_cid
,count(distinct uid) as uv_uid
,count(distinct uid_new) as uv_uidnew
,count(distinct member_id_new) as uv_newer
from nginxlog_uidnew a 
left outer join activity_member_618_new b on a.uid_new = b.member_id_new
left outer join activity_618_url_code c on substring(query from 'code=([A-Za-z1-9]+)')=c.urlcode
where d>='2018-06-16'
and path ~'active/transfer'
group by substring(query from 'code=([A-Za-z1-9]+)'),urlname,d
;










