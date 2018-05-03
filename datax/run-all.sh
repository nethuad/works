# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

# nginx
sh run-nginxlog.sh $rdate_d

# member
sh run-member.sh $rdate_pt

# recommend
sh run-recommend.sh $rdate_pt

# borrow
sh run-borrow.sh $rdate_pt

# borrow_invest
sh run-borrow_invest.sh $rdate_pt

# cash_flow
sh run-cash_flow.sh $rdate_pt

# repayment_detail
sh run-repayment_detail.sh $rdate_pt

# repayment_history
sh run-repayment_history.sh $rdate_pt

# receipt_detail
sh run-receipt_detail.sh $rdate_pt

# receipt_history
sh run-receipt_history.sh $rdate_pt

# mold
sh run-mold.sh $rdate_pt

# credit_card_payment 
# sh run-credit_card_payment.sh $rdate_pt  # 目前不更新数据

# transfer_detail
sh run-transfer_detail.sh $rdate_pt


# account
sh run-account.sh $rdate_pt

# account_recharge
sh run-account_recharge.sh $rdate_pt

# account_withdraw
sh run-account_withdraw.sh $rdate_pt

# member_info
sh run-member_info.sh $rdate_pt

# member_signin
sh run-member_signin.sh $rdate_pt

# statistics
sh stat-all.sh $rdate_pt

# report

sh report-all.sh $rdate_pt

# portrait
sh portrait-all.sh $rdate_pt


