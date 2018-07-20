CREATE TABLE register_attach_info(
-- CREATE TABLE dbo_register_attach_info(
-- CREATE TABLE dbo_register_attach_info_dadd(
id bigint,
register_user_id varchar(100),
register_user_name varchar(100),
req_ip varchar(50),
req_url text,
req_param text,
referer text,
register_location int,
referer_type int,
sid varchar(100),
date_created varchar(50),
version bigint,
last_updated varchar(50),
created_by bigint,
updated_by bigint,
pt varchar(20)
)
;

