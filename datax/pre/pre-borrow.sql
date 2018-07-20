--borrow宽表 borrow_wide

drop table IF EXISTS borrow_wide;
create table borrow_wide as 
select id
,loaner_id
,name
,amount  -- 借款总金额
,rate  -- 年化利率，因此利息根据receipt_detail计算
,interest_total  -- 利息
,loaner_fee_total  -- 借款管理费率
,loaner_total  -- 借款管理费
,fund_deadline  -- 满标的最后期限
,min_invest_day
,full_time  -- 满标日期
,category  -- 标类型
,category_type -- 与category联合判断标类型，现在可直接通过category判断标类型
,cycle_type  -- 借款期限单位
,cycle  -- 期数
,interest_type  -- 计息方式
,repay_type  -- 还款方式
,status  -- 标状态
,date_trunc('day', full_time::timestamp) as full_day
,to_char(fund_deadline::timestamp-(min_invest_day || ' days')::interval,'YYYY-MM-DD HH24:MI:SS') as start_time
,EXTRACT(EPOCH FROM (full_time::TIMESTAMP- (fund_deadline::timestamp-(min_invest_day || ' days')::interval) )) /60 as full_minutes
,case when category='ordinary' then '担保标' 
    when category='transfer' then '信用标' 
    when category='worth' then '净值标' 
    else '其他'  end  as category_cn
,case when cycle_type='1' then '天' 
    when cycle_type='2' then '月' 
    else '其他'  
    end as cycle_type_cn
,case when cycle_type='1' then '天' 
    when cycle_type='2' then '月' 
    else '其他'  
    end || '_' || cycle as borrow_type
,case when repay_type=0 then '未知' 
    when repay_type=1 then '一次性还款' 
    when repay_type=2 then '每月等额本息' 
    when repay_type=3 then '按月还息'
    when repay_type=4 then '按季还息'
    when repay_type=5 then '半年还本息' 
    else '' 
    end as repay_type_cn
,case when interest_type='0' then '投标计息' 
    when interest_type='1' then '满标计息' 
    else '其他'  
    end as interest_type_cn
,case when status =0 then '待审核' 
    when status =1 then '投标' 
    when status =2 then '未通过审核' 
    when status =3 then '流标' 
    when status =4 then '满标'
    when status =5 then '还款中' 
    when status =6 then '完成' 
    else '' 
    end as status_cn
from borrow 
;



 
 
 

