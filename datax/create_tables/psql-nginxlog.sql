\c xueshandai

CREATE TABLE nginxlog (
topic varchar(100),
client varchar(100),
host varchar(100),
http_referer text,
http_user_agent varchar(1000),
protocol varchar(100),
proxy varchar(100),
request_method varchar(100),
size varchar(100),
status varchar(100),
timestamp varchar(100),
url text,
xsd_cid varchar(100),
xsd_uid varchar(100),
xsd_tag text,
d varchar(100)
);

CREATE TABLE nginxlog_base (
topic varchar(100),
client varchar(100),
host varchar(100),
http_referer text,
http_user_agent varchar(1000),
protocol varchar(100),
proxy varchar(100),
request_method varchar(100),
size varchar(100),
status varchar(100),
timestamp varchar(100),
url text,
xsd_cid varchar(100),
xsd_uid varchar(100),
xsd_tag text,
ip varchar(100),
referer_ps text,
url_ps text,
d varchar(100)
);

CREATE TABLE nginxlog_base_ext (
host varchar(100),
path text,
query text,
url text,
http_referer text,
http_user_agent varchar(1000),
request_method varchar(100),
size integer,
status integer,
timestamp varchar(100),
cid varchar(100),
uid bigint,
xsd_tag text,
ip varchar(100),
referer_ps text,
url_ps text,
d varchar(100)
);


CREATE TABLE nginxlog_base_ext (
host varchar(100),
path text,
query text,
url text,
http_referer text,
http_user_agent varchar(1000),
request_method varchar(100),
size integer,
status integer,
timestamp varchar(100),
cid varchar(100),
uid bigint,
xsd_tag text,
ip varchar(100),
referer_ps text,
url_ps text,
d varchar(100)
);



CREATE TABLE nginxlog_filter (
host varchar(100),
path text,
query text,
url text,
http_referer text,
http_user_agent varchar(1000),
request_method varchar(100),
size integer,
status integer,
timestamp varchar(100),
cid varchar(100),
uid bigint,
xsd_tag text,
ip varchar(100),
referer_ps text,
url_ps text,
d varchar(100)
);


CREATE TABLE nginxlog_flow_stat (
tbl varchar(100),
pv bigint,
uv_ip bigint,
uv_cid bigint,
uv_uid bigint,
d varchar(100)
);
 






CREATE TABLE nginxlog_ext (
topic varchar(100),
ip varchar(100),
host varchar(100),
http_referer text,
http_user_agent varchar(1000),
protocol varchar(100),
proxy varchar(100),
request_method varchar(100),
size varchar(100),
status varchar(100),
timestamp varchar(100),
url text,
d varchar(100),
referer_ps text,
url_ps text,
ip_city varchar(50),
channel varchar(50),
referer_host varchar(50),
url_type varchar(50),
url_details json
);


CREATE TABLE nginxlog_flow_count (
pv bigint,
uv bigint,
d varchar(100)
);


CREATE TABLE nginxlog_flow_mul_count (
pv bigint,
uv bigint,
ip3uv bigint,
d varchar(100)
);

CREATE TABLE nginxlog_referer_host_count (
referer_host varchar(100),
pv bigint,
uv bigint,
d varchar(100)
);


CREATE TABLE nginxlog_invite_register_base (
ip varchar(100),
host varchar(100),
url text,
d varchar(100)
);


