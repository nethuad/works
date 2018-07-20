CREATE TABLE account_bank(
-- CREATE TABLE dbo_account_bank(
-- CREATE TABLE dbo_account_bank_dadd(
id bigint,
member_id bigint,
bank_name varchar(200),
bank_account varchar(500),
version bigint,
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
bank_sub_name varchar(100),
bank_city_id bigint,
operate_status int,
authenticate_status int,
auditing_status int,
bank_code varchar(255),
auditing_delete_status int,
third_bank_code varchar(50),
third_bank_id varchar(50),
pt varchar(20)
)
;

