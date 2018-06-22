CREATE TABLE receipt_detail(
-- CREATE TABLE dbo_receipt_detail(
-- CREATE TABLE dbo_receipt_detail_dadd(
id bigint,
invest_id bigint,
borrow_id bigint,
investor_id bigint,
loaner_id bigint,
capital numeric(19, 2),
interest numeric(19, 2),
receipt_time varchar(50),
need_receipt_time varchar(50),
interest_cost_fee numeric(19, 2),
need_overdue varchar(50),
issue varchar(10),
is_be_overdue boolean,
status int,
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
overdue_time varchar(50),
receipt_type int,
should_receipt_balance numeric(19, 2),
should_receipt_fee numeric(19, 2),
fact_receipt_balance numeric(19, 2),
fact_receipt_fee numeric(19, 2),
displace_type int,
receipt_process int,
is_proxy_repay boolean,
is_overdue_repay boolean,
capital_type varchar(16),
pt varchar(20)
)
;

