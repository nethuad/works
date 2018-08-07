echo start @ `date '+%Y-%m-%d %H:%M:%S'`

# 导入数据
sh import/import-all.sh

# 预处理
sh pre/pre-all.sh

# 中间过程
sh proc/proc-all.sh

# 画像过程
sh portrait/portrait-all.sh

# 报表脚本
sh report/report-all.sh

# 临时报表脚本
sh tmpreport/tmpreport-all.sh


echo end @ `date '+%Y-%m-%d %H:%M:%S'`

