/*
第一类用户：在(2018-01-01，2018-06-15)有投资行为,(2018-06-16，2018-06-25)无投资
 
输出表格：
用户ID   用户电话号码   用户名称   最后一次回款时间   最后一次回款金额   最后一次回款标类型   注册时间   客户类型   



第二类用户：
 2018-05-01后注册，至6.25无投资用户

输出表格：
用户ID  用户名称    注册时间  实名时间  
*/


-- 第一类用户

select
a.investor_id as member_id 
-- ,mobile
-- ,real_name
,need_receipt_time as 最后一次回款时间
,capital as 最后一次回款金额
,borrow_type as 最后一次回款标类型
,m.reg_time as 注册时间
,case when c2.member_id is not null then grade_name else '普通用户' end as 客户类型
from (select distinct investor_id 
    from borrow_invest a 
     inner join borrow b on a.borrow_id = b.id
    where b.status in (1,4,5,6) 
    and a.date_created >='2018-01-01' and a.date_created<'2018-06-16'
) a 
left outer join (select distinct investor_id 
    from borrow_invest a 
     inner join borrow b on a.borrow_id = b.id
    where b.status in (1,4,5,6) 
    and a.date_created >='2018-06-16'
) b on a.investor_id = b.investor_id
inner join member m on a.investor_id=m.id
left outer join (
    -- 最后一次回款
    select investor_id,borrow_id,cycle_type,cycle
    ,case when cycle_type=1 then '日标-' else '月标-' end + convert(varchar(5),cycle) as borrow_type
    ,issue,capital,interest,should_receipt_balance
    ,need_receipt_time
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
    where a.status in (1,2,4) 
    and b.status in (1,4,5,6)
    ) a where rown=1
 ) c1 on m.id=c1.investor_id
left outer join (
    -- vip类型
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
) c2 on m.id = c2.member_id
where b.investor_id is null


-- 第二类用户：

select a.id as member_id,a.reg_time as 注册时间
from member a 
left outer join (select distinct investor_id 
    from borrow_invest a 
     inner join borrow b on a.borrow_id = b.id
    where b.status in (1,4,5,6)) b on a.id=b.investor_id
where  a.reg_time >='2018-05-01'
and b.investor_id is null

