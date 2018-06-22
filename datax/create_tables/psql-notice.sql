CREATE TABLE notice(
-- CREATE TABLE dbo_notice(
-- CREATE TABLE dbo_notice_dadd(
id bigint,
version bigint,
created_by bigint,
date_created varchar(50),
last_updated varchar(50),
receive_no varchar(100),
receive_type int,
receiver_id bigint,
send_time varchar(50),
status int,
type_id bigint,
updated_by bigint,
content text,
return_code varchar(50),
title varchar(200),
sms_return_code varchar(255),
sms_channel varchar(1000),
pt varchar(20)
)
;