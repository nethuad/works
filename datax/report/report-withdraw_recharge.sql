-- 投资者的充值与提现表，合并
drop table if exists sp_account_recharge_withdraw;
create table sp_account_recharge_withdraw as
select cast(a.d_ts as timestamp) as ts
,a.d_ts
,a.cash_recharge,b.cash_withdraw
from (
select d_ts,sum(cash) as cash_recharge
from sp_account_recharge
where d_ts>='2018-01-01' and d_ts< to_char(now(),'YYYY-MM-DD')
and rtype='invest' and mtype='outer'
group by d_ts
) a 
left outer join (
select d_handle,sum(cash) as cash_withdraw
from sp_account_withdraw
where d_handle>='2018-01-01' and d_handle< to_char(now(),'YYYY-MM-DD')
group by d_handle
) b on a.d_ts = b.d_handle
;