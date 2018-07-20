# sh run-register_attach_info.sh 20180424

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
# python3 createjson-pt.py dbo_register_attach_info $rdate

# 增量
python3 createjson-pt.py dbo_register_attach_info_dadd $rdate

echo ==== datax
# 全量
# python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_register_attach_info-$rdate.json

# 增量
python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_register_attach_info_dadd-$rdate.json


echo ==== psql
psql  -v pt="'$rdate'" -f import/import-register_attach_info-after.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"