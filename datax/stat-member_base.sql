--用户宽表 member_base

drop table IF EXISTS member_base_tmp;
create table member_base_tmp as 
select a.id as member_id,a.uname,reg_time
,is_valid_idcard,is_admin
,case when reg_way like 'Android%' then 'Android' else reg_way end as reg_way
,case when referrer_id is not null then 1 else 0 end as is_recommended
,referrer_id as recommender_id
,case when c.member_id is not null then 1 else 0 end as is_inner
from member a 
left outer join recommend b on a.id=b.member_id
left outer join member_inner c on a.id=c.member_id
;

drop table IF EXISTS member_base_bak;
alter table member_base rename to member_base_bak;
alter table member_base_tmp rename to member_base;



/* member
    outPassword 支付密码
    isValidIdcard 通过认证用户
    creditReason 授信额度原因
    creditLimit 授信额度
    freezeCreditLimit 冻结授信额度
    authReason 审核原因
    isTransfer 是否流转会员 ，# 流转会员是指可以发标的用户
    isRecharge 允许充值
    isWithdraw 允许体现
    regReferer 注册时的来源
    identityChange 1:理财用户,2:借款用户
    regWay: 注册的平台方式:web，IOS,mobile(h5),Android 
*/