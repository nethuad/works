drop table if exists sp_account_withdraw;
create table sp_account_withdraw as
select a.*
,cast(handle_time as timestamp) as handle_ts
,to_char(cast(handle_time as timestamp),'YYYY-MM-DD') as d_handle
from account_withdraw a
left outer join member_inner b on a.member_id=b.member_id
where a.withdraw_way not in (6)  -- 非成标出账
and a.status in (4)  --COMPLETE("已提现")
and b.member_id is null
;

