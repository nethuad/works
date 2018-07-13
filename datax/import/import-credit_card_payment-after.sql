-- psql  -v pt="'20180424'" -f import-credit_card_payment-after.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

create table credit_card_payment as 
select id,member_id,account_id,cost_id,cash,fee,status,explain,handle_time,bank_name,bank_account,bank_city_id
,ip,real_name,handler_id,bank_sub_name,date_created,last_updated,created_by,updated_by
,version,merchant_no,trade_no,bank_code,platform_type,pay_way,current_withdraw
,pt
from dbo_credit_card_payment
;

