
CREATE TABLE dbo_receipt_history(
CREATE TABLE dbo_receipt_history_dadd(
id bigint,
version bigint,
borrow_id bigint,
capital numeric(19, 2),
interest numeric(19, 2),
investor_id bigint,
is_proxy_repay int,
member_overdue_fee numeric(19, 2),
receipt_id bigint,
receipt_time varchar(50),
repay_history_id bigint,
total numeric(19, 2),
pt varchar(20)
);

