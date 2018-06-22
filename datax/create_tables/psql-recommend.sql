CREATE TABLE recommend( --全量同步
-- CREATE TABLE dbo_recommend( --全量同步
-- CREATE TABLE dbo_recommend_dadd( --增量同步
id bigint,
version int,
approve_time varchar(50),
created_by bigint,
date_created varchar(50),
last_updated varchar(50),
member_id bigint,
referrer_id bigint,
status int,
updated_by bigint,
ip varchar(255),
admin_id bigint,
pt varchar(20)
)
;
