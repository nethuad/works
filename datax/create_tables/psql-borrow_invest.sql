CREATE TABLE borrow_invest(
-- CREATE TABLE dbo_borrow_invest(
-- CREATE TABLE dbo_borrow_invest_dadd(
id bigint,
borrow_id bigint,
investor_id bigint,
loaner_id bigint,
capital numeric(19, 2),
activate_time varchar(50) ,
interest numeric(19, 2),
back_prize numeric(19, 2),
status int,
date_created varchar(50) ,
last_updated varchar(50) ,
created_by bigint,
updated_by bigint,
version bigint,
is_vip boolean,
loan_fee numeric(19, 2),
loan_fee_rate numeric(19, 4) ,
is_be_overdue boolean,
is_be_overdueing boolean,
capital_type varchar(16),
invest_way varchar(50) ,
contract bigint,
pt varchar(20)
)
;

