echo "proc/ip/proc-ip-run_all"

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

d_yestoday=`date -d last-day +%Y-%m-%d`

d_today=`date +%Y-%m-%d`


db_connection="dbname=xueshandai user=xueshandai password=Xueshandai123$"

# 获取当天的ip ,同时获取没有映射的ip
psql -v d="'$rdate_d'" -f proc/ip/proc-nginxlog_ip_cid_uid.sql "$db_connection"


# 获取ip映射
python3 utils/get_ip_province.py


# 合并 ip映射表
psql -f proc/ip/proc-merge-ip_map_province.sql "$db_connection"

# 生成ip省份映射表
psql -v d="'$rdate_d'" -f proc/ip/proc-nginxlog_ip_cid_uid_province.sql "$db_connection"
