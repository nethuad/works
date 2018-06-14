drop table if exists tmp1;
create table tmp1 as 
select member_id,real_name
,invest_times,invest_capital,(cash_available+cash_freeze+unreceipt_capital) as asset,unreceipt_capital
,case when invest_times>=11 then '11笔及以上' else invest_times||'笔' end as invest_times_2
,case when invest_times=1 then '1笔' when invest_times in (2,3) then '2-3笔' when invest_times>=4 then '大于等于4笔' end as invest_times_3
,last_invest_date,last_invest_capital,last_cycle_type,last_cycle
,last_receipt_time,last_receipt_capital,last_receipt_cycle_type,last_receipt_cycle
,substring(last_receipt_time from 1 for 7 ) as last_receipt_month
,case when last_cycle_type=2 then last_cycle||'月标' else '其他' end as last_invest_borrow
,case when last_receipt_cycle_type=2 then last_receipt_cycle||'月标' else '其他' end as last_receipt_borrow
,case when last_invest_capital<=1000 then '0-1000' 
      when last_invest_capital>1000 and last_invest_capital<=5000 then '1001-5000'
      when last_invest_capital>5000 and last_invest_capital<=10000 then '5001-10000'
      when last_invest_capital>10000 and last_invest_capital<=20000 then '10001-20000'
      when last_invest_capital>20000 and last_invest_capital<=50000 then '20001-50000'
      when last_invest_capital>50000 and last_invest_capital<=100000 then '50001-100000'
      when last_invest_capital>100000 then '>=100000'
      end as last_invest_capital_range
,case when last_receipt_capital<=1000 then '0-1000' 
      when last_receipt_capital>1000 and last_receipt_capital<=5000 then '1001-5000'
      when last_receipt_capital>5000 and last_receipt_capital<=10000 then '5001-10000'
      when last_receipt_capital>10000 and last_receipt_capital<=20000 then '10001-20000'
      when last_receipt_capital>20000 and last_receipt_capital<=50000 then '20001-50000'
      when last_receipt_capital>50000 and last_receipt_capital<=100000 then '50001-100000'
      when last_receipt_capital>100000 then '>=100000'
      end as last_receipt_capital_range
from p_member_mode
where last_receipt_time>='2017-01-01' and last_receipt_time<'2018-03-01'
;