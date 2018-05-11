# 数据统计

rdate=$1

# 用户投资基础数据
psql  -v pt="'$rdate'" -f portrait_invest_base.sql "dbname=xueshandai user=xsd password=Xsd123$"

# 用户注册
psql  -v pt="'$rdate'" -f portrait_base.sql "dbname=xueshandai user=xsd password=Xsd123$"


