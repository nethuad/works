

drop table tmp_history_1w;
create table tmp_history_1w as 
select investor_id as member_id,capital_max
from (
select investor_id,max(capital) as capital_max
from balance_investor_day_investortype
where investor_type='outer'
group by investor_id
) a where capital_max>=10000
;


drop table if exists tmp1;
create table tmp1 as 
select a.id as member_id
,c.birthday,extract( year from age(c.birthday::timestamp)) as oldy
,c.gender
from member a 
left outer join member_xmgj_transfer b on a.id=b.member_id
left outer join member_inner mi on a.id=mi.member_id
inner join member_id_card_info c on a.id=c.member_id
where b.member_id is null and mi.member_id is null 
;


drop table if exists tmp2;
create table tmp2 as 
select *
,case when oldy<25 then '1-25以下'
when oldy>=25 and oldy<=35 then '2-25~35岁' 
when oldy>35 and oldy<=50 then '3-36~50岁'
when oldy>50 then '4-50岁以上' 
end as year_area
from tmp1
;

select year_area,gender
,count(1) as c
from tmp2
group by year_area,gender
;


drop table tmp3;
create table tmp3 as 
select *
from balance_investor_day_investortype a 
inner join tmp2 b on a.investor_id = b.member_id
where a.d='2017-12-31'
union all
select *
from balance_investor_day_investortype a 
inner join tmp2 b on a.investor_id = b.member_id
where a.d='2018-08-19'
;


select d,gender,count(1) as c,sum(capital) as capital
from tmp3
group by d,gender
;


select d,year_area,count(1) as c,sum(capital) as capital
from tmp3
group by d,year_area
;


