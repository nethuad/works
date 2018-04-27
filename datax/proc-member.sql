-- psql  -v pt="'20180424'" -f proc-member.sql "dbname=xueshandai user=xsd password=Xsd123$"

--\set pt '20180423'

-- 全量，第一次使用
--drop table IF EXISTS dbo_member_last;
--create table dbo_member_last as 
--select * 
--from dbo_member
--where pt=:pt
--;


drop table IF EXISTS dbo_member_merge;
create table dbo_member_merge as 
select id,username,password,out_password,status,reg_time,last_login_time,reg_ip,real_name,email,is_valid_email,mobile
,is_valid_mobile,idcard,is_valid_idcard,recommend_id,credit_point,credit_reason,credit_limit,freeze_credit_limit
,is_transfer,is_vip,is_recharge,is_withdraw,is_admin,date_created,last_updated,created_by,updated_by,version
,is_deleted,enabled,account_expired,account_locked,password_expired,reg_address,remark,avatar,is_old
,is_company,auth_reason,vip_end_date,reg_referer,uname,identity_change,reg_way
,pt
from (
select *
,row_number() over(partition by id order by pt desc) as rown
from (
select *
from dbo_member_last
union all 
select * 
from dbo_member_dadd
) a 
) a where rown = 1
;

--备份 dbo_member_last
drop table IF EXISTS dbo_member_last_bak;
alter table dbo_member_last rename to dbo_member_last_bak;

alter table dbo_member_merge rename to dbo_member_last;

-- 清空增量数据
DELETE FROM dbo_member_dadd;

--member
create table member_tmp as 
select id,username,password,out_password,status,reg_time,last_login_time,reg_ip,real_name,email,is_valid_email,mobile
,is_valid_mobile,idcard,is_valid_idcard,recommend_id,credit_point,credit_reason,credit_limit,freeze_credit_limit
,is_transfer,is_vip,is_recharge,is_withdraw,is_admin,date_created,last_updated,created_by,updated_by,version
,is_deleted,enabled,account_expired,account_locked,password_expired,reg_address,remark,avatar,is_old
,is_company,auth_reason,vip_end_date,reg_referer,uname,identity_change,reg_way
,pt
from dbo_member_last
;

drop table IF EXISTS member_bak;
alter table member rename to member_bak;
alter table member_tmp rename to member;


