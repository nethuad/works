# `date +%Y-%m-%d`

rdate_d=`date -d last-day +%Y-%m-%d`

rdate_pt=`date -d last-day +%Y%m%d`

echo d=$rdate_d
echo pt=$rdate_pt

# nginx
sh import/import-nginxlog.sh $rdate_d

# =======全量更新================================
# # mold
sh import/import-mold.sh $rdate_pt

# # enterprise_info
sh import/import-enterprise_info.sh $rdate_pt

# # vip_grade
sh import/import-vip_grade.sh $rdate_pt

# # weixin_binding
sh import/import-weixin_binding.sh $rdate_pt

# # member_xmgj_transfer
# sh import/import-member_xmgj_transfer.sh $rdate_pt

# # member_xmgj_zhaiquan
sh import/import-member_xmgj_zhaiquan.sh $rdate_pt

# # platform_customer (存管平台)
sh import/import-platform_customer.sh $rdate_pt

# =======================================

# # member
sh import/import-member.sh $rdate_pt

# # borrow
sh import/import-borrow.sh $rdate_pt

# # borrow_invest
sh import/import-borrow_invest.sh $rdate_pt

# # cash_flow
sh import/import-cash_flow.sh $rdate_pt

# # card_coupons_batch
sh import/import-card_coupons_batch.sh $rdate_pt

# # card_coupons_detail
sh import/import-card_coupons_detail.sh $rdate_pt

# # repayment_detail
sh import/import-repayment_detail.sh $rdate_pt

# # repayment_history
sh import/import-repayment_history.sh $rdate_pt

# # receipt_detail
sh import/import-receipt_detail.sh $rdate_pt

# # receipt_history
sh import/import-receipt_history.sh $rdate_pt

# # account
sh import/import-account.sh $rdate_pt

# # account_recharge
sh import/import-account_recharge.sh $rdate_pt

# # account_withdraw
sh import/import-account_withdraw.sh $rdate_pt

# # account_bank
sh import/import-account_bank.sh $rdate_pt

# # recommend
sh import/import-recommend.sh $rdate_pt

# # member_info
sh import/import-member_info.sh $rdate_pt


# # transfer_detail
sh import/import-transfer_detail.sh $rdate_pt


# # member_signin
sh import/import-member_signin.sh $rdate_pt

# # credit_card_payment 
# sh import/import-credit_card_payment.sh $rdate_pt  # 目前不更新数据


# # vip_association
sh import/import-vip_association.sh $rdate_pt

# # member_vip
sh import/import-member_vip.sh $rdate_pt


# # notice
sh import/import-notice.sh $rdate_pt

# # notice_his
sh import/import-notice_his.sh $rdate_pt

# # weixin_activity
sh import/import-weixin_activity.sh $rdate_pt

# # register_attach_info
sh import/import-register_attach_info.sh $rdate_pt


