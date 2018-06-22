CREATE TABLE account_withdraw(
-- CREATE TABLE dbo_account_withdraw(
-- CREATE TABLE dbo_account_withdraw_dadd(
id bigint,
member_id bigint,
account_id bigint,
cost_id bigint,
cash numeric(19, 2),
fee numeric(19, 2),
status int,
explain varchar(2000),
handle_time varchar(50),
bank_name varchar(200),
bank_account varchar(200),
bank_city_id bigint,
ip varchar(50),
date_created varchar(50),
real_name varchar(100),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
handler_id bigint,
bank_sub_name varchar(100),
current_success_cash numeric(19, 2),
balance numeric(18, 0),
remark varchar(500),
merchant_no varchar(100),
trade_no varchar(100),
bank_code varchar(50),
platform_type int,
withdraw_way int,
pt varchar(20)
)
;

