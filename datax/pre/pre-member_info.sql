drop table if exists member_info_map;
create table member_info_map as 
select member_id,birthday,age,gender,region as idcard_region,'' as current_address
from (
select id,member_id
,substring(birthday from 1 for 10) as birthday
,EXTRACT(EPOCH FROM ( now()-birthday::TIMESTAMP )) /60/60/24/365 as age
,substring(gender from '[男女]') as gender
,region
from member_id_card_info
) a 
;

