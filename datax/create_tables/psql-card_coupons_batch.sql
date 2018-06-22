CREATE TABLE card_coupons_batch(
CREATE TABLE dbo_card_coupons_batch_dadd(
CREATE TABLE dbo_card_coupons_batch(
id bigint,
prefix varchar(10),
category bigint,
amount numeric(19, 2),
num bigint,
valid_date varchar(50),
invalid_date varchar(50),
status bigint,
batch_desc text,
date_created varchar(50),
last_updated varchar(50),
created_by bigint,
updated_by bigint,
convert_channel bigint,
convert_ratio bigint,
use_range bigint,
valid_day bigint,
version bigint,
red_rate numeric(19, 4),
cycle bigint,
cycle_type bigint,
investment_amount bigint,
open_setting boolean,
left_day bigint,
template_id bigint,
pt varchar(20)
)
;

