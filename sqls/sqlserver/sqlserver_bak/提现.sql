select avg(cash) as cash_avg
from account_withdraw
where 
--withdraw_way not in (6)  -- 非成标出账
status in (4)  --COMPLETE("已提现")
and date_created>='2018-01-01'
