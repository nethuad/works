-- 每日待收余额

/*
CREATE TABLE balance_investor_day (
investor_id bigint,
capital numeric(19,2),
interest numeric(19,2),
should_receipt_balance numeric(19,2),
d varchar(50)
);
*/

/*
sh batch/balance.sh
```
db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"
begin_date=2013-01-01
end_date=2018-06-26
do_date=$begin_date
while [ "$do_date" \< "$end_date" ]
do
    echo $do_date
    psql -v pt="'$do_date'" -f pre/pre-balance.sql "$db_connection" 
    do_date=`date -d "+1 day $do_date " +%Y-%m-%d`
done
```

select d
,count(case when should_receipt_balance>0 then investor_id else null) as investor_num
,sum(capital) as capital ,sum(should_receipt_balance) as should_receipt_balance 
from balance_investor_day
where d in ('2017-03-01','2017-04-01','2017-05-01','2017-06-01','2018-03-01','2018-04-01','2018-05-01','2018-06-01')
group by d
;
*/


delete from balance_investor_day where d=:pt;

INSERT INTO balance_investor_day 
SELECT a.investor_id
,sum(a.capital) as capital
,sum(a.interest) as interest
,sum(a.should_receipt_balance) as should_receipt_balance
,:pt as d
FROM receipt_detail  a 
inner join borrow b on a.borrow_id = b.id
inner join borrow_invest c on a.invest_id=c.id
where b.status in (4,5,6) 
and (b.full_time <:pt or 
     (b.full_time is null and b.interest_type=0 and c.date_created<:pt ) --interest_type=0 投标计息，因此没有满标时间
   )
and ( (need_receipt_time>=:pt and a.status=1) --待收
   or (need_receipt_time>=:pt and a.status=4 and receipt_time>=:pt) --已还，截止日期之后还的
   or (need_receipt_time<:pt and a.status=2) -- 截止日期之前需还，但是目前逾期的
   or (need_receipt_time<:pt and a.status=4 and receipt_time>=:pt) -- 截止日期之前需还，但是截止日期之后还的（逾期还款）
)
group by a.investor_id
;




