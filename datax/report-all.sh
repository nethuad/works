# 数据统计

rdate=$1

# 用户注册
psql  -v pt="'$rdate'" -f report-member_register.sql "dbname=xueshandai user=xsd password=Xsd123$"


