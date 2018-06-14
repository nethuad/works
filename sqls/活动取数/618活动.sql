drop table #618

select
a.investor_id as member_id 
,mobile
,real_name
,need_receipt_time
,capital
,cycle_type
,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as cycle
,b.reg_time
,case when c.member_id is not null then grade_name else '普通用户' end as grade_name
,member_type
into #618
from (
      select investor_id,borrow_id,cycle_type,cycle
      ,issue,capital,interest,should_receipt_balance
      ,need_receipt_time
      ,case when need_receipt_time>='2017-01-01' and need_receipt_time<'2018-03-01' then '流失用户'
            when need_receipt_time>='2017-03-01' and need_receipt_time<'2018-06-01' then '流失预警用户'
            when need_receipt_time>='2017-06-01' then '在投用户'
            else '其他'
      end as member_type
      ,status_receipt,status_borrow
      from (
      select investor_id,a.borrow_id
      ,b.cycle_type,b.cycle
      ,issue,capital,interest,should_receipt_balance
      ,need_receipt_time
      ,a.status as status_receipt,b.status as status_borrow
      ,ROW_NUMBER() OVER(partition by investor_id order by need_receipt_time desc)  as rown 
      from receipt_detail a 
      inner join borrow b on a.borrow_id = b.id
      where a.status in (1,4)
      and b.status in (4,5,6)
      and need_receipt_time>='2017-01-01'
      ) a where rown=1
) a 
inner join member b on a.investor_id=b.id
left outer join (
      select member_id,vip_rank,grade_name
      from (
      select a.id,a.member_id,a.remark,a.begin_date,a.end_date,a.is_end
      ,b.membervip_id,b.vip_grade_id
      ,c.grade_name,c.lower,c.upper,c.rank as vip_rank
      ,ROW_NUMBER() OVER(PARTITION BY a.member_id ORDER BY a.id desc) as  rown
      from member_vip a 
      inner join vip_association b on a.id=b.membervip_id
      inner join vip_grade c on b.vip_grade_id = c.id
) a where rown=1 and is_end=0
) c on a.investor_id = c.member_id


-- 4月1日到5月31日间完成注册的，截止数据拉取日尚未有投资记录的用户

select a.id as member_id,a.mobile,a.real_name,a.reg_time
from member a 
left outer join (select distinct investor_id from borrow_invest ) b on a.id = b.investor_id
where a.reg_time>='2018-04-01'
and b.investor_id is null




select top 10 * from #618

select count(1) as c,count(distinct member_id) as member_num
from #618

select member_type,count(1) as c,count(distinct member_id) as member_num
from #618
group by member_type


select member_type,grade_name,count(1) as c,count(distinct member_id) as member_num
from #618
group by member_type,grade_name
order by grade_name,member_type