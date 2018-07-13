# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`
rdate_curr_d=`date +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

echo d=$rdate_d
echo pt=$rdate_pt


# 企业客户
psql -f pre/pre-enterprise_loaner.sql "$db_connection"

# account_cash 现金账户
psql -f pre/pre-account_cash.sql "$db_connection"

# borrow_wide 标宽表

psql -f pre/pre-borrow.sql "$db_connection"

# invest_wide 投资宽表

psql -f pre/pre-borrow.sql "$db_connection"

# vip
psql -f pre/pre-member_vip.sql "$db_connection"

# 从cash_flow中获取优惠券使用的invest_id
psql -v pt="'$rdate_pt'" -f pre/pre-cash_flow_voucher.sql "$db_connection"

# 以下为数据汇总

# 待收余额
psql -v pt="'$rdate_curr_d'" -f pre/pre-balance.sql "$db_connection" 
