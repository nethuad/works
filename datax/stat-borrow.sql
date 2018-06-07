--标宽表 borrow_wide

drop table IF EXISTS borrow_wide_tmp;
create table borrow_wide_tmp as 
select id as borrow_id,loaner_id,name
,amount
,rate,interest_total
,loaner_fee_total,loaner_total
,fund_deadline,min_invest_day
,to_char(fund_deadline::timestamp-(min_invest_day || ' days')::interval,'YYYY-MM-DD HH24:MI:SS') as start_time
,full_time
,date_trunc('day', full_time::timestamp) as full_day
,EXTRACT(EPOCH FROM (full_time::TIMESTAMP- (fund_deadline::timestamp-(min_invest_day || ' days')::interval) )) /60 as full_minutes
,category
,case when category='ordinary' then '担保标' when category='transfer' then '信用标' when category='worth' then '净值标' else '其他'  end  as category_cn

,cycle
,cycle_type
,case when cycle_type='1' then '天' when cycle_type='2' then '月' else '其他'  end as cycle_type_cn
,case when cycle_type='1' then '天' when cycle_type='2' then '月' else '其他'  end || '_' || cycle as borrow_type

,interest_type
,case when interest_type='0' then '投标计息' when interest_type='1' then '满标计息' else '其他'  end as interest_type_cn

,repay_type
,case when repay_type=0 then '未知' when repay_type=1 then '一次性还款' when repay_type=2 then '每月等额本息' when repay_type=3 then '按月还息'
   when repay_type=4 then '按季还息' when repay_type=5 then '半年还本息' else '' end as repay_type_cn

,status
,case when status =0 then '待审核' when status =1 then '投标' when status =2 then '未通过审核' when status =3 then '流标' when status =4 then '满标'
   when status =5 then '还款中' when status =6 then '完成' else '' end as status_cn
from borrow 
--where full_time>='2017-01-01' and full_time < to_char(now(),'YYYY-MM-DD')
;

drop table IF EXISTS borrow_wide_bak;
alter table borrow_wide rename to borrow_wide_bak;
alter table borrow_wide_tmp rename to borrow_wide;






-- 用户投标信息



/*
full_day =  date_trunc('day', full_time::timestamp)
 
 */

