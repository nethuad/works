# sh run-account_withdraw.sh 20180424

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
# python3 createjson-pt.py dbo_account_withdraw $rdate

# 增量
python3 createjson-pt.py dbo_account_withdraw_dadd $rdate

echo ==== datax
# 全量
# python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_account_withdraw-$rdate.json

# 增量
python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_account_withdraw_dadd-$rdate.json


echo ==== psql
psql  -v pt="'$rdate'" -f proc-account_withdraw.sql "dbname=xueshandai user=xsd password=Xsd123$"