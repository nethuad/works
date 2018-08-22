-- 昨日最后一笔还款并且没有投资
-- select :dstat as dstat,:dstatnext as dstatnext;

/*

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"
begin_date=2018-01-01
end_date=2018-08-01
do_date=$begin_date
while [ "$do_date" \< "$end_date" ]
do
    echo $do_date
    d_yestoday=$do_date
    d_today=`date -d "+1 day $do_date " +%Y-%m-%d`
    psql -v dstat="'$d_yestoday'" -v dstatnext="'$d_today'" -f proc/proc-member_receipt_last.sql "$db_connection"
    do_date=`date -d "+1 day $do_date " +%Y-%m-%d`
done

*/


-- 待收金额，只计算本金
DELETE FROM receipt_detail_mirrow WHERE d_stat=:dstat;

insert into receipt_detail_mirrow
select a.id as receipt_id,a.invest_id,a.borrow_id,a.investor_id,a.capital,a.receipt_time
,a.need_receipt_time
,b.date_created as invest_date
,c.status as borrow_status
,:dstat as d_stat
,to_char(now(),'YYYY-MM-DD') as d_extract
from receipt_detail a 
inner join borrow_invest b on a.invest_id=b.id
inner join borrow c on b.borrow_id=c.id
where c.status in (1,4,5,6)
and a.capital>0
and (need_receipt_time>=:dstat or need_receipt_time is null)
and b.date_created<:dstatnext
;


-- 当天回款是最后一笔，并且没有正在投资的标
DELETE FROM member_receipt_noinvest WHERE d_stat=:dstat;

insert into member_receipt_noinvest
select receipt_id,invest_id,borrow_id,investor_id,capital,receipt_time
,need_receipt_time,invest_date
,borrow_status,d_stat,d_extract
from (
select *
,row_number() over(partition by investor_id order by need_receipt_time desc ) as rown
from (
select a.* from (
select *
from receipt_detail_mirrow
where d_stat=:dstat
) a 
left outer join (
select distinct investor_id 
from receipt_detail_mirrow
where d_stat=:dstat
and need_receipt_time is null
) b on a.investor_id=b.investor_id
where b.investor_id is null
) a 
) a where rown=1 and to_char(need_receipt_time::timestamp,'YYYY-MM-DD')=:dstat
;






