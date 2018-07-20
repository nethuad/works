delete from weixin_activity 
where date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD');

INSERT INTO weixin_activity 
SELECT id,member_id,open_id,nick_name,head_imgurl,info,user_id,user_open_id,user_nick_name,
info_other,myself,capital,status,active_type,date_created,last_updated,version
,pt
FROM dbo_weixin_activity_dadd
where pt=:pt
and date_created>=to_char(to_timestamp(:pt,'YYYYMMDD'),'YYYY-MM-DD')
;

-- 清空增量数据
DELETE FROM dbo_weixin_activity_dadd where pt=:pt;