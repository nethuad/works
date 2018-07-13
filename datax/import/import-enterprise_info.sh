# sh run-enterprise_info.sh 20180424

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
python3 createjson-pt.py dbo_enterprise_info $rdate

echo ==== datax
# 全量
python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_enterprise_info-$rdate.json


echo ==== psql
psql  -v pt="'$rdate'" -f import/import-enterprise_info-after.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"