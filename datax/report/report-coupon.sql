select 'report-coupon.sql' as script;


drop table if exists sp_card_coupons_invest_detail;
create table sp_card_coupons_invest_detail as
select *
,CAST(valid_date as timestamp) as date_get
,CAST(invest_date as timestamp) as date_invest
,to_char(CAST(valid_date as timestamp),'YYYY-MM-DD') as d_get
,to_char(CAST(invest_date as timestamp),'YYYY-MM-DD') as d_invest
from card_coupons_invest_detail a 
;


COMMENT ON TABLE sp_card_coupons_invest_detail IS '优惠券发送使用';
COMMENT ON COLUMN sp_card_coupons_invest_detail.batch_prefix IS '优惠券前缀';