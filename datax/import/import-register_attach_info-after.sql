delete from register_attach_info 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO register_attach_info 
SELECT id,register_user_id,register_user_name,req_ip,req_url,req_param,referer
,register_location,referer_type,sid,date_created,version,last_updated,created_by,updated_by
,pt
FROM dbo_register_attach_info_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_register_attach_info_dadd where pt=:pt;