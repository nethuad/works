drop table #1

DECLARE @current_month varchar(50)
SET @current_month = '2018-08-01 00:00:00.000'

SELECT
    m.id '用户ID',
    m.real_name '真实姓名',
    m.mobile '手机号码',
    gn.grade_name '会员类型',
    m.reg_time '注册时间',
    convert(varchar(10),mi.birthday,120) '生日',
    MONTH(mi.birthday) as '出生月份',
    mi.current_address '地址',
    i.score '当前积分',
    b.total_net_assets '本月净资产',
    c.total_net_assets_max '最高净资产',
    case when not(m.is_valid_idcard = 1 and m.idcard <>'' and m.is_valid_mobile=1) then '未实名'
       when b.total_net_assets IS NULL then '红色(无净资产)'
       when b.total_net_assets < 2000  then '红色(净资产小于2000)'
       when b.total_net_assets >= 2000 AND b.total_net_assets < c.total_net_assets_max * 0.2 then '红色(净资产大于2000)'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.2<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.5 then '黄色'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.5<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.8 then '蓝色'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.8<=b.total_net_assets then '绿色'
    end AS '颜色标签'
into #1
from member m
LEFT JOIN (select member_id,max(score) as score from integral group by member_id) i ON m.id = i.member_id
LEFT JOIN (select * from (select *,ROW_NUMBER() over(partition by member_id order by id desc) as rown from member_info ) a where rown=1) mi ON m.id=mi.member_id
LEFT JOIN ( 
    select mv.member_id,vg.grade_name 
    from (SELECT MAX (id) id_max,member_id FROM member_vip GROUP BY member_id) mv
    inner join vip_association va on mv.id_max=va.membervip_id
    inner join vip_grade vg on va.vip_grade_id = vg.id
)gn ON m.id = gn.member_id
LEFT JOIN ( SELECT * FROM member_net_assets_info where current_month = @current_month ) b ON m.id = b.member_id 
LEFT JOIN ( SELECT member_id, MAX (total_net_assets) total_net_assets_max FROM member_net_assets_info where current_month<= @current_month GROUP BY member_id) c ON m.id = c.member_id
where m.is_admin = 0


select top 10 * from member_net_assets_info order by id desc

select 颜色标签,count(1) as c  from #1 group by 颜色标签

select count(1) as c from #1 where 颜色标签 in ('未实名','红色(无净资产)')  -- 资产为0的客户

select count(本月净资产) as c2, count(1) as c ,count(distinct 用户ID ) as uv from #1

DECLARE @birthmonth int
set @birthmonth= 9
select 用户ID,真实姓名,手机号码,会员类型,注册时间,生日,地址,当前积分,本月净资产,最高净资产,颜色标签
from  #1 a
left outer join #todelete b on a.用户ID=b.member_id
where 颜色标签 not in ('未实名','红色(无净资产)') and 出生月份=@birthmonth
and b.member_id is null
order by 颜色标签,本月净资产



-- 需要剔除的用户id
select a.member_id
into #todelete
from member_xmgj_transfer a 
left outer join member_xmgj_zhaiquan b 
on a.member_id=b.payer_id
where b.payer_id is null







==============
SELECT
    m.id member_id,
    gn.grade_name 会员类型,
    convert(varchar(10),mi.birthday,120) 生日,
    mi.current_address 地址,
    case when b.total_net_assets < 2000  then '红色(净资产小于2000)'
       when b.total_net_assets >= 2000 AND b.total_net_assets < c.total_net_assets_max * 0.2 then '红色(净资产大于2000)'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.2<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.5 then '黄色'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.5<=b.total_net_assets and b.total_net_assets<c.total_net_assets_max*0.8 then '蓝色'
       when b.total_net_assets>=2000 and c.total_net_assets_max*0.8<=b.total_net_assets then '绿色'
    end AS 颜色标签
from member m
LEFT JOIN (select * from (select *,ROW_NUMBER() over(partition by member_id order by id desc) as rown from member_info ) a where rown=1) mi ON m.id=mi.member_id
LEFT JOIN ( 
    select mv.member_id,vg.grade_name 
    from (SELECT MAX (id) id_max,member_id FROM member_vip GROUP BY member_id) mv
    inner join vip_association va on mv.id_max=va.membervip_id
    inner join vip_grade vg on va.vip_grade_id = vg.id
)gn ON m.id = gn.member_id
LEFT JOIN ( SELECT * FROM member_net_assets_info where current_month = '2018-07-01 00:00:00.000' ) b ON m.id = b.member_id 
LEFT JOIN ( SELECT member_id, MAX (total_net_assets) total_net_assets_max FROM member_net_assets_info where current_month<= '2018-07-01 00:00:00.000' GROUP BY member_id) c ON m.id = c.member_id
where m.is_admin = 0
and MONTH(mi.birthday)=8
and m.is_valid_idcard = 1 and m.idcard <>'' and m.is_valid_mobile=1
and b.total_net_assets>0


