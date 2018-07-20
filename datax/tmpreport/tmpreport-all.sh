db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f tmpreport/report-weixin_activity.sql "$db_connection"