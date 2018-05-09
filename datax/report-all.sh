# 数据统计

rdate=$1

# 用户注册
psql  -v pt="'$rdate'" -f report-member_register.sql "dbname=xueshandai user=xsd password=Xsd123$"

# 借贷流水
psql  -v pt="'$rdate'" -f report-capital_flow.sql "dbname=xueshandai user=xsd password=Xsd123$"


