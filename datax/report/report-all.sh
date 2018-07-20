# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f report/report-coupon.sql "$db_connection"

# 投资者待收
psql -f report/report-receipt.sql "$db_connection"

# 投资者提现
psql -f report/report-withdraw.sql "$db_connection"

# 投资者充值
psql -f report/report-recharge.sql "$db_connection"

# 投资者现金流水
psql -f report/report-investor_capital_flow.sql "$db_connection"

# 借款者-现金流水
psql -f report/report-loaner_capital_flow.sql "$db_connection"

# 标宽表
psql -f report/report-borrow_wide.sql "$db_connection"

# 投资者投标明细
psql -f report/report-borrow_invest_wide.sql "$db_connection"

# 用户宽表
psql -f report/report-portrait_member_wide.sql "$db_connection"




