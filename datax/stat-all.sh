# 数据统计

rdate=$1

# borrow_wide
psql  -v pt="'$rdate'" -f stat-borrow.sql "dbname=xueshandai user=xsd password=Xsd123$"

# member_wide
psql  -v pt="'$rdate'" -f stat-member.sql "dbname=xueshandai user=xsd password=Xsd123$"


