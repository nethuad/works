db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"
begin_date=2018-01-01
end_date=2018-06-01
do_date=$begin_date
while [ "$do_date" \< "$end_date" ]
do
    echo $do_date
    d_yestoday=$do_date
    d_today=`date -d "+1 day $do_date " +%Y-%m-%d`
    psql -v dstat="'$d_yestoday'" -v dstatnext="'$d_today'" -f proc/proc-member_receipt_last.sql "$db_connection"
    do_date=`date -d "+1 day $do_date " +%Y-%m-%d`
done