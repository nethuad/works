CREATE TABLE card_coupons_detail(
-- CREATE TABLE dbo_card_coupons_detail_dadd(
-- CREATE TABLE dbo_card_coupons_detail(
id varchar(50),
batch_id bigint,
amount numeric(18, 2),
member_id bigint,
valid_date varchar(50),
invalid_date varchar(50),
status int,
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
use_to varchar(100),
use_date varchar(50),
version int,
invest_id bigint,
pt varchar(20)
)
;

