-- 用户账户数据
drop table if exists p_member_account_base;
create table p_member_account_base as 
select member_id,available as cash_available,freeze2 as cash_freeze,type 
from account 
where type='cash'
;



