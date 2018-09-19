db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f tmpreport/report-weixin_activity.sql "$db_connection"

# 获取ios的统计量
psql -f tmpreport/report-ios_member_stat.sql "$db_connection"