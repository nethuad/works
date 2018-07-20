drop table if exists sp_borrow_wide;
create table sp_borrow_wide as
select *
,full_time::timestamp as ts
,to_char(full_time::timestamp,'YYYY-MM-DD') as d_ts
from borrow_wide
where status in (4,5,6)
and full_time<to_char(now(),'YYYY-MM-DD')
;
