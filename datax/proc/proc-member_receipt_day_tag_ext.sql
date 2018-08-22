-- 当日最后一笔回款无投资的客户之后的第一笔投资

-- 计算最近一笔投资
drop table if exists member_receipt_day_tag_first_invest;
create table member_receipt_day_tag_first_invest as 
select * from (
select a.*
,b.id as invest_id
,b.capital as first_invest_capital
,b.date_created as date_first_invest
,row_number() over(partition by a.d_stat,a.investor_id,a.receipt_id order by b.date_created asc) as rown_invest
,c.cycle_type,c.cycle
from member_receipt_day_tag a 
inner join borrow_invest b on a.investor_id=b.investor_id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and b.date_created>a.need_receipt_time
) a where rown_invest=1
;



-- 投资使用的红包

drop table if exists member_receipt_day_tag_first_invest_coupons;
create table member_receipt_day_tag_first_invest_coupons as 
select coupon_invest_id as invest_id,array_agg(batch_prefix) as coupon_prefix
from s_card_coupons_detail a 
inner join (
select distinct invest_id 
from member_receipt_day_tag_first_invest 
) b on a.coupon_invest_id = b.invest_id
group by coupon_invest_id
;



-- 提现时间，提现金额
drop table if exists member_receipt_day_tag_first_withdraw;
create table member_receipt_day_tag_first_withdraw as 
select * from (
select a.*
,b.handle_time as withdraw_time
,b.cash as withdraw_cash
,row_number() over(partition by a.d_stat,a.investor_id,a.receipt_id order by b.handle_time asc) as rown_withdraw
from member_receipt_day_tag a 
inner join (select * from account_withdraw where status in (4)) b on a.investor_id=b.member_id
where b.handle_time>a.need_receipt_time
) a where rown_withdraw=1
;



-- to_char(b.date_created::timestamp,'YYYY-MM-DD') as date_first_invest_d

-- select count(1) as c ,count(distinct (investor_id,receipt_id)) as uv from member_receipt_day_tag;

-- select count(1) as c ,count(distinct receipt_id) as uv from member_receipt_day_tag;



-- 匹配
/*
drop table if exists member_receipt_day_tag_first_invest_time;
create table member_receipt_day_tag_first_invest_time as 
select a.*
,b.date_first_invest,b.date_first_invest_d
,EXTRACT(DAY FROM (b.date_first_invest_d::timestamp-a.d_stat::timestamp)) as days_span
from member_receipt_day_tag a 
left outer join member_receipt_day_last_first_invest b on a.d_stat=b.d_stat and a.investor_id=b.investor_id
;
*/
