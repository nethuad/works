create table a618_tmp1 as 
select *
from nginxlog_uidnew 
where d>='2018-06-16'
and path ~'active/transfer'
;

drop table a618_uid;
create table a618_uid as 
select distinct uid_new as uid 
from a618_tmp1
where uid_new>0
;


create table a618_invest as 
select investor_id,sum(capital) as capital
from borrow_invest a 
inner join borrow b on a.borrow_id=b.id
where a.date_created>='2018-06-16'
and a.status not in(0,2)
group by investor_id
;

drop table a618_uid_info;
create table a618_uid_info as 
select uid
,case when b.reg_time>='2018-06-16' then 'new' else 'old' end as reg
,case when c.investor_id is not null then 1 else 0 end as is_investor
,case when c.investor_id is not null then capital else 0 end as capital
from a618_uid a 
inner join member b on a.uid=b.id
left outer join a618_invest c on a.uid=c.investor_id
;


select reg,is_investor,count(1),sum(capital) as capital
from a618_uid_info
group by reg,is_investor
;


select url,count(1) as pv 
from a618_tmp1
group by url
;


create table a618_detail as 
select a.*
,b.reg,b.is_investor
from nginxlog_uidnew a 
left outer join a618_uid_info b on a.uid_new = b.uid
where d>='2018-06-16'
and path ~'active/transfer'
;

select url,reg
,count(1) as pv,count(distinct uid_new) as uv
from a618_detail
group by url,reg
;

