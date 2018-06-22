# sh run-repayment_detail.sh 20180425

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
# python3 createjson-pt.py dbo_repayment_detail $rdate

# 增量
python3 createjson-pt.py dbo_repayment_detail_dadd $rdate

echo ==== datax
# 全量
# python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_repayment_detail-$rdate.json

# 增量
python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_repayment_detail_dadd-$rdate.json


echo ==== psql
psql  -v pt="'$rdate'" -f import-repayment_detail-after.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"