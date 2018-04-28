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
where full_time>='2017-01-01' and full_time < to_char(now(),'YYYY-MM-DD')
;

drop table IF EXISTS borrow_wide_bak;
alter table borrow_wide rename to borrow_wide_bak;
alter table borrow_wide_tmp rename to borrow_wide;






-- 用户投标信息



/*
full_day =  date_trunc('day', full_time::timestamp)
 
 */

/* borrow 标信息

有效标判断 : where status in (1,4,5,6) 

status READY("待审核"), PASS("投标"), NO_PASS("未通过审核"), RUN_OFF("流标"), FULL("满标"), REPAY("还款中"), COMPLETE("完成")，

CYCLE_TYPE：  NONE("未知"), DAY("天"), MONTH("个月")，

INTEREST_TYPE：INVEST("投标计息", "即刻投标即刻计息"), FULL("满标计息", "标满后开始计息")，
loanerTotal：借款管理费

REPAY_TYPE：
NONE("未知", "未定义"), ONCE("一次性还款", "借款人在借款到期时一次性还清借款的本息"),
        MONTH("每月等额本息", "借款人每月按相等的金额偿还借款本金和利息，其中每月借款利息按月初剩余借款本金计算并逐月结清。"),
        MONTH_INTEREST("按月还息", "借款人每月支付当月利息，最后一月支付借款本金和当月利息。"),
        QUARTER_INTEREST("按季还息", "借款人每季度支付当季度利息，最后一个季度支付借款本金和当季度利息。"),
        HALF_YEAR_INTEREST("半年还本息","每半年利息由雪山基金会支付")
        
amount : 借款总金额
tradeout : 已投资金额
surplus : 剩余投资金额
tradein : 已回购金额
loanFeetotal: 借款管理费率
loanertotal : 借款管理费
interestfeetotal： 投资管理费
loanercost:借款管理费对象
interesttype: 计息方式

[full_time] 满标日期
[fund_deadline] 满标的最后期限
[min_invest_day]
DATEADD(DAY, -[min_invest_day],[fund_deadline]) as starttime 开始投标日期


累计投资总额：历史固定值（不在库里）：22540200，投标记录的+余额连盈的（ select capital, investor_id, subscription_time as time from balance_invest_detail）

,case when category='ordinary' then '担保标' when category='transfer' then '信用标' when category='worth' then '净值标' else '其他'  end '产品名称'
,full_time as 满标时间
,amount as 借款本金
,cycle as 借款期限
,case when cycle_type='1' then '天' when cycle_type='2' then '月' else '其他'  end '借款期限单位'
,case when interest_type='0' then '投标计息' when interest_type='1' then '满标计息' else '其他'  end '计息方式'
,case when repay_type=0 then '未知' 
when repay_type=1 then '一次性还款'
when repay_type=2 then '每月等额本息'
when repay_type=3 then '按月还息'
when repay_type=4 then '按季还息'
when repay_type=5 then '半年还本息'
else ''
end as 还款方式
,rate as 利率
,interest_total as 利息
,loaner_fee_total as 管理费率,loaner_total as 管理费
,case when status =0 then '待审核'
when status =1 then '投标'
when status =2 then '未通过审核'
when status =3 then '流标'
when status =4 then '满标'
when status =5 then '还款中'
when status =6 then '完成'
else '' end as 标状态


*/