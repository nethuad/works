drop table dim__transfer_detail__capital_type;
create table dim__transfer_detail__capital_type as 
select capital_type[1] as capital_type,capital_type[2] as capital_type_name 
from (
select regexp_split_to_array(capital_type,'-') as capital_type
from (
select unnest(ARRAY[
'0-其他' 
,'1-全额充值' 
,'2-全额余额联盈回款'
,'3-全额投资回款' 
,'4-混合资金' 
,'5-续投奖励'
,'6-活动奖励'  
,'7-雪银票抽奖奖励'  
,'8-新手首投特权奖励'
,'9-信用卡还款奖励'  
,'10-新春红包'  
,'11-微信关注红包'
,'12-信用卡还款推荐人奖励'  
,'13-话费充值推荐人奖励'  
,'14-雪山贷十人计划'
,'15-首投抽奖奖励'  
,'16-新手体验标奖励'  
,'17-双节喜相逢'
,'18-转账投资账户奖励' 
,'21-迎新春，翻牌有礼'
] ) as capital_type
) a ) a 
;
