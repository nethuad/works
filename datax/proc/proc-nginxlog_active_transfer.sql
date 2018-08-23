-- 外部活动流量


/*

drop table active_transfer_code;
create table active_transfer_code as 
select a[1]::varchar(100) as transfer_code
,a[2]::varchar(100) as transfer_sid
,(a[1]||case when a[2]='~' then '' else '_'||a[2] end)::varchar(100) as transfer_slug
,a[3]::varchar(100) as transfer_name

from (
select 
regexp_split_to_array(a,'\|') as a
from (
select 
unnest(
ARRAY[
'apptc|~|弹屏APP',
'appbanner|~|BANNER_APP',
'mbanner|~|BANNER_M',
'wbanner|~|BANNER_PC',
'post|~|水军海报',
'wxhb|~|公众号推荐海报',
'wxmenu|~|公众号菜单',
'appinvite|~|推荐奖励_APP',
'minvite|~|推荐奖励_M',
'winvite|~|推荐奖励_PC',
'wsearch|~|搜索_PC',
'msearch|~|搜索_M',
'sms|~|短信',
'wxshare|~|活动分享',
'mcps|mtimount|天芒云m端',
'wcps|wtimount|天芒云web端',
'mcps|mp2peyeb|网贷天眼banner_m端',
'wcps|wp2peyeb|网贷天眼banner_web端',
'mcps|mthomson|汤姆逊m端',
'wcps|wthomson|汤姆逊web端',
'mcps|mqishuo|祺硕m端',
'wcps|wqishuo|祺硕web端',
'mcps|mairuix|艾瑞星m端',
'wcps|wairuix|艾瑞星web端',
'mcps|myingdie|映蝶m端',
'wcps|wyingdie|映蝶web端',
'mcps|mmojifen|魔积分m端',
'wcps|wmojifen|魔积分web端'
]) as a 
) a 
) a 
;




m端： https://m.xueshandai.com/active/transfer?code=mcps&sid=mtimount
web端 ： https://m.xueshandai.com/active/transfer?code=wcps&sid=wtimount

弹屏 APP	http://m.xueshandai.com/active/transfer?app=true&code=apptc	
BANNER APP	http://m.xueshandai.com/active/transfer?app=true&code=appbanner	
BANNER M	http://m.xueshandai.com/active/transfer?code=mbanner	
BANNER PC	http://m.xueshandai.com/active/transfer?code=wbanner	
水军海报	http://m.xueshandai.com/active/transfer?code=post	
公众号推荐海报	https://m.xueshandai.com/active/transfer?code=wxhb	
公众号菜单	https://m.xueshandai.com/active/transfer?code=wxmenu	
推荐奖励 APP	https://m.xueshandai.com/active/transfer?code=appinvite	
推荐奖励 M	https://m.xueshandai.com/active/transfer?code=minvite	
推荐奖励 PC	https://m.xueshandai.com/active/transfer?code=winvite	
搜索 PC	https://m.xueshandai.com/active/transfer?code=wsearch	
搜索 M	https://m.xueshandai.com/active/transfer?code=msearch	
短信	https://m.xueshandai.com/active/transfer?code=sms	
活动分享	https://m.xueshandai.com/active/transfer?code=wxshare


create table nginxlog_active_transfer_detail as 
select *
from nginxlog_uid
where 1=1
and host='m.xueshandai.com' and path = '/active/transfer'
;


select *
,substring(query from 'code=([A-Za-z1-9]+)') as transfer_code
,substring(query from 'sid=([A-Za-z1-9]+)') as transfer_sid
，json_extract_path_text(referer_ps::json,'netloc') as referer_host

*/

drop table if exists nginxlog_active_transfer_ext;
create table nginxlog_active_transfer_ext as 
select *
,substring(query from 'code=([A-Za-z1-9]+)') as transfer_code
,substring(query from 'sid=([A-Za-z1-9]+)') as transfer_sid
,substring(query from 'code=([A-Za-z1-9]+)')|| 
   case when substring(query from 'sid=([A-Za-z1-9]+)') is null then '' else '_'||substring(query from 'sid=([A-Za-z1-9]+)') end  
 as transfer_slug
,json_extract_path_text(referer_ps::json,'netloc') as referer_host
,json_extract_path_text(referer_ps::json,'path') as referer_path
from nginxlog_active_transfer
;

drop table if exists nginxlog_active_transfer_ext_detail;
create table nginxlog_active_transfer_ext_detail as 
select a.*
,coalesce(b.transfer_name,a.transfer_slug,'未识别') as transfer_name
from nginxlog_active_transfer_ext a 
left outer join active_transfer_code b on a.transfer_slug=b.transfer_slug
;






