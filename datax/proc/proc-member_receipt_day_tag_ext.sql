-- 当日最后一笔回款无投资的客户之后的第一笔投资
-- 更新回款日期
drop table if exists member_receipt_day_tag_renew;
create table member_receipt_day_tag_renew as 
select a.*,b.receipt_time
from member_receipt_day_tag a 
left outer join receipt_detail b on a.receipt_id = b.id
;


-- 计算最近一笔投资
drop table if exists member_receipt_day_tag_first_invest;
create table member_receipt_day_tag_first_invest as 
select * from (
select a.*
,b.id as first_invest_id
,b.capital as first_invest_capital
,b.date_created as first_invest_date
,row_number() over(partition by a.receipt_id order by b.date_created asc) as rown_invest
,c.cycle_type as first_invest_cycle_type
,c.cycle as first_invest_cycle
from member_receipt_day_tag_renew a 
inner join borrow_invest b on a.investor_id=b.investor_id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and b.date_created>a.receipt_time
) a where rown_invest=1
;



-- 投资使用的红包

drop table if exists member_receipt_day_tag_first_invest_coupons;
create table member_receipt_day_tag_first_invest_coupons as 
select coupon_invest_id as invest_id,array_agg(batch_prefix) as coupon_prefix
from s_card_coupons_detail a 
inner join (
select distinct first_invest_id 
from member_receipt_day_tag_first_invest 
) b on a.coupon_invest_id = b.first_invest_id
group by coupon_invest_id
;



-- 提现时间，提现金额
drop table if exists member_receipt_day_tag_first_withdraw;
create table member_receipt_day_tag_first_withdraw as 
select * from (
select a.*
,b.handle_time as withdraw_time
,b.cash as withdraw_cash
,row_number() over(partition by a.receipt_id order by b.handle_time asc) as rown_withdraw
from member_receipt_day_tag_renew a 
inner join (select * from account_withdraw where status in (4)) b on a.investor_id=b.member_id
where b.handle_time>a.receipt_time
) a where rown_withdraw=1
;

-- 登录时间 member_signin
drop table if exists member_receipt_day_tag_first_login;
create table member_receipt_day_tag_first_login as 
select * from (
select a.*
,b.login_time as login_time
,row_number() over(partition by a.receipt_id order by b.login_time asc) as rown_login
from member_receipt_day_tag_renew a 
inner join (select member_id,date_created as login_time from member_signin) b on a.investor_id=b.member_id
where b.login_time>a.receipt_time
) a where rown_login=1
;

-- to_char(b.date_created::timestamp,'YYYY-MM-DD') as date_first_invest_d

-- select count(1) as c ,count(distinct (investor_id,receipt_id)) as uv from member_receipt_day_tag;

-- select count(1) as c ,count(distinct receipt_id) as uv from member_receipt_day_tag;

-- 汇总
drop table if exists member_receipt_day_tag_first_invest_ext;
create table member_receipt_day_tag_first_invest_ext as 
select a.*
,b.first_invest_id,b.first_invest_capital,b.first_invest_date,b.first_invest_cycle_type,b.first_invest_cycle
,b2.coupon_prefix
,c.withdraw_cash as first_withdraw_cash,c.withdraw_time as first_withdraw_time
,m.real_name
,mic.gender
,mic.birthday,extract(day from now()-mic.birthday::timestamp)/365 as age
,idt.district as province
,ml.login_time as first_login_time
from member_receipt_day_tag_renew a 
left outer join member_receipt_day_tag_first_invest b on a.receipt_id = b.receipt_id
left outer join member_receipt_day_tag_first_invest_coupons b2 on b.first_invest_id = b2.invest_id
left outer join member_receipt_day_tag_first_withdraw c on a.receipt_id = c.receipt_id
left outer join member m on a.investor_id=m.id
left outer join member_id_card_info mic on a.investor_id = mic.member_id
left outer join idcard_district idt on substring(mic.region from 1 for 2)||'0000'  = idt.prefix::varchar
left outer join member_receipt_day_tag_first_login ml on a.receipt_id=ml.receipt_id
;


