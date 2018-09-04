db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# coupon
psql -f report/report-coupon.sql "$db_connection"

# 投资者待收
psql -f report/report-receipt.sql "$db_connection"

# 投资者提现
psql -f report/report-withdraw.sql "$db_connection"

# 投资者充值
psql -f report/report-recharge.sql "$db_connection"

# 投资者充值提现
psql -f report/report-withdraw_recharge.sql "$db_connection"

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

# 客户流失表
psql -f report/report-member_lost.sql "$db_connection"

# 回款流失表
psql -f report/report-member_receipt_lost.sql "$db_connection"

# 回款投资扩展表
psql -f report/report-member_receipt_day_tag_ext.sql "$db_connection"

# nginx flow
psql -f report/report-nginx_flow_day.sql "$db_connection"

# nginx外部流量
psql -f report/report-nginxlog_foreign.sql "$db_connection"

# nginx的注册链接统计-- 短信链接
psql -f report/report-nginxlog_register_url.sql "$db_connection"

# 注册网址
psql -f report/report-nginxlog_register_urls.sql "$db_connection"


# 活动
psql -f report/report-nginxlog_active_transfer.sql "$db_connection"


# 获取省份
psql -f report/report-nginxlog_ip_uid_province.sql "$db_connection"


