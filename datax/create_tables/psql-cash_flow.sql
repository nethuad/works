CREATE TABLE cash_flow(
-- CREATE TABLE dbo_cash_flow(
-- CREATE TABLE dbo_cash_flow_dadd(
id bigint,
account_id bigint,
event_type_id bigint,
change numeric(19, 2),
available_after numeric(19, 2),
freeze_after numeric(19, 2),
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
data_digest varchar(1000),
available_before numeric(19, 2),
freeze_before numeric(19, 2),
event_source bigint,
description varchar(600),
expand1 varchar(600),
expand2 varchar(600),
is_voucher boolean,
way int,
pt varchar(20)
)
;

