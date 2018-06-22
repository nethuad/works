# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

# nginx
psql -v d="'$rdate_d'" -f proc-nginxlog.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f proc-coupon.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"

