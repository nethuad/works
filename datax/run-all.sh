echo start @ `date '+%Y-%m-%d %H:%M:%S'`

rdate_d=`date -d last-day +%Y-%m-%d`
rdate_pt=`date -d last-day +%Y%m%d`
rdate_curr_d=`date +%Y-%m-%d`

# rdate_d=2018-08-25
# rdate_pt=20180825
# rdate_curr_d=2018-08-26


# 导入数据
sh import/import-all.sh $rdate_d $rdate_pt

# 预处理
sh pre/pre-all.sh $rdate_d $rdate_pt $rdate_curr_d

# 中间过程
sh proc/proc-all.sh $rdate_d $rdate_pt $rdate_curr_d

# 画像过程
sh portrait/portrait-all.sh

# 报表脚本
sh report/report-all.sh

# 临时报表脚本
sh tmpreport/tmpreport-all.sh


echo end @ `date '+%Y-%m-%d %H:%M:%S'`

