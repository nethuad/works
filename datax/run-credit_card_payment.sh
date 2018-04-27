# sh run-credit_card_payment.sh 20180424

# 目前信用卡数据不更新

if [ $# -eq 0 ]
then
    echo "absent parameter yyyymmdd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json

# 全量
# python3 createjson-pt.py dbo_credit_card_payment $rdate


echo ==== datax
# 全量
# python /var/www/datax/bin/datax.py day/odps2postgresql-dbo_credit_card_payment-$rdate.json


echo ==== psql
# psql  -v pt="'$rdate'" -f proc-credit_card_payment.sql "dbname=xueshandai user=xsd password=Xsd123$"