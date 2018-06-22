# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

# account_cash
psql -f pre-account_cash.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"


# vip
psql -f pre-member_vip.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"

# 从cash_flow中获取优惠券使用的invest_id
psql -v pt="'$rdate_pt'" -f pre-cash_flow_voucher.sql "dbname=xueshandai user=xueshandai password=Xueshandai123$"

