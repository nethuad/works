drop table if exists sp_portrait_member_wide;
create table sp_portrait_member_wide as
select *
,reg_time::timestamp as ts
,to_char(reg_time::timestamp,'YYYY-MM-DD') as d_ts
from portrait_member_wide
;