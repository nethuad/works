-- 流失用户营销活动
use xueshandai

select * from card_coupons_batch where prefix in ('0230','0231') or (prefix >='0435' and prefix<='0455')


drop table #1
select a.id,a.batch_id,b.prefix,b.batch_desc,b.category,b.amount as amount_red,b.red_rate
,a.amount,a.valid_date,a.invalid_date
,member_id
,a.status,case when a.status in (1,5) then 1 else 0 end as is_used
,use_to,invest_id,use_date
,a.date_created,a.last_updated
into #1
from card_coupons_detail a 
inner join (
  select * from card_coupons_batch where prefix in ('0230','0231') or (prefix >='0435' and prefix<='0455')
) b on a.batch_id=b.id 
and member_id is not null

select prefix,batch_desc,amount_red,red_rate
,count(1) as 发送量 
,sum(is_used) as  使用量
,sum(case when is_used=1 then amount_red else 0 end) red_amount
from #1
group by prefix,batch_desc,amount_red,red_rate
order by prefix

select count(distinct investor_id) as investor_num,sum(capital) as capital
from borrow_invest a 
inner join (select distinct member_id from #1 ) b on a.investor_id=b.member_id
where a.date_created>='2018-06-09'

-- investor_num	capital
--17	77400.00

select distinct xsd_uid
from nginxlog
where d>='2018-06-09'
and xsd_uid rlike '^\\d+$' and xsd_uid>'0'


15

select count(distinct member_id) from #1
2297

select distinct member_id from #1


select count(distinct investor_id) from borrow_invest where date_created>='2018-06-09'


select * from borrow_invest where date_created>='2018-06-12' and capital>10000


select * from member_query

-- 五一助力奖励
select b.member_id,a.capital as '奖励金额' from
(select open_id,SUM(capital)+50 capital from weixin_activity  group by open_id)a left join 
(select  member_id,openid from weixin_binding where openid is not null group by openid,member_id)b
on a.open_id=b.openid
where b.member_id is not null

-- 7月生日数据
select a.member_id,a.生日,a.地址,a.等级,b.颜色 from(

select a.member_id,a.生日,a.地址,a.等级 from
(

select a.birthday as 生日,a.member_id as member_id,a.current_address as 地址,b.grade_name as 等级 from (
select a.birthday,a.member_id,b.current_address from (
select member_id,CONVERT(varchar(100), birthday, 111)birthday from member_info where MONTH(birthday)=7 group by member_id,birthday
)a left join 
(select member_id,current_address from member_info )b
on a.member_id=b.member_id
group by a.birthday,a.member_id,b.current_address
)a
left join

(select a.member_id,b.grade_name from
(select max(id)id,member_id from member_vip where is_end=0 group by member_id)a
left join 
(select va.membervip_id,vg.grade_name from vip_association va ,vip_grade vg where va.vip_grade_id=vg.id)b 
on a.id=b.membervip_id)b
on a.member_id=b.member_id
group by a.birthday,a.member_id,a.current_address,b.grade_name

)a left join 
(select a.member_id,a.available+b.capital as capitals from(
select member_id,available from account where type='cash'
)a left join 
(select investor_id,sum(capital)capital from borrow_invest where status in(2,1) group by investor_id)
b
on a.member_id=b.investor_id)b
on a.member_id=b.member_id
where b.capitals is not null


drop table #1 
select a.member_id,b.grade_name 
into #1
from
(select max(id)id,member_id from member_vip where is_end=0 group by member_id)a
left join 
(select va.membervip_id,vg.grade_name from vip_association va ,vip_grade vg where va.vip_grade_id=vg.id)b 
on a.id=b.membervip_id

select top 10 * from #1 where member_id=49030

select count(1) as c,count(distinct member_id) as c2 from #1
2014


select * from member where real_name='华栋'

select * 
from (
select a.id,a.member_id,a.remark,a.begin_date,a.end_date,a.is_end
,b.membervip_id,b.vip_grade_id
,c.grade_name,c.lower,c.upper,c.rank as vip_rank
,ROW_NUMBER() OVER(PARTITION BY a.member_id ORDER BY a.id desc) as  rown
from member_vip a 
inner join vip_association b on a.id=b.membervip_id
inner join vip_grade c on b.vip_grade_id = c.id
) a where rown=1 and is_end=0




order by end_date

order by end_date


select * from member_vip where member_id=49030

select top 10 * from member_vip

select top 10  * from vip_association 

select count(1) as c ,count(distinct membervip_id) as c2  from vip_association 

select * from vip_grade

select is_end, min(end_date) as min_end,max(end_date) as max_end ,count(1) as c,count(distinct member_id) as mc from member_vip group by is_end

select * from member_vip 

select * from member_v

select top 10 *



)a left join 
(
select a.member_id,
Case
    When b.total_net_assets>=2000 and a.total_net_assets_max*0.8<=b.total_net_assets then '绿色'
    When b.total_net_assets>=2000 and a.total_net_assets_max*0.5<=b.total_net_assets and b.total_net_assets<a.total_net_assets_max*0.8 then '蓝色'
    When b.total_net_assets>=2000 and a.total_net_assets_max*0.2<=b.total_net_assets and b.total_net_assets<a.total_net_assets_max*0.5 then '黄色'
    When b.total_net_assets<2000 or (b.total_net_assets>=2000 and b.total_net_assets<a.total_net_assets_max*0.2 )then '红色'
    Else 'null'

End 颜色 from 
(select member_id,max(total_net_assets) total_net_assets_max from Member_Net_Assets_Info group by member_id) a
left join 
(select member_id,total_net_assets from Member_Net_Assets_Info where current_Month in (select max(current_Month) from Member_Net_Assets_Info))b
on a.member_id=b.member_id
)b on a.member_id=b.member_id




select * from (
select a.member_id,b.grade_name from
(select max(id)id,member_id from member_vip where is_end=0 group by member_id)a
left join 
(select va.membervip_id,vg.grade_name from vip_association va ,vip_grade vg where va.vip_grade_id=vg.id)b 
on a.id=b.membervip_id
) a where member_id=49030

