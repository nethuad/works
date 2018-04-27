# sh run-nginxlog.sh 2018-04-25

if [ $# -eq 0 ]
then
    echo "absent parameter yyyy-mm-dd"
    exit
fi

rdate=$1

echo $rdate

echo ==== create datax.json
python3 createjson-d.py nginxlog $rdate

echo ==== datax
python /var/www/datax/bin/datax.py day/odps2postgresql-nginxlog-$rdate.json

echo ==== psql
psql  -v d="'$rdate'" -f proc-nginxlog.sql "dbname=xueshandai user=xsd password=Xsd123$"



