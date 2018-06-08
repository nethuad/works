# 数据统计

# 用户投资基础数据
psql  -f portrait_invest_base.sql "dbname=xueshandai user=xsd password=Xsd123$"

# 用户收款数据
psql  -f portrait_receipt_base.sql "dbname=xueshandai user=xsd password=Xsd123$"

# 用户账户
psql  -f portrait_account_base.sql "dbname=xueshandai user=xsd password=Xsd123$"

# 用户画像
psql  -f portrait_base.sql "dbname=xueshandai user=xsd password=Xsd123$"


