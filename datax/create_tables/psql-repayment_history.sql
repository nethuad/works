
CREATE TABLE dbo_repayment_history(
CREATE TABLE dbo_repayment_history_dadd(
id bigint,
version bigint,
borrow_id bigint,
capital numeric(19, 2),
company_overdue_fee numeric(19, 2),
displace_id bigint,
interest numeric(19, 2),
member_id bigint,
member_overdue_fee numeric(19, 2),
repay_id bigint,
repay_time varchar(50),
total numeric(19, 2),
created_by bigint,
date_created varchar(50),
last_updated varchar(50),
updated_by bigint,
type int,
pt varchar(20)
)

