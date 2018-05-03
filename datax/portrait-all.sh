# 数据统计

rdate=$1

# 用户注册
psql  -v pt="'$rdate'" -f portrait_base.sql "dbname=xueshandai user=xsd password=Xsd123$"


