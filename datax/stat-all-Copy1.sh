# 数据统计

rdate=$1

# stat-member_base
psql  -v pt="'$rdate'" -f stat-member_base.sql "dbname=xueshandai user=xsd password=Xsd123$" 

# borrow_wide  
psql  -v pt="'$rdate'" -f stat-borrow.sql "dbname=xueshandai user=xsd password=Xsd123$"

# borrow_invest_wide
psql  -v pt="'$rdate'" -f stat-borrow_invest.sql "dbname=xueshandai user=xsd password=Xsd123$"

# member_wide
psql  -v pt="'$rdate'" -f stat-member_wide.sql "dbname=xueshandai user=xsd password=Xsd123$"




