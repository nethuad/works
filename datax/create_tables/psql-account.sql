
CREATE TABLE dbo_account(
CREATE TABLE dbo_account_dadd(
id bigint,
member_id bigint,
is_freeze boolean,
freeze2 numeric(19, 2),
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
version bigint,
type varchar(20),
available numeric(19, 2),
data_digest varchar(1000),
pt varchar(20)
)

