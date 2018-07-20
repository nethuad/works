# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# nginx
psql -v d="'$rdate_d'" -f proc/proc-nginxlog.sql "$db_connection"


# borrow_invest_wide
psql -f proc/proc-borrow_invest_wide.sql "$db_connection"

# 剔除内部自动化标
psql -f proc/proc-borrow_invest_wide_correct.sql "$db_connection"

# coupon
psql -f proc/proc-coupon.sql "$db_connection"

# balance
psql -f proc/proc-balance.sql "$db_connection"

# member ip
psql -f proc/proc-member_ip.sql "$db_connection"




