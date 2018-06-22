# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

# nginx
sh import-nginxlog.sh $rdate_d

# =======全量更新================================
# # mold
sh import-mold.sh $rdate_pt

# # vip_grade
sh import-vip_grade.sh $rdate_pt

# # weixin_binding
sh import-weixin_binding.sh $rdate_pt

# =======================================

# # member
sh import-member.sh $rdate_pt

# # borrow
sh import-borrow.sh $rdate_pt

# # borrow_invest
sh import-borrow_invest.sh $rdate_pt

# # cash_flow
sh import-cash_flow.sh $rdate_pt

# # card_coupons_batch
sh import-card_coupons_batch.sh $rdate_pt

# # card_coupons_detail
sh import-card_coupons_detail.sh $rdate_pt

# # repayment_detail
sh import-repayment_detail.sh $rdate_pt

# # repayment_history
sh import-repayment_history.sh $rdate_pt

# # receipt_detail
sh import-receipt_detail.sh $rdate_pt

# # receipt_history
sh import-receipt_history.sh $rdate_pt

# # account
sh import-account.sh $rdate_pt

# # account_recharge
sh import-account_recharge.sh $rdate_pt

# # account_withdraw
sh import-account_withdraw.sh $rdate_pt


# # recommend
sh import-recommend.sh $rdate_pt

# # member_info
sh import-member_info.sh $rdate_pt


# # transfer_detail
sh import-transfer_detail.sh $rdate_pt


# # member_signin
sh import-member_signin.sh $rdate_pt

# # credit_card_payment 
# sh import-credit_card_payment.sh $rdate_pt  # 目前不更新数据


# # vip_association
sh import-vip_association.sh $rdate_pt

# # member_vip
sh import-member_vip.sh $rdate_pt


# # notice
sh import-notice.sh $rdate_pt

# # notice_his
sh import-notice_his.sh $rdate_pt

