CREATE TABLE member_vip(
-- CREATE TABLE dbo_member_vip(
-- CREATE TABLE dbo_member_vip_dadd(
id bigint,
member_id bigint,
order_id bigint,
back_order_id bigint,
remark text,
begin_date varchar(50),
end_date varchar(50),
is_end boolean,
cash numeric(19, 2),
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
pt varchar(20)
)
;