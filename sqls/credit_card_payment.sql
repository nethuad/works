--信用卡还款推荐奖励分析

select capital_type
,count(distinct receiver_id) as uv 
,sum(capital) as capital 
from transfer_detail 
where payer_id =16993
and capital_type in (9,12) 
group by capital_type
;

--9	50858	1623208.86
--12	5871	1876310.00

--信用卡还款奖励
drop table if exists tmp_1;
create table tmp_1 as 
select id as transfer_detail_id,capital,capital_type,receiver_id,date_created
from transfer_detail 
where payer_id =16993
and capital_type =9
;

--信用卡还款推荐人奖励
drop table if exists tmp_2;
create table tmp_2 as 
select id as transfer_detail_id,capital,capital_type,receiver_id,description,substring(description from '会员(.*)信用卡还款') as uname,date_created
from transfer_detail 
where payer_id =16993
and capital_type =12
;

drop table if exists tmp_3;
create table tmp_3 as
select transfer_detail_id,capital,capital_type,receiver_id,description,a.uname,a.date_created,b.id as recommended_id
from tmp_2 a 
left outer join member b on trim(a.uname)=b.uname
;

/* 校验数据

-- 推荐关系 
select * 
from (
select transfer_detail_id,capital,capital_type,receiver_id,description,a.uname,a.date_created,a.recommended_id,b.referrer_id
from tmp_3 a 
left outer join recommend b on a.recommended_id = b.member_id
) a 
 where receiver_id <> referrer_id limit 10;
;

--推荐人的被推荐人是否拿到奖励
select a.receiver_id,a.recommended_id,b.receiver_id
from (
select distinct receiver_id,recommended_id 
from tmp_3) a  
left outer join (
select distinct receiver_id from tmp_1
) b on a. recommended_id = b.receiver_id
where b.receiver_id is null
limit 10
;
*/

-- 信用卡还款奖励明细 
drop table if exists credit_card_payment_reward_detail_report;
create table credit_card_payment_reward_detail_report as 
select transfer_detail_id,capital,capital_type,receiver_id as member_id,reward_type
,date_created
,date_trunc('day', date_created::timestamp) as reward_day
from (
select transfer_detail_id,capital,capital_type,receiver_id
,case when b.recommended_id is null then '普通用户信用卡还款奖励' else '被推荐用户信用卡还款奖励' end as reward_type
,date_created 
from tmp_1 a 
left outer join (select distinct recommended_id from tmp_3) b on a.receiver_id = b.recommended_id
union all 
select transfer_detail_id,capital,capital_type,receiver_id,'信用卡还款推荐人奖励' as reward_type
,date_created
from tmp_3
) a 
;

--信用卡还款奖励用户的投标信息
drop table if exists credit_card_payment_reward_invest_detail_report;
create table credit_card_payment_reward_invest_detail_report as
select member_id,reward_type,capital,date_created
from borrow_invest a 
inner join (
select distinct member_id,reward_type 
from credit_card_payment_reward_detail_report 
where reward_type not like '%推荐人%'
) b on a.investor_id = b.member_id
;

/* 校验数据
select count(1) as c,count(distinct member_id) as uv 
from (
select distinct member_id,reward_type 
from credit_card_payment_reward_detail_report 
where reward_type not like '%推荐人%'
) a 
--50858	50858
*/

--汇总报表
drop table if exists credit_card_payment_reward_invest_sum_report;
create table credit_card_payment_reward_invest_sum_report as
select a.reward_type,a.reward_members,a.reward
,b.members as investors_2017,b.capital as investamount_2017
,c.members as investors_2018,c.capital as investamount_2018
from (
select reward_type,count(distinct member_id) as reward_members,sum(capital) as reward 
from credit_card_payment_reward_detail_report 
group by reward_type
) a 
left outer join 
(select reward_type
,count(distinct member_id) as members
,sum(capital) as capital 
from credit_card_payment_reward_invest_detail_report
where date_created>='2017' and date_created<'2018'
group by reward_type
) b on a.reward_type = b.reward_type

left outer join 
(select reward_type
,count(distinct member_id) as members
,sum(capital) as capital 
from credit_card_payment_reward_invest_detail_report
where date_created>='2018' and date_created<'2019'
group by reward_type
) c on a.reward_type = c.reward_type
;


--被推荐用户信用卡还款奖励	39359	1010496.59
--普通用户信用卡还款奖励	11499	612712.27
--信用卡还款推荐人奖励	5871	1876310.00

select substring(date_created from 1 for 4) as year
,reward_type
,count(distinct member_id) as members
,sum(capital) as capital 
from credit_card_payment_reward_invest_detail_report 
group by reward_type,substring(date_created from 1 for 4)
;
--2017	被推荐用户信用卡还款奖励	13499	19442700.00
--2018	被推荐用户信用卡还款奖励	519	5623600.00
--2013	普通用户信用卡还款奖励	68	3006540.00
--2014	普通用户信用卡还款奖励	347	46940200.00
--2015	普通用户信用卡还款奖励	600	154939900.00
--2016	普通用户信用卡还款奖励	1305	219814900.00
--2017	普通用户信用卡还款奖励	4868	120302500.00
--2018	普通用户信用卡还款奖励	704	38581400.00

