/*

-- 优惠券（包括红包）使用的编号
select * from mold where code='voucher_to_cash_turn_in'

-- 优惠券（包括红包）使用的投资id invest_id = event_source
create table s_cash_flow_voucher as 
select id,account_id ,event_type_id,event_source,description,way,date_created
from cash_flow 
where 1=1
and date_created>='2017-01-01'  --限定2017年之后
and event_type_id=76 
and way=3
;

-- 校验
select description
from s_cash_flow_voucher
where date_created>='2017-01-01'
and description !~ '^投资标号\[\d+\]时使用.*获取收益[\d\.]+元'
limit 10
;

*/

delete from s_cash_flow_voucher 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO s_cash_flow_voucher 
SELECT id,account_id ,event_type_id,event_source,description,way,date_created
FROM cash_flow
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
and event_type_id=76 
and way=3
;

