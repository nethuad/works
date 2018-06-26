# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# nginx
psql -v d="'$rdate_d'" -f proc/proc-nginxlog.sql "$db_connection"


# coupon
psql -f proc/proc-coupon.sql "$db_connection"

