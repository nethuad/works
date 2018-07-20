delete from account_bank 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO account_bank 
SELECT id
,member_id,bank_name,bank_account,version,date_created,last_updated,created_by,updated_by
,bank_sub_name,bank_city_id,operate_status,authenticate_status,auditing_status,bank_code
,auditing_delete_status,third_bank_code,third_bank_id
,pt
FROM dbo_account_bank_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_account_bank_dadd where pt=:pt;