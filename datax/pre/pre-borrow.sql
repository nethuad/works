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


/*

累计投资总额：
   历史固定值（不在库里）：22540200，
   投标记录的+余额连盈的（ select capital, investor_id, subscription_time as time from balance_invest_detail）

status:
0-READY("待审核"), 1-PASS("投标"), 2-NO_PASS("未通过审核"), 3-RUN_OFF("流标"), 4-FULL("满标"), 5-REPAY("还款中"), 6-COMPLETE("完成")，

有效标判断 : status in (1,4,5,6) 
满标判断: status in (4,5,6)


标类型:
 1. 担保标 : category='ordinary' and category_type = 'transfer'
 2. 信用标 : category='transfer' and category_type = 'ordinary'  -- 企业标
 3. 净值标 : category='worth' and category_type = 'worth'
 4. 个人贷 : category='personer_loan' and category_type = 'personer_loan'

CYCLE_TYPE：  NONE("未知"), DAY("天"), MONTH("个月")，

INTEREST_TYPE：INVEST("投标计息", "即刻投标即刻计息"), FULL("满标计息", "标满后开始计息")，

REPAY_TYPE：
NONE("未知", "未定义"), ONCE("一次性还款", "借款人在借款到期时一次性还清借款的本息"),
        MONTH("每月等额本息", "借款人每月按相等的金额偿还借款本金和利息，其中每月借款利息按月初剩余借款本金计算并逐月结清。"),
        MONTH_INTEREST("按月还息", "借款人每月支付当月利息，最后一月支付借款本金和当月利息。"),
        QUARTER_INTEREST("按季还息", "借款人每季度支付当季度利息，最后一个季度支付借款本金和当季度利息。"),
        HALF_YEAR_INTEREST("半年还本息","每半年利息由雪山基金会支付")
        
tradeout : 已投资金额
surplus : 剩余投资金额
tradein : 已回购金额

interestfeetotal： 投资管理费
loanercost:借款管理费对象

[min_invest_day]
DATEADD(DAY, -[min_invest_day],[fund_deadline]) as starttime 开始投标日期


 */
 
 /* 
 逾期
 
 select sum(capital) as capital,sum(should_repay_balance-fact_repay_balance) as should_repay_balance
from repayment_detail 
where status=2

select * from borrow where id in (5020,5032,5034,5050)
 
 */
 
 
 

