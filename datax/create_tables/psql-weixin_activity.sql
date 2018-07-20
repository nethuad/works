CREATE TABLE weixin_activity(
-- CREATE TABLE dbo_weixin_activity(
-- CREATE TABLE dbo_weixin_activity_dadd(
id bigint,
member_id bigint,
open_id varchar(255),
nick_name varchar(255),
head_imgurl varchar(255),
info varchar(1000),
user_id bigint,
user_open_id varchar(255),
user_nick_name varchar(255),
info_other varchar(1000),
myself boolean,
capital numeric(19, 2),
status int,
active_type int,
date_created varchar(50),
last_updated varchar(50),
version bigint,
pt varchar(20)
)
;
