--用户宽表 member_wide

drop table IF EXISTS member_wide_tmp;
create table member_wide_tmp as 
select *
from member_base
;

drop table IF EXISTS member_wide_bak;
alter table member_wide rename to member_wide_bak;
alter table member_wide_tmp rename to member_wide;

