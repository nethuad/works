# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f portrait/portrait-member_wide.sql "$db_connection"

