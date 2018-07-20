db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"
begin_date=2018-07-15
end_date=2018-07-18
do_date=$begin_date
while [ "$do_date" \< "$end_date" ]
do
    echo $do_date
    psql -v pt="'$do_date'" -f pre/pre-balance_correct.sql "$db_connection" 
    do_date=`date -d "+1 day $do_date " +%Y-%m-%d`
done