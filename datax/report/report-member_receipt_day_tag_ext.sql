/*
  剔除内投
*/
drop table if exists sp_member_receipt_day_tag_ext;
create table sp_member_receipt_day_tag_ext as
select receipt_id,invest_id,borrow_id,investor_id as member_id
,capital,receipt_time,invest_date,rown,rown2,is_last,d_stat,first_invest_id
,first_invest_capital,first_invest_date,first_invest_cycle_type,first_invest_cycle
,array_to_string(coupon_prefix,',') as coupon
,first_withdraw_cash,first_withdraw_time
,first_login_time
,real_name,gender,birthday,age::bigint as age,province
-- ,need_receipt_time::timestamp as ts
,receipt_time::timestamp as ts
,to_char(need_receipt_time::timestamp,'YYYY-MM-DD') as d_ts
from member_receipt_day_tag_first_invest_ext a 
left outer join member_inner b on a.investor_id=b.member_id
where b.member_id is null  
;