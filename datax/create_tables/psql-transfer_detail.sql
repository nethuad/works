CREATE TABLE transfer_detail(
-- CREATE TABLE dbo_transfer_detail(
-- CREATE TABLE dbo_transfer_detail_dadd(
id bigint,
version bigint,
capital numeric(19, 2),
capital_type int,
created_by bigint,
date_created varchar(50),
description varchar(255),
explain varchar(255),
handle_time varchar(50),
handler_id bigint,
ip varchar(255),
last_updated varchar(50),
payer_id bigint,
receiver_id bigint,
transfer_time varchar(50),
updated_by bigint,
pt varchar(20)
)
;

