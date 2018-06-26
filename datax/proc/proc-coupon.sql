-- 分解 
drop table if exists s_cash_flow_voucher_extract;
create table s_cash_flow_voucher_extract as 
select id,account_id ,event_type_id,event_source,description
,cast(substring(description from '^投资标号\[(\d+)\]时使用') as bigint) as borrow_id
,cast(substring(description from '获取收益([\d\.]+)元') as numeric) as profit
,regexp_split_to_array(substring(description from '^投资标号\[\d+\]时使用(.*)[、,，]获取收益[\d\.]+元'),'[、,]') as voucher
,way,date_created
from s_cash_flow_voucher 
;

-- select count(1) as c,sum(profit) as profit from s_cash_flow_voucher_extract;
--  17460 | 5011810.92

-- 分解到每一个红包
drop table if exists s_cash_flow_voucher_extract_row;
create table s_cash_flow_voucher_extract_row as
select a.*
,b.coupon
,substring(coupon from '\[(.*)\]')  as coupon_id
,case when coupon ~ '红包' then '红包'
 when coupon ~ '加息比例' then '加息券'
 else '其他' end as coupon_type
,case when coupon ~ '红包' then cast(substring(coupon from '([\d\.]+)元红包') as numeric) 
 else profit end as coupon_profit
from s_cash_flow_voucher_extract a ,lateral(select unnest(voucher) as coupon) b
;

-- select count(1) as c,sum(coupon_profit) as coupon_profit from s_cash_flow_voucher_extract_row;

--    c   | coupon_profit
-- -------+---------------
--  20311 |    5011810.92

drop table if exists s_cash_flow_coupon;
create table s_cash_flow_coupon as
select a.id as cash_flow_id,account_id,b.member_id,event_source as invest_id,borrow_id
,a.profit as total_profit
,coupon_id,coupon_type,coupon_profit
,a.date_created
from s_cash_flow_voucher_extract_row a 
inner join account_cash b on a.account_id=b.id
;


-- select count(1) as c,sum(coupon_profit) as coupon_profit from s_cash_flow_coupon;

--    c   | coupon_profit
-- -------+---------------
--  20311 |    5011810.92
 
 

-- select coupon_type,count(1) as c,sum(coupon_profit) as coupon_profit 
-- from s_cash_flow_voucher_extract_row 
-- group by coupon_type;

-- select count(1) as c ,count(distinct coupon_id) as c2 from s_cash_flow_coupon;
--    c   |  c2
-- -------+-------
--  20311 | 20311



-- 匹配投资编号

drop table if exists s_card_coupons_detail;
create table s_card_coupons_detail as
select a.* 
,case when a.status in (1,5) then 1 else 0 end as is_used
,b.category as batch_category
,b.prefix as batch_prefix
,b.batch_desc
,b.amount as batch_amount
,b.red_rate as batch_red_rate
,b.convert_channel as batch_convert_channel
,b.cycle_type as batch_cycle_type
,b.cycle as batch_cycle
,b.investment_amount as batch_investment_amount
,c.member_id as coupon_member_id
,c.invest_id as coupon_invest_id
,c.borrow_id as coupon_borrow_id
,coupon_type,coupon_profit,total_profit
from card_coupons_detail a 
inner join card_coupons_batch b on a.batch_id=b.id
left outer join s_cash_flow_coupon c on a.id=c.coupon_id
where a.member_id is not null 
;

-- 根据红包按比例分配投资金额
drop table if exists card_coupons_invest_detail;
create table card_coupons_invest_detail as
select a.*
,b.date_created as invest_date
,case when b.id is not null then b.capital else 0 end as invest_capital
,case when b.id is not null then case when coupon_profit+0.01>total_profit then b.capital else b.capital/total_profit*coupon_profit end 
  else 0 end as coupon_invest_capital  -- 根据红包使用金额调整的投资金额
from s_card_coupons_detail a 
left outer join borrow_invest b on a.coupon_invest_id = b.id
;

-- 校验
-- select count(1) as  c from card_coupons_detail where member_id is not null;
-- 5347552

-- 是否有member_id or borrow_id匹配不正确
-- select count(1) as c 
-- from s_card_coupons_detail 
-- where coupon_type is not null
-- and (member_id <> coupon_member_id or cast(use_to as bigint) <> coupon_borrow_id)
-- ;

-- -- 匹配是否有invest_id 不想等
-- select batch_category,coupon_type,count(1) as c 
-- from s_card_coupons_detail 
-- where coupon_type is not null
-- and invest_id is not null
-- and not(invest_id = coupon_invest_id)
-- group by batch_category,coupon_type
-- ;

-- select amount, coupon_profit
-- from s_card_coupons_detail 
-- where is_used=1
-- and batch_prefix in ('0423','0424','0425','0426','0427','0428','0229')
-- and coupon_type='红包'
-- and amount <> coupon_profit
-- ;
