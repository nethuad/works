CREATE TABLE repayment_detail(
-- CREATE TABLE dbo_repayment_detail(
-- CREATE TABLE dbo_repayment_detail_dadd(
id bigint,
invest_id bigint,
borrow_id bigint,
capital numeric(19, 2),
interest numeric(19, 2),
repayment_time varchar(50),
need_repayment_time varchar(50),
need_overdue_time varchar(50),
is_be_overdue boolean,
is_proxy_repay boolean,
status int,
member_id bigint,
issue varchar(10),
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
cost_id bigint,
repay_type int,
is_overdue_repay boolean,
is_be_overdueing boolean,
is_displace_repay boolean,
is_displaced boolean,
overdue_time varchar(50),
should_repay_balance numeric(19, 2),
should_repay_fee numeric(19, 2),
fact_repay_balance numeric(19, 2),
fact_repay_fee numeric(19, 2),
displace_type int,
repay_process int,
newly_overdue_time varchar(50),
displace_status int,
displace_money numeric(19, 2),
pt varchar(20)
)
;

